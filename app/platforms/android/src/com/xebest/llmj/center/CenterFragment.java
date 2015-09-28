package com.xebest.llmj.center;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

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
import com.xebest.plugin.XEFragment;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

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
        Toast.makeText(getActivity(), "" + args.toString(), Toast.LENGTH_SHORT).show();
        if (args.length() == 0) return;
        final String flag = args.getString(1);
        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (flag.equalsIgnoreCase("login")) {
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
                }

            }
        });
    }

    @Override
    public void startActivityForResult(CordovaPlugin command, Intent intent, int requestCode) {

    }

    @Override
    public void setActivityResultCallback(CordovaPlugin plugin) {

    }

    @Override
    public Object onMessage(String id, Object data) {
        mWebView.getWebView().loadUrl("javascript:(function(){uuid='" + Application.UUID + "';version='" + ((Application) getActivity().getApplicationContext()).VERSIONCODE + "';client_type='3';})();");
        return null;
    }


}
