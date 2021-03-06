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
import com.xebest.llmj.auth.AuthActivity;
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
public class RegisterActivity extends BaseCordovaActivity implements CordovaInterface {


    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, RegisterActivity.class));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.cwebview);

        initView();

    }

    protected void initView() {
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("注册");
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
        MobclickAgent.onPageStart("注册");
        // 统计时长
        MobclickAgent.onResume(this);
        mWebView.init(this, ApiUtils.API_COMMON_URL + "register.html", this, this, this, this);
        super.onResume();
    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("注册");
        MobclickAgent.onPause(this);
    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String flag = args.getString(0);
        if (flag.equals("2")) {
            // 跳过认证
            MainActivity.actionView(RegisterActivity.this, 3);
        } else {
            if (args.toString().contains("user:update")) {
                String userInfo = args.getString(2);
                JSONObject jsonObject = new JSONObject(userInfo);
                // 存放userId
                ((Application) getApplication()).setUserId(jsonObject.getString("id"));
//                Application.getInstance().setGoodsStatus(Integer.parseInt(jsonObject.getString("goodsStatus")));
//                Application.getInstance().setWarehouseStatus(Integer.parseInt(jsonObject.getString("warehouseStatus")));
//                Application.getInstance().setCarStatus(Integer.parseInt(jsonObject.getString("carStatus")));
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
            } else if (args.toString().contains("2")) {
            } else if (args.toString().contains("auth")) {
                AuthActivity.actionView(RegisterActivity.this);
            } else if (args.toString().contains("toAgreement")) {
                AgreementActivity.actionView(RegisterActivity.this);
            }
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
