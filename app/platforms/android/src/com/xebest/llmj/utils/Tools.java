package com.xebest.llmj.utils;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.AnimationDrawable;
import android.graphics.drawable.ColorDrawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Handler;
import android.os.Message;
import android.telephony.TelephonyManager;
import android.text.Html;
import android.text.TextUtils;
import android.view.Display;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.xebest.llmj.R;
import com.xebest.llmj.application.Application;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.Timer;
import java.util.TimerTask;

/**
 * 公用工具
 * Created by kaisun on 15/7/13.
 */
public class Tools {

    /**
     * 没有网络
     */
    public static final int NETWORKTYPE_INVALID = 0;
    /**
     * wap网络
     */
    public static final int NETWORKTYPE_WAP = 1;
    /**
     * 2G网络
     */
    public static final int NETWORKTYPE_2G = 2;
    /**
     * 3G和3G以上网络，或统称为快速网络
     */
    public static final int NETWORKTYPE_3G = 3;
    /**
     * wifi网络
     */
    public static final int NETWORKTYPE_WIFI = 4;

    /**
     * 获取网络状态，wifi,wap,2g,3g.
     *
     * @param context 上下文
     * @return int 网络状态 {@link #NETWORKTYPE_2G},{@link #NETWORKTYPE_3G},
     * *{@link #NETWORKTYPE_INVALID},{@link #NETWORKTYPE_WAP}* <p>{@link #NETWORKTYPE_WIFI}
     */
    public static int getNetWorkType(Context context) {
        int mNetWorkType = -1;
        ConnectivityManager manager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = manager.getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            String type = networkInfo.getTypeName();
            if (type.equalsIgnoreCase("WIFI")) {
                mNetWorkType = NETWORKTYPE_WIFI;
            } else if (type.equalsIgnoreCase("MOBILE")) {
                String proxyHost = android.net.Proxy.getDefaultHost();
                mNetWorkType = TextUtils.isEmpty(proxyHost)
                        ? (isFastMobileNetwork(context) ? NETWORKTYPE_3G : NETWORKTYPE_2G)
                        : NETWORKTYPE_WAP;
            }
        } else {
            mNetWorkType = NETWORKTYPE_INVALID;
        }
        return mNetWorkType;
    }

    public static boolean isFastMobileNetwork(Context context) {
        TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        switch (telephonyManager.getNetworkType()) {
            case TelephonyManager.NETWORK_TYPE_1xRTT:
                return false; // ~ 50-100 kbps
            case TelephonyManager.NETWORK_TYPE_CDMA:
                return false; // ~ 14-64 kbps
            case TelephonyManager.NETWORK_TYPE_EDGE:
                return false; // ~ 50-100 kbps
            case TelephonyManager.NETWORK_TYPE_EVDO_0:
                return true; // ~ 400-1000 kbps
            case TelephonyManager.NETWORK_TYPE_EVDO_A:
                return true; // ~ 600-1400 kbps
            case TelephonyManager.NETWORK_TYPE_GPRS:
                return false; // ~ 100 kbps
            case TelephonyManager.NETWORK_TYPE_HSDPA:
                return true; // ~ 2-14 Mbps
            case TelephonyManager.NETWORK_TYPE_HSPA:
                return true; // ~ 700-1700 kbps
            case TelephonyManager.NETWORK_TYPE_HSUPA:
                return true; // ~ 1-23 Mbps
            case TelephonyManager.NETWORK_TYPE_UMTS:
                return true; // ~ 400-7000 kbps
            case TelephonyManager.NETWORK_TYPE_EHRPD:
                return true; // ~ 1-2 Mbps
            case TelephonyManager.NETWORK_TYPE_EVDO_B:
                return true; // ~ 5 Mbps
            case TelephonyManager.NETWORK_TYPE_HSPAP:
                return true; // ~ 10-20 Mbps
            case TelephonyManager.NETWORK_TYPE_IDEN:
                return false; // ~25 kbps
            case TelephonyManager.NETWORK_TYPE_LTE:
                return true; // ~ 10+ Mbps
            case TelephonyManager.NETWORK_TYPE_UNKNOWN:
                return false;
            default:
                return false;
        }
    }

    // 加载中...
    private static Dialog loadingDialog;

    /**
     * dismiss
     */
    public static void dismissLoading() {
        if (anim != null) {
            anim.stop();
        }
        if (loadingDialog != null) {
            loadingDialog.dismiss();
        }
        timer.cancel();
        task.cancel();
    }

    public static void showSuccessToast(Context context, String message) {
        View layout = LayoutInflater.from(context).inflate(R.layout.loading_success, null);
        TextView title = (TextView) layout.findViewById(R.id.message);
        title.setText(Html.fromHtml(message));
        Toast toast = new Toast(context);
        toast.setGravity(Gravity.CENTER, 0, 0);
        toast.setDuration(Toast.LENGTH_SHORT);
        toast.setView(layout);
        toast.show();
    }

    public static void showErrorToast(Context context, String message) {
        View layout = LayoutInflater.from(context).inflate(R.layout.loading_error, null);
        TextView title = (TextView) layout.findViewById(R.id.message);
        title.setText(Html.fromHtml(message));
        Toast toast = new Toast(context);
        toast.setGravity(Gravity.CENTER, 0, 0);
        toast.setDuration(Toast.LENGTH_SHORT);
        toast.setView(layout);
        toast.show();
    }

    public static void showToast(Context context, String message) {
        Toast.makeText(context, Html.fromHtml(message), Toast.LENGTH_SHORT).show();
    }

    static AnimationDrawable anim;

    /**
     * Cordova Loading
     *
     * @param context
     * @param text
     * @return
     */
    public static void createLoadingDialog(Activity context, String text) {
        if (text == null || text.equals("") || text.equals("undefined") || text.equals("null")) {
            text = "加载中...";
        }
        View view = context.getLayoutInflater().inflate(R.layout.progress_hud, null);
        TextView msg = (TextView) view.findViewById(R.id.message);
        msg.setText(Html.fromHtml(text));

        ImageView spaceshipImage = (ImageView) view.findViewById(R.id.spinnerImageView);
        // 加载动画
        anim = (AnimationDrawable) spaceshipImage.getBackground();

        loadingDialog = new Dialog(context, R.style.DialogTheme);
        Window window = loadingDialog.getWindow();
        // window.setWindowAnimations(R.drawable.animation);
        window.setBackgroundDrawable(new ColorDrawable(0));
        Display display = context.getWindowManager().getDefaultDisplay();
        WindowManager.LayoutParams lp = window.getAttributes();
        lp.width = (int) (display.getWidth() * 0.9);
        lp.alpha = 0.8f;
        window.setAttributes(lp);
        window.setContentView(view);
        // 点击dialog外部不让其消失
        loadingDialog.setCanceledOnTouchOutside(false);
        loadingDialog.setCancelable(false);
        loadingDialog.show();

        firstTime = System.currentTimeMillis();

        if (timer != null) {
            timer.cancel();
        }
        timer = new Timer();

        if (task != null) {
            task.cancel();
        }
        task = new TimerTask() {
            @Override
            public void run() {
                long now = System.currentTimeMillis();
                if (now - firstTime > 20000) {
                    handler.sendEmptyMessage(1);
                }
            }
        };

        timer.schedule(task, 0, 1000);

        anim.start();
    }

    private static long firstTime = 0L;


    static Timer timer;

    static TimerTask task;

    static private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg.what == 1) {
                loadingDialog.dismiss();
                timer.cancel();
                task.cancel();
                showErrorToast(Application.getInstance(), "请求超时!");
            }
        }
    };

    /**
     * Custom Dialog
     *
     * @param context
     * @param layout
     * @param event
     * @return
     */
    @SuppressWarnings("deprecation")
    public static Dialog getCustomDialog(final Activity context, int layout,
                                         BindEventView event) {
        View view = context.getLayoutInflater().inflate(layout, null);
        final Dialog dialog = new Dialog(context, R.style.DialogTheme);
        Window window = dialog.getWindow();
        // window.setWindowAnimations(R.drawable.animation);
        window.setBackgroundDrawable(new ColorDrawable(0));
        Display display = context.getWindowManager().getDefaultDisplay();
        WindowManager.LayoutParams lp = window.getAttributes();
        lp.width = (int) (display.getWidth() * 0.9);
        window.setAttributes(lp);
        window.setContentView(view);
        if (null != event) {
            event.bindEvent(view);
        }
        dialog.setCanceledOnTouchOutside(true);
        dialog.setCancelable(true);
        dialog.show();

        return dialog;

    }

    public static Dialog getCustomDialogBg(final Activity context, int layout,
                                         BindEventView event) {
        View view = context.getLayoutInflater().inflate(layout, null);
        final Dialog dialog = new Dialog(context, R.style.DialogThemeBg);
        Window window = dialog.getWindow();
        // window.setWindowAnimations(R.drawable.animation);
        window.setBackgroundDrawable(new ColorDrawable(0));
        Display display = context.getWindowManager().getDefaultDisplay();
        WindowManager.LayoutParams lp = window.getAttributes();
        lp.width = (int) (display.getWidth() * 0.9);
        window.setAttributes(lp);
        window.setContentView(view);
        if (null != event) {
            event.bindEvent(view);
        }
        dialog.setCanceledOnTouchOutside(true);
        dialog.setCancelable(true);
        dialog.show();

        return dialog;

    }

    public interface BindEventView {
        void bindEvent(View view);
    }

    public static Bitmap getimage(String srcPath) {
        BitmapFactory.Options newOpts = new BitmapFactory.Options();
        //开始读入图片，此时把options.inJustDecodeBounds 设回true了
        newOpts.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeFile(srcPath,newOpts);//此时返回bm为空

        newOpts.inJustDecodeBounds = false;
        int w = newOpts.outWidth;
        int h = newOpts.outHeight;
        //现在主流手机比较多是800*480分辨率，所以高和宽我们设置为
        float hh = 800f;//这里设置高度为800f
        float ww = 480f;//这里设置宽度为480f
        //缩放比。由于是固定比例缩放，只用高或者宽其中一个数据进行计算即可
        int be = 1;//be=1表示不缩放
        if (w > h && w > ww) {//如果宽度大的话根据宽度固定大小缩放
            be = (int) (newOpts.outWidth / ww);
        } else if (w < h && h > hh) {//如果高度高的话根据宽度固定大小缩放
            be = (int) (newOpts.outHeight / hh);
        }
        if (be <= 0)
            be = 1;
        newOpts.inSampleSize = be;//设置缩放比例
        //重新读入图片，注意此时已经把options.inJustDecodeBounds 设回false了
        bitmap = BitmapFactory.decodeFile(srcPath, newOpts);
        return compressImage(bitmap);//压缩好比例大小后再进行质量压缩
    }

    public static Bitmap compressImage(Bitmap image) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, 100, baos);//质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        int options = 100;
        while ( baos.toByteArray().length / 1024 > 50) {  //循环判断如果压缩后图片是否大于100kb,大于继续压缩
            baos.reset();//重置baos即清空baos
            image.compress(Bitmap.CompressFormat.JPEG, options, baos);//这里压缩options%，把压缩后的数据存放到baos中
            options -= 10;//每次都减少10
        }
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());//把压缩后的数据baos存放到ByteArrayInputStream中
        Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, null);//把ByteArrayInputStream数据生成图片
        return bitmap;
    }

    private static boolean isShow = true;
    public static void toast(Context context, String msg) {
        if (!isShow) return;
        Toast.makeText(context, msg, Toast.LENGTH_LONG).show();
    }

}
