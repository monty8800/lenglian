package com.xebest.llmj.wallet;

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
import com.xebest.llmj.auth.AuthActivity;
import com.xebest.llmj.auth.CompanyCarAuthActivity;
import com.xebest.llmj.auth.CompanyGoodsAuthActivity;
import com.xebest.llmj.auth.CompanyWareHouseAuthActivity;
import com.xebest.llmj.auth.PersonalCarAuthActivity;
import com.xebest.llmj.auth.PersonalGoodsAuthActivity;
import com.xebest.llmj.auth.PersonalWareHouseAuthActivity;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * 我的钱包
 * Created by kaisun on 15/9/22.
 */
public class WalletActivity extends BaseCordovaActivity implements CordovaInterface {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private TextView bank;

    private boolean isOnCreate = false;

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, WalletActivity.class));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.wallet);
        isOnCreate = true;
        initView();

    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String flag = args.getString(1);
        if (flag.equalsIgnoreCase("chargeRecord")) {
//            ChangePwdActivity.actionView(WalletActivity.this);
            ChargeRecordActivity.actionView(this);
        } else if (flag.equalsIgnoreCase("billList")) {
            BillListActivity.actionView(this);
        } else if (flag.equalsIgnoreCase("toCharge")) {
            ChargeActivity.actionView(this);
        } else if (flag.equalsIgnoreCase("withdraw")) {
            // 提现
            WithDrawActivity.actionView(this);
        }
        // 未认证
        else if (flag.equalsIgnoreCase("auth")) {
            AuthActivity.actionView(getActivity());
        }
        // 个人车主认证
        else if (flag.equalsIgnoreCase("personalCarAuth")) {
            PersonalCarAuthActivity.actionView(this);
        }

        // 个人货主认证
        else if (flag.equalsIgnoreCase("personalGoodsAuth")) {
            PersonalGoodsAuthActivity.actionView(this);
        }

        // 个人仓库认证
        else if (flag.equalsIgnoreCase("personalWarehouseAuth")) {
            PersonalWareHouseAuthActivity.actionView(this);
        }

        // 公司车主认证
        else if (flag.equalsIgnoreCase("companyCarAuth")) {
            CompanyCarAuthActivity.actionView(this);
        }

        // 公司货主认证
        else if (flag.equalsIgnoreCase("companyGoodsAuth")) {
            CompanyGoodsAuthActivity.actionView(this);
        }

        // 公司仓库认证
        else if (flag.equalsIgnoreCase("companyWarehouseAuth")) {
            CompanyWareHouseAuthActivity.actionView(this);
        }
    }

    protected void initView() {
        bank = (TextView) findViewById(R.id.add);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("我的钱包");
        mWebView = (XEWebView) findViewById(R.id.wb);
        backView = findViewById(R.id.rlBack);
        backView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        bank.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MyBankActivity.actionView(WalletActivity.this);
            }
        });
    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("我的钱包");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOnCreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "wallet.html", this, this, this, this);
        }
        isOnCreate = false;
        mWebView.getWebView().loadUrl("javascript:updateStore()");

        super.onResume();
    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("我的钱包");
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
