package com.xebest.llmj.center;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.MainActivity;
import com.xebest.llmj.R;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by kaisun on 15/9/22.
 */
public class LoginActivity extends BaseCordovaActivity implements CordovaInterface {


    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private boolean isOnCreate = false;

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, LoginActivity.class));
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
        tvTitle.setText("登录");
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
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("登录");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOnCreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "login.html", this, this, this, this);
        }
        isOnCreate = false;

        super.onResume();
    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("登录");
        MobclickAgent.onPause(this);
    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String flag = args.getString(1);
        if (flag.equals("user:update")) {
            String userInfo = args.getString(2);
            JSONObject jsonObject = new JSONObject(userInfo);
            // 存放userId
            ((Application) getApplication()).setUserId(jsonObject.getString("id"));
//            Application.getInstance().setGoodsStatus(Integer.parseInt(jsonObject.getString("goodsStatus")));
//            Application.getInstance().setWarehouseStatus(Integer.parseInt(jsonObject.getString("warehouseStatus")));
//            Application.getInstance().setCarStatus(Integer.parseInt(jsonObject.getString("carStatus")));
            SharedPreferences.Editor editor = getActivity().getSharedPreferences("userInfo", 0).edit();
            editor.putString("userId", jsonObject.getString("id"));
//            editor.putInt("goodsStatus", jsonObject.getInt("goodsStatus"));
//            editor.putInt("warehouseStatus", jsonObject.getInt("warehouseStatus"));
//            editor.putInt("carStatus", jsonObject.getInt("carStatus"));

            if (jsonObject.getString("personalGoodsStatus").equals("1") || jsonObject.getString("enterpriseGoodsStatus").equals("1")) {
                editor.putInt("goodsStatus", 1);
                Application.getInstance().setGoodsStatus(1);
            }
            if (jsonObject.getString("personalCarStatus").equals("1") || jsonObject.getString("enterpriseCarStatus").equals("1")) {
                editor.putInt("carStatus", 1);
                Application.getInstance().setCarStatus(1);
            }
            if (jsonObject.getString("personalWarehouseStatus").equals("1") || jsonObject.getString("enterpriseWarehouseStatus").equals("1")) {
                editor.putInt("warehouseStatus", 1);
                Application.getInstance().setWarehouseStatus(1);
            }

            editor.commit();
            if (Application.getInstance().loginSuccess) {
                MainActivity.actionView(LoginActivity.this, 3);
                Application.getInstance().setLoginSuccess(false);
            } else {
                finish();
            }
        } else if (flag.equals("register")) {
            RegisterActivity.actionView(LoginActivity.this);
        } else if (flag.equals("resetPasswd")) {
            ResetPwdActivity.actionView(LoginActivity.this, "忘记密码");
        }
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
        mWebView.getWebView().loadUrl("javascript:(function(){uuid='" + Application.UUID + "';version='" + ((Application) getApplicationContext()).VERSIONCODE + "';client_type='3';})();");
        return null;
    }

}
