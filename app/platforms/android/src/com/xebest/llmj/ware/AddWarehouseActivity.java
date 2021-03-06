package com.xebest.llmj.ware;

import android.app.Activity;
import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
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

import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.geocode.GeoCodeOption;
import com.baidu.mapapi.search.geocode.GeoCodeResult;
import com.baidu.mapapi.search.geocode.GeoCoder;
import com.baidu.mapapi.search.geocode.OnGetGeoCoderResultListener;
import com.baidu.mapapi.search.geocode.ReverseGeoCodeResult;
import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.R;
import com.xebest.llmj.adapter.CarAdapter;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.application.LocationActivity;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.llmj.model.CarListInfo;
import com.xebest.llmj.sort.ContactListActivity;
import com.xebest.llmj.utils.Tools;
import com.xebest.llmj.utils.UploadFile;
import com.xebest.llmj.widget.XListView;
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
 * 新增仓库
 * Created by kaisun on 15/9/22.
 */
public class AddWarehouseActivity extends BaseCordovaActivity implements CordovaInterface, OnGetGeoCoderResultListener {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private boolean isOnCreate = false;

    private TextView tvOk;

    private String wareHouseId = "";

    private Dialog mDialog;

    private XListView mListView;

    private List<CarListInfo> carList = new ArrayList<CarListInfo>();

    private CarAdapter carAdapter;

    private String localTempImgDir = "tempPic";

    private String localTempImgFileName = "p_0923.jpg";

    public final int GET_IMAGE_VIA_CAMERA = 10001;

    public final int IMAGE_CODE = 10002;

    private List<String> paths = new ArrayList<String>();

    private String resource = "";

    private Application mApplication;

    private boolean isBusy = false;

