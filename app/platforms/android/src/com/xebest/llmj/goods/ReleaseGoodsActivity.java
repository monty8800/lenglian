package com.xebest.llmj.goods;

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
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.R;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.car.SelectBirthday;
import com.xebest.llmj.center.SelectAddressActivity;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.llmj.sort.ContactListActivity;
import com.xebest.llmj.utils.Tools;
import com.xebest.llmj.utils.UploadFile;
import com.xebest.llmj.widget.DateCallBack;
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
import java.util.HashMap;
import java.util.Map;

/**
 * 发布货源
 * Created by kaisun on 15/9/22.
 */
public class ReleaseGoodsActivity extends BaseCordovaActivity implements CordovaInterface, DateCallBack {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private TextView addCar;

    private boolean isOnCreate = false;

    private Application mApplication;

    private String localTempImgDir = "tempPic";

    private String localTempImgFileName = "p_0923.jpg";

    public final int GET_IMAGE_VIA_CAMERA = 10001;

    public final int IMAGE_CODE = 10002;

    private Dialog mDialog;

    private String resource = "";

    private SelectBirthday selectBirthday;

    private String startDate = "";
    private String endDate = "";

    private boolean isBusy = false;

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, ReleaseGoodsActivity.class));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.my_ware);
        isOnCreate = true;
        initView();

    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("发布货源");
        MobclickAgent.onPause(this);
    }

    protected void initView() {
        mApplication = (Application) getApplicationContext();
        addCar = (TextView) findViewById(R.id.add);
        addCar.setVisibility(View.GONE);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("发布货源");
        mWebView = (XEWebView) findViewById(R.id.wb);
        backView = findViewById(R.id.rlBack);
        backView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        addCar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AddGoodsActivity.actionView(ReleaseGoodsActivity.this);
            }
        });
    }

    private String type = "";

    private String timeType = "";

    String url;
    Map<String, Object> content;
    Map<String, File> driving;
    private String signStr = "";

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String flag = args.getString(1);
        if (flag.equalsIgnoreCase("selectAddress")) {
            SelectAddressActivity.actionView(this);
        } else if (flag.equalsIgnoreCase("select:contacts:sender")) {
            type = flag;
            ContactListActivity.actionView(this);
        } else if (flag.equalsIgnoreCase("select:contacts:reciver")) {
            type = flag;
            ContactListActivity.actionView(this);
        } else if (flag.equalsIgnoreCase("select:goods:photo")) {
            showWindow();
        } else if (flag.equalsIgnoreCase("select:time:install")) {
            selectBirthday = new SelectBirthday(ReleaseGoodsActivity.this, "开始时间");
            selectBirthday.showAtLocation(ReleaseGoodsActivity.this.findViewById(R.id.root),
                    Gravity.BOTTOM, 0, 0);
            timeType = "install";
        } else if (flag.equalsIgnoreCase("select:time:arrive")) {
            selectBirthday = new SelectBirthday(ReleaseGoodsActivity.this, "开始时间");
            selectBirthday.showAtLocation(ReleaseGoodsActivity.this.findViewById(R.id.root),
                    Gravity.BOTTOM, 0, 0);
            timeType = "arrive";
        } else if (args.getString(0).equals("7")) {
            Log.i("info", "----------------source:" + args.toString());
            url = args.getString(1);
            Log.i("info", "--------------url:" + url);
            JSONObject data = args.getJSONObject(2);
            final JSONArray files = args.getJSONArray(3);
            final String ttData = data.getString("data");
            String sign = data.getString("sign");
            JSONObject ttObj = new JSONObject(ttData);
            final String client_type = data.getString("client_type");
            final String version = data.getString("version");
            final String uuid = data.getString("uuid");
            Log.i("info", "--------------client_type:" + client_type);
            Log.i("info", "--------------uuid:" + uuid);
            Log.i("info", "--------------version:" + version);
            Log.i("info", "----------ttObj:" + ttObj);

            driving = new HashMap<String, File>();
            if (files.length() != 0) {
                JSONObject jb = files.getJSONObject(0);
                String a = jb.getString("filed");
                Log.i("info", "--------------filed:" + a);
                driving.put("imgurl", new File(files.getJSONObject(0).getString("path")));
            }

            content = new HashMap<String, Object>();
            content.put("client_type", client_type);
            content.put("uuid", uuid);
            content.put("version", version);
            content.put("userId", Application.getInstance().userId);
            content.put("sign", sign);
            content.put("data", ttData);

            if (isBusy) return;
            new RequestTask().execute();
        }
    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("发布货源");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOnCreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "addGoods.html", this, this, this, this);
        }
        isOnCreate = false;

        if (mApplication.getContacts() != "") {
            mWebView.getWebView().loadUrl("javascript:updateContact('" + mApplication.getContacts() + "', '" + mApplication.getPhone() + "', '" + type + "')");
            mApplication.setContacts("");
        }

        mWebView.getWebView().loadUrl("javascript:updateGoods()");
        mWebView.getWebView().loadUrl("javascript:updateStore()");

        super.onResume();
    }

    @Override
    protected void onStop() {
        super.onStop();
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
        mDialog = Tools.getCustomDialogBg(this, R.layout.choose_cg, new Tools.BindEventView() {
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
                                Intent intent = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
                                File f = new File(dir, localTempImgFileName);//localTempImgDir和localTempImageFileName是自己定义的名字
                                Uri u = Uri.fromFile(f);
                                intent.putExtra(MediaStore.Images.Media.ORIENTATION, 0);
                                intent.putExtra(MediaStore.EXTRA_OUTPUT, u);
                                startActivityForResult(intent, GET_IMAGE_VIA_CAMERA);
                            } catch (ActivityNotFoundException e) {
                                Toast.makeText(ReleaseGoodsActivity.this, "没有找到储存目录", Toast.LENGTH_LONG).show();
                            }
                        } else {
                            Toast.makeText(ReleaseGoodsActivity.this, "没有储存卡", Toast.LENGTH_LONG).show();
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
//                        paths.add(pat);
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
                    mWebView.getWebView().loadUrl("javascript:(function(){setGoodsPic('"+ pat +"', '"+ resource +"')})()");
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

                        if (path == null) {
                            String name = System.currentTimeMillis() + ".jpg";
                            path = Environment.getExternalStorageDirectory()
                                    + "/" + localTempImgDir + "/" + name;
                            Log.i("info", "--------root:" + path);
                            FileOutputStream fout = new FileOutputStream(new File(path));
                            bm.compress(Bitmap.CompressFormat.JPEG, 100, fout);
                        }

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
//                            paths.add(temp);
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
                        mWebView.getWebView().loadUrl("javascript:setGoodsPic('" + temp + "', '" + resource + "', '" + System.currentTimeMillis() + "')");
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

    String installStartTime = "";
    String arriveStartTime = "";
    @Override
    public void callBack(int flag, String date) {
        if (flag == 0) {
        } else if (flag == 1) {
            startDate = date;
            if (timeType.equals("install")) {
                installStartTime = startDate;
            } else if (timeType.equals("arrive")) {
                arriveStartTime = startDate;
            }
            selectBirthday = new SelectBirthday(ReleaseGoodsActivity.this, "结束时间");
            selectBirthday.showAtLocation(ReleaseGoodsActivity.this.findViewById(R.id.root),
                    Gravity.BOTTOM, 0, 0);
        } else if (flag == 2) {
            endDate = date;

            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (!Tools.compareTime(startDate, endDate)) {
                        Tools.showToast(ReleaseGoodsActivity.this, "结束时间要比开始时间晚");
                        return;
                    }
                    if (timeType.equals("arrive")) {
                        if (!Tools.compareTime(installStartTime, arriveStartTime)) {
                            Tools.showToast(ReleaseGoodsActivity.this, "请您选择正确的到货时间(到货时间晚于装车时间)");
                            return;
                        }
                    }
                    mWebView.getWebView().loadUrl("javascript:updateTime('" + startDate + "', '" +  endDate + "', '" + timeType + "')");
                }
            });
        }
    }

    boolean success = false;
    boolean isNetErro = false;
    String msg = "";
    public class RequestTask extends AsyncTask<String, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            isBusy = true;
            Tools.createLoadingDialog(ReleaseGoodsActivity.this, "提交中...");
        }

        @Override
        protected String doInBackground(String... params) {
            try {
                String result = UploadFile.post(url, content, driving, null, null);
                JSONObject jsonObject = new JSONObject(result);
                msg = jsonObject.getString("msg");
                Log.i("info", "----------------result" + result);
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
                isBusy = false;
                isNetErro = true;
            }
            return null;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);

            Tools.dismissLoading();
            if (success) {
                mWebView.getWebView().loadUrl("javascript:authDone()");
                mWebView.getWebView().loadUrl("javascript:addGoodsSucc()");
                Tools.showSuccessToast(ReleaseGoodsActivity.this, "添加成功!");
                finish();
//                MainActivity.actionView(ReleaseGoodsActivity.this, 3);
            } else {
                if (isNetErro) {
                    msg = "请检查网络!";
                }
                isNetErro = false;
                Tools.showErrorToast(ReleaseGoodsActivity.this, msg);
            }

            isBusy = false;
        }
    }


}
