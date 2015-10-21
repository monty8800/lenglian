package com.xebest.llmj.auth;

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
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.MainActivity;
import com.xebest.llmj.R;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.llmj.utils.Tools;
import com.xebest.llmj.utils.UploadFile;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 公司货主认证
 * Created by kaisun on 15/9/22.
 */
public class CompanyGoodsAuthActivity extends BaseCordovaActivity implements CordovaInterface {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;


    private Dialog mDialog;

    private String localTempImgDir = "tempPic";

    private String localTempImgFileName = "p_0923.jpg";

    public final int GET_IMAGE_VIA_CAMERA = 10001;

    public final int IMAGE_CODE = 10002;

    private List<String> paths = new ArrayList<String>();

    private String resource = "";

    private boolean isOnCreate = false;

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, CompanyGoodsAuthActivity.class));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.cwebview);
        isOnCreate = true;
        initView();
    }

    protected void initView() {
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("公司货主认证");
        mWebView = (XEWebView) findViewById(R.id.wb);
        backView = findViewById(R.id.rlBack);
        backView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    String url;
    Map<String, Object> content;
    Map<String, File> driving = null;

    String businsFromNet = "";

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String flag = args.getString(0);
        if (flag.equals("8")) {
            String next = args.getString(1);
            if (next.equals("businessLicense")) {
                resource = "businessLicense";
                // 行驶证照片
                showWindow();
            }
        } else if (flag.equals("13")) {
            final String url = args.getString(1);
            // businessLicense
            final String type = args.getString(2);
            int index = url.lastIndexOf("/");
            final String fileName = url.substring(index + 1, url.length());
            new Thread(new Runnable() {
                @Override
                public void run() {
                    byte[] data = UploadFile.getImage(url);
                    Bitmap bm = BitmapFactory.decodeByteArray(data, 0, data.length);
                    UploadFile.saveImage(bm, fileName);
                    businsFromNet = ApiUtils.storePath + "/" + fileName;
                }
            }).start();
        } else if(flag.equals("7")) {
            // [7,"http:\/\/192.168.29.176:8072\/\/mjPersonInfoAuthCtl\/personInfoAuth.shtml",
            // {"data":"{\"phone\":\"18513468467\",\"type\":2,\"username\":\"骨灰盒\",\"userId\":\"50819ab3c0954f828d0851da576cbc31\",\"cardno\":\"340621188807124021\",\"carno\":\"京j12345\",\"frameno\":\"11111111111111111\"}",
            // "client_type":"2","version":"10","uuid":"4ab872a3-143d-4ace-b6cc-9f8f11e599cb"},
            // [{"path":"\/storage\/emulated\/0\/IMG_20150903_140507.jpg","filed":"idcardImg"},
            // {"path":"\/storage\/emulated\/0\/IMG_20150904_110451.jpg","filed":"drivingImg"},
            // {"path":"\/storage\/emulated\/0\/IMG_20150903_190520.jpg","filed":"taxiLicenseImg"}]]
            Log.i("info", "----------------source:" + args.toString());
            url = args.getString(1);
            Log.i("info", "--------------url:" + url);
            JSONObject data = args.getJSONObject(2);
            final JSONArray files = args.getJSONArray(3);
            final String ttData = data.getString("data");
            JSONObject ttObj = new JSONObject(ttData);
            final String client_type = data.getString("client_type");
            final String version = data.getString("version");
            final String uuid = data.getString("uuid");
            Log.i("info", "--------------client_type:" + client_type);
            Log.i("info", "--------------uuid:" + uuid);
            Log.i("info", "--------------version:" + version);
            JSONObject jb = files.getJSONObject(0);
            Log.i("info", "--------------files:" + jb);

            String a = jb.getString("filed");
            Log.i("info", "--------------filed:" + a);

            content = new HashMap<String, Object>();
            content.put("client_type", client_type);
            content.put("uuid", uuid);
            content.put("version", version);
            content.put("data", ttData);

            driving = new HashMap<String, File>();
            String path = files.getJSONObject(0).getString("path");
            if (path != null && !path.equals("")) {
                if (path.contains("|")) {
                    driving.put("businessLicenseImg", new File(businsFromNet));
                } else {
                    driving.put("businessLicenseImg", new File(path));
                }
            }

            Log.i("info", "--------------content:" + content);
            Log.i("info", "--------------content:");

            new RequestTask().execute();

        }
    }

    boolean success = false;
    String msg = "";
    public class RequestTask extends AsyncTask<String, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            Tools.createLoadingDialog(CompanyGoodsAuthActivity.this, "认证中...");
        }

        @Override
        protected String doInBackground(String... params) {
            try {
                String result = UploadFile.post(url, content, driving, null, null );
                JSONObject jsonObject = new JSONObject(result);
                Log.i("info", "----------------result" + result);
                msg = jsonObject.getString("msg");
                if (jsonObject.getString("code").equals("0000")) {
                    // 认证成功
                    success = true;
                } else {
                    // 认证失败
                    success = false;
                }
            } catch(Exception e) {
                e.printStackTrace();
                success = false;
            }
            return null;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);

            Tools.dismissLoading();
            if (success) {
                // 调用js方法更新User
                mWebView.getWebView().loadUrl("javascript:authDone()");
                Tools.showSuccessToast(CompanyGoodsAuthActivity.this, "认证成功!");
                finish();
                MainActivity.actionView(CompanyGoodsAuthActivity.this, 3);
            } else {
                Tools.showErrorToast(CompanyGoodsAuthActivity.this, msg);
            }
        }
    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("公司货主认证");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOnCreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "companyGoodsAuth.html", this, this, this, this);
        }
        isOnCreate = false;
        super.onResume();
    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("公司货主认证");
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
        return super.onMessage(id, data);
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
                        if (status.equals(Environment.MEDIA_MOUNTED)) {
                            localTempImgFileName = System.currentTimeMillis() + ".jpg";
                            try {
                                File dir = new File(Environment.getExternalStorageDirectory() + "/" + localTempImgDir);
                                if (!dir.exists()) dir.mkdirs();
                                Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                                File f = new File(dir, localTempImgFileName);//localTempImgDir和localTempImageFileName是自己定义的名字
                                Uri u = Uri.fromFile(f);
                                intent.putExtra(MediaStore.Images.Media.ORIENTATION, 0);
                                intent.putExtra(MediaStore.EXTRA_OUTPUT, u);
                                startActivityForResult(intent, GET_IMAGE_VIA_CAMERA);
                            } catch (ActivityNotFoundException e) {
                                Toast.makeText(CompanyGoodsAuthActivity.this, "没有找到储存目录", Toast.LENGTH_LONG).show();
                            }
                        } else {
                            Toast.makeText(CompanyGoodsAuthActivity.this, "没有储存卡", Toast.LENGTH_LONG).show();
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

                    Bitmap bitmap = BitmapFactory.decodeFile(pat);
                    // 压缩过后的图片
                    Bitmap bitmap2 = Tools.getimage(pat);

                    // MI 4W
                    String model = Build.MODEL;
                    if (model.equalsIgnoreCase("SM-N9100") || model.equalsIgnoreCase("Coolpad")) {
                        bitmap2 = Tools.rotaingImageView(90, bitmap2);
                    }

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

                    // 通知js更新图片内容
                    mWebView.getWebView().loadUrl("javascript:(function(){setAuthPic('"+ pat +"', '"+ resource +"')})()");
                    Log.i("info", "-----------resource:" + resource);
                    Log.i("info", "-----------img:" + pat);

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

                        // 压缩过后的图片
                        Bitmap bitmap1 = Tools.getimage(path);

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

                        // 通知js更新图片内容
                        mWebView.getWebView().loadUrl("javascript:setAuthPic('" + temp + "', '" + resource + "', '" + System.currentTimeMillis() + "')");
//                        mWebView.getWebView().loadUrl("javascript:setAuthPic('"+ temp + "', '"+ resource + "')");
//                        mWebView.getWebView().loadUrl("javascript:(function(){setAuthPic('"+ temp +"', '"+ resource +"')})()");
                        Log.i("info", "-----------resource:" + resource);
                        Log.i("info", "-----------temp:" + temp);


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
