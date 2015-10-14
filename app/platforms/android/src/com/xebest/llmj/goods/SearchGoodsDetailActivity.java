package com.xebest.llmj.goods;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.umeng.analytics.MobclickAgent;
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

/**
 * 货物详情
 * Created by kaisun on 15/9/22.
 */
public class SearchGoodsDetailActivity extends BaseCordovaActivity implements CordovaInterface {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private TextView addCar;

    private boolean isOnCreate = false;

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, SearchGoodsDetailActivity.class));
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
        MobclickAgent.onPageEnd("货物详情");
        MobclickAgent.onPause(this);
    }

    protected void initView() {
        addCar = (TextView) findViewById(R.id.add);
        addCar.setText("搜索");
        addCar.setVisibility(View.GONE);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("货物详情");
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
                mWebView.getWebView().loadUrl("javascript:doCarSearchGoods()");
            }
        });
    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String flag = args.getString(1);
        Toast.makeText(this, "" + args.toString(), Toast.LENGTH_LONG).show();


    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("货物详情");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOnCreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "searchGoodsDetail.html", this, this, this, this);
        }
        isOnCreate = false;
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

}
