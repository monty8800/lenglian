package com.xebest.app.car;

import android.app.Activity;
import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.umeng.analytics.MobclickAgent;
import com.xebest.app.R;
import com.xebest.app.application.ApiUtils;
import com.xebest.app.application.Application;
import com.xebest.app.common.BaseCordovaActivity;
import com.xebest.app.utils.Tools;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * 发布车源
 * Created by kaisun on 15/9/22.
 */
public class ReleaseCarActivity extends BaseCordovaActivity implements CordovaInterface {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private Dialog mDialog;

    private String localTempImgDir = "tempPic";

    private String localTempImgFileName = "p_0923.jpg";

    public final int GET_IMAGE_VIA_CAMERA = 10001;

    public final int IMAGE_CODE = 10002;

    private List<String> paths = new ArrayList<String>();

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, ReleaseCarActivity.class));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.cwebview);

        initView();
    }

    protected void initView() {
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("发布车源");
        mWebView = (XEWebView) findViewById(R.id.wb);
        backView = findViewById(R.id.rlBack);
        backView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        if (args.toString().contains("pic")) {
            showWindow();
        } else if (args.toString().contains("temp")) {
            Log.i("info", "--------list:" + paths);
        }
    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("发布车源");
        // 统计时长
        MobclickAgent.onResume(this);
        mWebView.init(this, ApiUtils.API_COMMON_URL + "releaseVehicle.html", this, this, this, this);
        super.onResume();
    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("发布车源");
        MobclickAgent.onPause(this);
    }

    @Override
    public void startActivityForResult(CordovaPlugin command, Intent intent, int requestCode) {

    }

    @Override
    public void setActivityResultCallback(CordovaPlugin plugin) {

    }

    @Override
    public Activity getActivity() {
        return this;
    }

    @Override
    public Object onMessage(String id, Object data) {
        mWebView.getWebView().loadUrl("javascript:(function(){uuid='" + Application.UUID + "';version='" + ((Application) getApplicationContext()).VERSIONCODE + "';client_type='2';})();");
        return null;
    }

    public void showWindow() {
        mDialog = Tools.getCustomDialog(this, R.layout.choose_cg, new Tools.BindEventView() {
            @Override
            public void bindEvent(View view) {
                TextView tvCamera = (TextView) view.findViewById(R.id.camera);
                TextView tvGallery = (TextView) view.findViewById(R.id.grally);
                tvGallery.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        mDialog.dismiss();
                        Intent getAlbum = new Intent(Intent.ACTION_GET_CONTENT);
                        getAlbum.setType("image/*");
                        startActivityForResult(getAlbum, IMAGE_CODE);
                    }
                });
                tvCamera.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        mDialog.dismiss();
                        String status = Environment.getExternalStorageState();
                        if(status.equals(Environment.MEDIA_MOUNTED)) {
                            localTempImgFileName = System.currentTimeMillis() + ".jpg";
                            try {
                                File dir=new File(Environment.getExternalStorageDirectory() + "/" + localTempImgDir);
                                if(!dir.exists()) dir.mkdirs();
                                Intent intent=new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
                                File f = new File(dir, localTempImgFileName);//localTempImgDir和localTempImageFileName是自己定义的名字
                                Uri u = Uri.fromFile(f);
                                intent.putExtra(MediaStore.Images.Media.ORIENTATION, 0);
                                intent.putExtra(MediaStore.EXTRA_OUTPUT, u);
                                startActivityForResult(intent, GET_IMAGE_VIA_CAMERA);
                            } catch (ActivityNotFoundException e) {
                                Toast.makeText(ReleaseCarActivity.this, "没有找到储存目录", Toast.LENGTH_LONG).show();
                            }
                        }else{
                            Toast.makeText(ReleaseCarActivity.this, "没有储存卡",Toast.LENGTH_LONG).show();
                        }
                    }
                });
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {

        if(resultCode == RESULT_OK ) {
            switch(requestCode) {
                case GET_IMAGE_VIA_CAMERA:

                    String pat = Environment.getExternalStorageDirectory()
                            + "/" + localTempImgDir + "/" + localTempImgFileName;

                    Log.i("info", "---------f:" + pat);

                    Bitmap bitmap = BitmapFactory.decodeFile(pat);
                    Log.i("info", "---------bitmap:" + bitmap);

                    // 压缩过后的图片
                    Bitmap bitmap2 = Tools.getimage(pat);
                    Log.i("info", "---------bitmap1:" + bitmap2);

                    // 将压缩过后的图片存放到该目录下
                    File ff = new File(pat);
                    FileOutputStream out = null;
                    try {
                        out = new FileOutputStream(ff);
                        paths.add(pat);
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                    }
                    bitmap2.compress(Bitmap.CompressFormat.JPEG, 100, out);
                    try {
                        out.flush();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    try {
                        out.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }


                    break;
                case IMAGE_CODE:
                    Bitmap bm = null;
                    //  外界的程序访问ContentProvider所提供数据 可以通过ContentResolver接口
                    ContentResolver resolver = getContentResolver();
                    try {
                        //获得图片的uri
                        Uri originalUri = intent.getData();
                        //显得到bitmap图片
                        bm = MediaStore.Images.Media.getBitmap(resolver, originalUri);
                        String[] proj = {MediaStore.Images.Media.DATA};
                        Cursor cursor = managedQuery(originalUri, proj, null, null, null);
                        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                        cursor.moveToFirst();
                        String path = cursor.getString(column_index);
                        Log.i("info", "--------path:" + path);

                        // 压缩过后的图片
                        Bitmap bitmap1 = Tools.getimage(path);
                        Log.i("info", "---------bitmap1:" + bitmap1);

                        int index = path.lastIndexOf("/");
                        String name = path.substring(index, path.length());
                        // 将压缩过后的图片存放到该目录下
                        String temp = Environment.getExternalStorageDirectory() + name;
                        File f = new File(temp);
                        FileOutputStream fOut = null;
                        try {
                            fOut = new FileOutputStream(f);
                            paths.add(temp);
                        } catch (FileNotFoundException e) {
                            e.printStackTrace();
                        }
                        bitmap1.compress(Bitmap.CompressFormat.JPEG, 100, fOut);
                        try {
                            fOut.flush();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                        try {
                            fOut.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }



                    } catch(Exception e) {
                        e.printStackTrace();
                    }
                    break;
            }
        }
        super.onActivityResult(requestCode, resultCode, intent);
    }

    @Override
    public void onConfigurationChanged(Configuration config) {
        super.onConfigurationChanged(config);
    }

}