    private GeoCoder mSearch = null; // 搜索模块，也可去掉地图模块独立使用

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, AddWarehouseActivity.class));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.found_car);
        isOnCreate = true;
        initView();
        // 初始化搜索模块，注册事件监听
        mSearch = GeoCoder.newInstance();
        mSearch.setOnGetGeoCodeResultListener(this);
        tvOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mWebView.getWebView().loadUrl("javascript:addWarehouseBtnClick()");
            }
        });
    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("新增仓库");
        MobclickAgent.onPause(this);
    }

    protected void initView() {
        tvOk = (TextView) findViewById(R.id.near);
        tvOk.setText("完成");
        tvOk.setVisibility(View.GONE);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("新增仓库");
        mWebView = (XEWebView) findViewById(R.id.wb);
        backView = findViewById(R.id.rlBack);
        mApplication = (Application) getApplicationContext();
        backView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    private String type = "";

    String url;
    Map<String, Object> content;
    Map<String, File> driving = null;

    String city;
    String detail;
    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        if (args.getString(0).equals("19")) {
            city = args.getString(1);
            detail = args.getString(2);
            // 拿到经纬度，
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mSearch.geocode(new GeoCodeOption().city(city).address(detail));
                }
            });
        } else {
            String flag = args.getString(1);
            Log.i("info", "---------" + args.toString());
            if (flag.equalsIgnoreCase("addWarehouse")) {
                // 新增仓库图片回显
                resource = flag;
                showWindow();
            } else if (flag.equalsIgnoreCase("getContectForAddWarehouse")) {
                type = flag;
                ContactListActivity.actionView(this);
            } else if (flag.equalsIgnoreCase("locationView")) {
                LocationActivity.actionView(this);
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
                JSONObject jb = files.getJSONObject(0);
                Log.i("info", "--------------files:" + jb);

                String a = jb.getString("filed");
                Log.i("info", "--------------filed:" + a);

                content = new HashMap<String, Object>();
                content.put("client_type", client_type);
                content.put("uuid", uuid);
                content.put("version", version);
                content.put("userId", Application.getInstance().userId);
                content.put("data", ttData);
                content.put("sign", sign);

                driving = new HashMap<String, File>();
                String path = files.getJSONObject(0).getString("path");
                if (!path.equals("") && path != null) {
                    driving.put("file", new File(files.getJSONObject(0).getString("path")));
                }

                Log.i("info", "--------------content:" + content);
                Log.i("info", "--------------content:");
                if (isBusy) return;
                new RequestTask().execute();
            }
        }
    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("新增仓库");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOnCreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "addWarehouse.html", this, this, this, this);
        }
        isOnCreate = false;

        if (mApplication.getContacts() != "") {
            mWebView.getWebView().loadUrl("javascript:updateContact('" + mApplication.getContacts() + "', '" + mApplication.getPhone() + "', '" + type + "')");
            mApplication.setContacts("");
        }

        SharedPreferences sp = getSharedPreferences("location", 0);
        if (sp.getString("mLatitude", "") != "") {
            String mLatitude = sp.getString("mLatitude", "");
            String mLontitud = sp.getString("mLontitud", "");
            String mProvince = sp.getString("mProvince", "");
            String mCity = sp.getString("mCity", "");
            String mArea = sp.getString("mArea", "");
            String mStreet = sp.getString("mStreet", "");
            String mStreetNumber = sp.getString("mStreetNumber", "");
            mWebView.getWebView().loadUrl("javascript:showAddressFromMap('" + mProvince + "', '" + mCity + "', '" + mArea + "', '" + mStreet + "', '" + mStreetNumber + "', '" + mLatitude + "', '" + mLontitud + "')");
        }
        SharedPreferences.Editor editor = getSharedPreferences("location", 0).edit();
        editor.putString("mLatitude", "");
        editor.putString("mLontitud", "");
        editor.putString("mProvince", "");
        editor.putString("mCity", "");
        editor.putString("mArea", "");
        editor.putString("mStreet", "");
        editor.putString("mStreetNumber", "");
        editor.commit();

        super.onResume();
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
                                Toast.makeText(AddWarehouseActivity.this, "没有找到储存目录", Toast.LENGTH_LONG).show();
                            }
                        } else {
                            Toast.makeText(AddWarehouseActivity.this, "没有储存卡", Toast.LENGTH_LONG).show();
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
                    mWebView.getWebView().loadUrl("javascript:(function(){showAddWarehouseImage('"+ pat +"', '"+ resource +"')})()");
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
                        mWebView.getWebView().loadUrl("javascript:showAddWarehouseImage('" + temp + "', '" + resource + "', '" + System.currentTimeMillis() + "')");
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

    boolean success = false;
    String msg = "";
    public class RequestTask extends AsyncTask<String, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            isBusy = true;
            Tools.createLoadingDialog(AddWarehouseActivity.this, "提交中...");
        }

        @Override
        protected String doInBackground(String... params) {
            try {
                String result = UploadFile.post(url, content, driving, null, null);
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
                mWebView.getWebView().loadUrl("javascript:addWarehouseSucc()");
                Tools.showSuccessToast(AddWarehouseActivity.this, "添加成功!");
                finish();
//                MainActivity.actionView(AddWarehouseActivity.this, 3);
            } else {
                Tools.showErrorToast(AddWarehouseActivity.this, msg);
            }
            isBusy = false;
        }
    }

    @Override
    public void onGetGeoCodeResult(GeoCodeResult result) {
        if (result == null || result.error != SearchResult.ERRORNO.NO_ERROR) {
            Toast.makeText(AddWarehouseActivity.this, "抱歉，未能找到结果", Toast.LENGTH_LONG)
                    .show();
            return;
        }
//        String strInfo = String.format("纬度：%f 经度：%f",
//                result.getLocation().latitude, result.getLocation().longitude);
        mWebView.getWebView().loadUrl("javascript:doSubmit('" + result.getLocation().latitude + "', '" + result.getLocation().longitude + "')");
    }

    @Override
    public void onGetReverseGeoCodeResult(ReverseGeoCodeResult result) {

    }

}
