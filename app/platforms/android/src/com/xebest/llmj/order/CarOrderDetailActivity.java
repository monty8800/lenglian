package com.xebest.llmj.order;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.R;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.llmj.goods.SearchGoodsDetailActivity;
import com.xebest.llmj.ware.SearchWarehouseDetailActivity;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * 车订单详情
 * Created by kaisun on 15/9/22.
 */
public class CarOrderDetailActivity extends BaseCordovaActivity implements CordovaInterface {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private TextView editorCar;

    private boolean isOncreate = false;

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, CarOrderDetailActivity.class));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.car_detail);
        isOncreate = true;
        initView();
    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String back = args.getString(0);
        if (back.equals("2")) {
            finish();
        } else {
            String flag = args.getString(1);
            if (flag.equalsIgnoreCase("searchWarehouseDetail")) {
                SearchWarehouseDetailActivity.actionView(CarOrderDetailActivity.this);
            } else if (args.getString(0).equals("2")) {
                finish();
            } else if (flag.equalsIgnoreCase("searchGoodsDetail")) {
                SearchGoodsDetailActivity.actionView(CarOrderDetailActivity.this);
            } else if (flag.equals("doComment")) {
                DoCommentActivity.actionView(getActivity());
            }
        }

    }

    protected void initView() {
        editorCar = (TextView) findViewById(R.id.editor);
        editorCar.setVisibility(View.GONE);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("订单详情");
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
        MobclickAgent.onPageStart("订单详情");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOncreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "carOwnerOrderDetail.html", this, this, this, this);
        }
        isOncreate = false;

        mWebView.getWebView().loadUrl("javascript:updateStore()");
        super.onResume();
    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("订单详情");
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

}
