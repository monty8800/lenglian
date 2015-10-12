package com.xebest.llmj.utils;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.widget.ImageView;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.ref.SoftReference;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.WeakHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ImageLoader {
	private int stub_id = 0;
	MemoryCache memoryCache = new MemoryCache();
	FileCache fileCache;
	private Map<ImageView, String> imageViews = Collections
			.synchronizedMap(new WeakHashMap<ImageView, String>());
	// 线程池
	ExecutorService executorService;
	int setSize = 200;

	public ImageLoader(Context context, int imageid) {
		this.stub_id = imageid;
		fileCache = new FileCache(context);
		executorService = Executors.newFixedThreadPool(5);

	}

	public void setSize(int size) {
		setSize = size;
	}

	// 当进入listview时默认的图片，可换成你自己的默认图片
	// final int stub_id = R.drawable.ic_launcher;

	// 最主要的方法
	public void DisplayImage(String url, ImageView imageView) {
		imageViews.put(imageView, url);
		// 先从内存缓存中查找

		Bitmap bitmap = memoryCache.get(url);
		if (bitmap != null) {
			// imageView.setImageBitmap(bitmap);
			BitmapDrawable drawable = new BitmapDrawable(bitmap);
			imageView.setBackgroundDrawable(drawable);

		} else {
			// 若没有的话则开启新线程加载图片
			queuePhoto(url, imageView);
			imageView.setBackgroundResource(stub_id);
		}
	}

	private void queuePhoto(String url, ImageView imageView) {
		PhotoToLoad p = new PhotoToLoad(url, imageView);
		executorService.submit(new PhotosLoader(p));
	}

	private Bitmap getBitmap(String url) {
		File f = fileCache.getFile(url);
		// 先从文件缓存中查找是否有
		Bitmap b = decodeFile(f);
		if (b != null)
			return b;

		// 最后从指定的url中下载图片
		try {
			Bitmap bitmap = null;
			URL imageUrl = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) imageUrl
					.openConnection();
			conn.setConnectTimeout(30000);
			conn.setReadTimeout(30000);
			conn.setInstanceFollowRedirects(true);
			InputStream is = conn.getInputStream();
			OutputStream os = new FileOutputStream(f);
			CopyStream(is, os);
			os.close();
			bitmap = decodeFile(f);
			return bitmap;
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}

	// decode这个图片并且按比例缩放以减少内存消耗，虚拟机对每张图片的缓存大小也是有限制的
	private Bitmap decodeFile(File f) {
		try {
			// decode image size
			BitmapFactory.Options o = new BitmapFactory.Options();
			o.inJustDecodeBounds = true;
			BitmapFactory.decodeStream(new FileInputStream(f), null, o);

			// Find the correct scale value. It should be the power of 2.

			final int REQUIRED_SIZE = setSize;

			int width_tmp = o.outWidth, height_tmp = o.outHeight;
			int scale = 1;
			while (true) {
				if (width_tmp / 2 < REQUIRED_SIZE
						|| height_tmp / 2 < REQUIRED_SIZE)
					break;
				width_tmp = width_tmp / 2;
				height_tmp = height_tmp / 2;
				scale *= 2;
			}

			// decode with inSampleSize
			BitmapFactory.Options o2 = new BitmapFactory.Options();
			o2.inSampleSize = scale;
			return BitmapFactory.decodeStream(new FileInputStream(f), null, o2);
		} catch (FileNotFoundException e) {
		}
		return null;
	}

	// Task for the queue
	private class PhotoToLoad {
		public String url;
		public ImageView imageView;

		public PhotoToLoad(String u, ImageView i) {
			url = u;
			imageView = i;
		}
	}

	class PhotosLoader implements Runnable {
		PhotoToLoad photoToLoad;

		PhotosLoader(PhotoToLoad photoToLoad) {
			this.photoToLoad = photoToLoad;
		}

		@Override
		public void run() {
			if (imageViewReused(photoToLoad))
				return;
			// 下载图片
			Bitmap bmp = getBitmap(photoToLoad.url);
			memoryCache.put(photoToLoad.url, bmp);
			if (imageViewReused(photoToLoad))
				return;
			BitmapDisplayer bd = new BitmapDisplayer(bmp, photoToLoad);
			// 更新的操作放在UI线程中
			Activity a = (Activity) photoToLoad.imageView.getContext();
			a.runOnUiThread(bd);
		}
	}

	/**
	 * 防止图片错位
	 * 
	 * @param photoToLoad
	 * @return
	 */
	boolean imageViewReused(PhotoToLoad photoToLoad) {
		String tag = imageViews.get(photoToLoad.imageView);
		if (tag == null || !tag.equals(photoToLoad.url))
			return true;
		return false;
	}

	// 用于在UI线程中更新界面
	class BitmapDisplayer implements Runnable {
		Bitmap bitmap;
		PhotoToLoad photoToLoad;

		public BitmapDisplayer(Bitmap b, PhotoToLoad p) {
			bitmap = b;
			photoToLoad = p;
		}

		public void run() {
			if (imageViewReused(photoToLoad))
				return;
			if (bitmap != null) {
				// Bitmap bmap = toRoundCorner(bitmap, 5);

				// bitmap转化为Drawable 然后setBackground(),不能用setImageBitmap，否则图片会变小
				Drawable bd = new BitmapDrawable(bitmap);
				photoToLoad.imageView.setBackgroundDrawable(bd);
				// photoToLoad.imageView.setImageBitmap(bmap);
			} else {
				photoToLoad.imageView.setBackgroundResource(stub_id);
			}

		}
	}

	public void clearCache() {
		memoryCache.clear();
		fileCache.clear();
	}

	public void CopyStream(InputStream is, OutputStream os) {
		final int buffer_size = 1024;
		try {
			byte[] bytes = new byte[buffer_size];
			for (;;) {
				int count = is.read(bytes, 0, buffer_size);
				if (count == -1)
					break;
				os.write(bytes, 0, count);
			}
		} catch (Exception ex) {
		}
	}

	public class MemoryCache {

		private Map<String, SoftReference<Bitmap>> cache = Collections
				.synchronizedMap(new HashMap<String, SoftReference<Bitmap>>());

		public Bitmap get(String id) {
			if (!cache.containsKey(id))
				return null;
			SoftReference<Bitmap> ref = cache.get(id);
			return ref.get();
		}

		public void put(String id, Bitmap bitmap) {
			cache.put(id, new SoftReference<Bitmap>(bitmap));
		}

		public void clear() {
			cache.clear();
		}

	}

	public class FileCache {

		private File cacheDir;

		public FileCache(Context context) {
			// 如果有SD卡则在SD卡中建一个LazyList的目录存放缓存的图片
			// 没有SD卡就放在系统的缓存目录中
			if (android.os.Environment.getExternalStorageState().equals(
					android.os.Environment.MEDIA_MOUNTED))
				cacheDir = new File(
						android.os.Environment.getExternalStorageDirectory()
								+ "/JWZT", "Images");
			else
				cacheDir = context.getCacheDir();
			if (!cacheDir.exists())
				cacheDir.mkdirs();
		}

		public File getFile(String url) {
			// 将url的hashCode作为缓存的文件名
			String filename = String.valueOf(url.hashCode());
			// Another possible solution
			// String filename = URLEncoder.encode(url);
			File f = new File(cacheDir, filename);
			return f;

		}

		public void clear() {
			File[] files = cacheDir.listFiles();
			if (files == null)
				return;
			for (File f : files)
				f.delete();
		}

	}

	/**
	 * 
	 * 把图片变成圆角
	 * 
	 * @param bitmap
	 *            需要修改的图片
	 * 
	 * @param pixels
	 *            圆角的弧度
	 * 
	 * @return 圆角图片
	 */

	public static Bitmap toRoundCorner(Bitmap bitmap, int pixels) {

		Bitmap output = Bitmap.createBitmap(bitmap.getWidth(),
				bitmap.getHeight(), Config.ARGB_8888);

		Canvas canvas = new Canvas(output);

		final int color = 0xff424242;

		final Paint paint = new Paint();

		final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());

		final RectF rectF = new RectF(rect);

		final float roundPx = pixels;

		paint.setAntiAlias(true);

		paint.setFilterBitmap(true);
		paint.setDither(true);

		canvas.drawARGB(0, 0, 0, 0);

		paint.setColor(color);

		canvas.drawRoundRect(rectF, roundPx, roundPx, paint);

		paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));

		canvas.drawBitmap(bitmap, rect, rect, paint);

		return output;

	}

}
