package com.xebest.app.order;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.umeng.analytics.MobclickAgent;
import com.xebest.app.MainActivity;
import com.xebest.app.R;
import com.xebest.app.application.ApiUtils;
import com.xebest.app.application.Application;
import com.xebest.plugin.XEFragment;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;

/**
 * Created by kaisun on 15/9/21.
 */
public class OrderFragment extends XEFragment implements CordovaInterface {

    private XEWebView mWebView;

    private MainActivity mainActivity;

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        mainActivity = (MainActivity) activity;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fwebview, container, false);
        mWebView = (XEWebView) view.findViewById(R.id.wb);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mWebView.init(getActivity(), ApiUtils.API_COMMON_URL + "orderList.html", this, this, this, this);
    }

    public void reload() {
        if (mWebView != null && mWebView.getWebView() != null) {
            mWebView.getWebView().loadUrl("javascript:temp(" + mainActivity.mOrderStatus + ")");
        }
    }

    @Override
    public void onResume() {
        // 统计页面
        MobclickAgent.onPageStart("订单");
        super.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        MobclickAgent.onPageEnd("订单");
    }

    @Override
    public void onDestroy() {
        mWebView = null;
        super.onDestroy();
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
        mWebView.getWebView().loadUrl("javascript:temp(" + mainActivity.mOrderStatus + ")");
        return null;
    }

}
