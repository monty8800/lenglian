package com.xebest.llmj.car;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.R;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.center.SelectAddressActivity;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.llmj.sort.ContactListActivity;
import com.xebest.llmj.widget.DateCallBack;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * 发布车源
 * Created by kaisun on 15/9/22.
 */
public class ReleaseCarActivity extends BaseCordovaActivity implements CordovaInterface, DateCallBack {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private boolean isOnCreate = false;

    private Application mApplication;

    private SelectBirthday selectBirthday;

    private boolean isStartDate = true;

    private String startDate = "";
    private String endDate = "";

    private int flagW = 1;

    // 是否是从选择地址界面点击确定按钮过来的  (*^__^*) 嘻嘻……
    public static boolean isSelectSure = false;

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
        mApplication = (Application) getApplicationContext();
        isOnCreate = true;
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
        String flag = args.getString(1);
        if (flag.equals("release_success")) {
            finish();
        } else if (flag.equals("contact_list")) {
            ContactListActivity.actionView(ReleaseCarActivity.this);
        } else if (flag.equals("datepicker")) {
            isStartDate = false;
            selectBirthday = new SelectBirthday(ReleaseCarActivity.this, "开始时间");
            selectBirthday.showAtLocation(ReleaseCarActivity.this.findViewById(R.id.root),
                    Gravity.BOTTOM, 0, 0);
        } else if (flag.equals("select_start_address")) {
            flagW = 1;
            SelectAddressActivity.actionView(ReleaseCarActivity.this);
        } else if (flag.equals("select_end_address")) {
            flagW = 2;
            SelectAddressActivity.actionView(ReleaseCarActivity.this);
        }
    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("发布车源");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOnCreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "releaseVehicle.html", this, this, this, this);
        }
        isOnCreate = false;
        if (mApplication.getContacts() != "") {
            mWebView.getWebView().loadUrl("javascript:updateContact('" + mApplication.getContacts() + "', '" + mApplication.getPhone() + "')");
            mApplication.setContacts("");
        }

        // 更新地址
        if (flagW == 1) {
            mWebView.getWebView().loadUrl("javascript:updateAddress('startAddress')");
        } else {
            mWebView.getWebView().loadUrl("javascript:updateAddress('endAddress')");
        }

        if (isSelectSure) {
            if (flagW == 1) {
                mWebView.getWebView().loadUrl("javascript:updateAddress('startAddress')");
            } else {
                mWebView.getWebView().loadUrl("javascript:updateAddress('endAddress')");
            }
        }

        super.onResume();
    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("发布车源");
        MobclickAgent.onPause(this);
    }

    @Override
    public void onDestroy() {
        // 清空本次联系人相关动作
        ((Application) getApplication()).setContacts("");
        ((Application) getApplication()).setPhone("");
        mWebView.getWebView().loadUrl("javascript:cleanTransData()");
        super.onDestroy();
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

    @Override
    public void callBack(int flag, String date) {
        if (flag == 0) {
        } else if (flag == 1) {
            startDate = date;
            selectBirthday = new SelectBirthday(ReleaseCarActivity.this, "结束时间");
            selectBirthday.showAtLocation(ReleaseCarActivity.this.findViewById(R.id.root),
                    Gravity.BOTTOM, 0, 0);
        } else if (flag == 2) {
            endDate = date;
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mWebView.getWebView().loadUrl("javascript:updateDate('" + startDate + "', '" +  endDate + "')");
                }
            });
        }
        Log.i("info", "------------startDate:" + startDate + " -endDate:" + endDate);
    }

}
