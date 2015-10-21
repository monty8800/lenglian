package com.xebest.llmj.center;

import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.ContentResolver;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.R;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.auth.AuthActivity;
import com.xebest.llmj.auth.CompanyCarAuthActivity;
import com.xebest.llmj.auth.CompanyGoodsAuthActivity;
import com.xebest.llmj.auth.CompanyWareHouseAuthActivity;
import com.xebest.llmj.auth.PersonalCarAuthActivity;
import com.xebest.llmj.auth.PersonalGoodsAuthActivity;
import com.xebest.llmj.auth.PersonalWareHouseAuthActivity;
import com.xebest.llmj.car.MyCarActivity;
import com.xebest.llmj.goods.MyGoodsActivity;
import com.xebest.llmj.utils.Tools;
import com.xebest.llmj.utils.UploadFile;
import com.xebest.llmj.ware.MyWarehouseActivity;
import com.xebest.plugin.XEFragment;
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
 * Created by kaisun on 15/9/21.
 */
public class CenterFragment extends XEFragment implements CordovaInterface {

    private XEWebView mWebView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fwebview, container, false);
        mWebView = (XEWebView) view.findViewById(R.id.wb);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mWebView.init(getActivity(), ApiUtils.API_COMMON_URL + "userCenter.html", this, this, this, this);
    }

    @Override
    public void onPause() {
        super.onPause();
        MobclickAgent.onPageEnd("个人中心");
    }

    @Override
    public void onResume() {
        // 统计页面
        MobclickAgent.onPageStart("个人中心");
        mWebView.getWebView().loadUrl("javascript:updateUser()");
        super.onResume();
    }

    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void jsCallNative(final JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        if (args.length() == 0) return;
        final String flag = args.getString(1);
        if (flag.equals("user:update")) {
            String userInfo = args.getString(2);
            JSONObject jsonObject = new JSONObject(userInfo);
            // 存放userId
            Application.getInstance().setUserId(jsonObject.getString("id"));
            Application.getInstance().setGoodsStatus(Integer.parseInt(jsonObject.getString("goodsStatus")));
            Application.getInstance().setWarehouseStatus(Integer.parseInt(jsonObject.getString("warehouseStatus")));
            Application.getInstance().setCarStatus(Integer.parseInt(jsonObject.getString("carStatus")));
            SharedPreferences.Editor editor = getActivity().getSharedPreferences("userInfo", 0).edit();
            editor.putString("userId", jsonObject.getString("id"));
            editor.commit();
        }
        else if (flag.equalsIgnoreCase("login")) {
            LoginActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("messageList")) {
            MsgActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("myCar")) {
            MyCarActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("addressList")) {
            AddressActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("attentionList")) {
            AttentionActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("more")) {
            MoreActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("login")) {
            LoginActivity.actionView(getActivity());
        }
        // 未认证
        else if (flag.equalsIgnoreCase("auth")) {
            AuthActivity.actionView(getActivity());
        }
        // 个人车主认证
        else if (flag.equalsIgnoreCase("personalCarAuth")) {
            PersonalCarAuthActivity.actionView(getActivity());
        }

        // 个人货主认证
        else if (flag.equalsIgnoreCase("personalGoodsAuth")) {
            PersonalGoodsAuthActivity.actionView(getActivity());
        }

        // 个人仓库认证
        else if (flag.equalsIgnoreCase("personalWarehouseAuth")) {
            PersonalWareHouseAuthActivity.actionView(getActivity());
        }

        // 公司车主认证
        else if (flag.equalsIgnoreCase("companyCarAuth")) {
            CompanyCarAuthActivity.actionView(getActivity());
        }

        // 公司货主认证
        else if (flag.equalsIgnoreCase("companyGoodsAuth")) {
            CompanyGoodsAuthActivity.actionView(getActivity());
        }

        // 公司仓库认证
        else if (flag.equalsIgnoreCase("companyWarehouseAuth")) {
            CompanyWareHouseAuthActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("myGoods")) {
            MyGoodsActivity.actionView(getActivity());
        } else if (flag.equals("wallet")) {
            WalletActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("avatar")) {
            resource = flag;
            showWindow();
        } else if (flag.equalsIgnoreCase("myWarehouse")) {
            MyWarehouseActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("myComment")) {
            MyCommentActivity.actionView(getActivity());
        }
    }

    @Override
    public void startActivityForResult(CordovaPlugin command, Intent intent, int requestCode) {

    }

    @Override
    public void setActivityResultCallback(CordovaPlugin plugin) {

    }

    @Override
    public Object onMessage(String id, Object data) {
        if (Application.UUID != null && mWebView != null && mWebView.getWebView() != null) {
            mWebView.getWebView().loadUrl("javascript:(function(){uuid='" + Application.UUID + "';version='" + Application.getInstance().VERSIONCODE + "';client_type='3';})();");
        }
        return super.onMessage(id, data);
    }

    private Dialog mDialog;

    private String localTempImgDir = "tempPic";

    private String localTempImgFileName = "p_0923.jpg";

    public final int GET_IMAGE_VIA_CAMERA = 10001;

    public final int IMAGE_CODE = 10002;

    private List<String> paths = new ArrayList<String>();

    private String resource = "";

    public void showWindow() {
        mDialog = Tools.getCustomDialog(getActivity(), R.layout.choose_cg, new Tools.BindEventView() {
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
                                Toast.makeText(getActivity(), "没有找到储存目录", Toast.LENGTH_LONG).show();
                            }
                        } else {
                            Toast.makeText(getActivity(), "没有储存卡", Toast.LENGTH_LONG).show();
                        }
                    }
                });
            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {

        if(resultCode == getActivity().RESULT_OK ) {
            switch(requestCode) {
                case GET_IMAGE_VIA_CAMERA:

                    String pat = Environment.getExternalStorageDirectory()
                            + "/" + localTempImgDir + "/" + localTempImgFileName;

                    Bitmap bitmap = BitmapFactory.decodeFile(pat);
                    // 压缩过后的图片
                    Bitmap bitmap2 = Tools.getimage(pat);

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
                    new UploadUserHeadTask().execute(pat);

                    break;
                case IMAGE_CODE:
                    Bitmap bm = null;
                    //  外界的程序访问ContentProvider所提供数据 可以通过ContentResolver接口
                    ContentResolver resolver = getActivity().getContentResolver();
                    try {
                        //获得图片的uri
                        Uri originalUri = intent.getData();
                        //显得到bitmap图片
                        bm = MediaStore.Images.Media.getBitmap(resolver, originalUri);
                        String[] proj = {MediaStore.Images.Media.DATA};
                        Cursor cursor = getActivity().managedQuery(originalUri, proj, null, null, null);
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

                        new UploadUserHeadTask().execute(temp);

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

    /**
     * 修改头像
     */
    public class UploadUserHeadTask extends AsyncTask<String, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected String doInBackground(String... params) {
            Map<String, Object> map = new HashMap<String, Object>();
            Map<String, String> data = new HashMap<String, String>();
            data.put("userId", Application.getInstance().userId);
            map.put("uuid", Application.getInstance().UUID);
            map.put("version", Application.getInstance().VERSIONCODE);
            map.put("client_type", "3");
            map.put("data", new Gson().toJson(data));
            Map<String, File> fileMap = new HashMap<String, File>();
            fileMap.put("file", new File(params[0]));
            String result = null;
            try {
                result = UploadFile.post(ApiUtils.change_head_pic, map, fileMap, null, null);
            } catch (IOException e) {
                e.printStackTrace();
            }
            return result;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
        }
    }


}
