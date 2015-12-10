package com.xebest.llmj.order;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.MainActivity;
import com.xebest.llmj.R;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
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

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String flag = args.getString(1);
        if (flag.equals("carOwnerOrderDetail")) {
            CarOrderDetailActivity.actionView(getActivity());
        } else if (flag.equals("doComment")) {
            DoCommentActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("goodsOrderDetail")) {
            GoodsOrderDetailActivity.actionView(getActivity());
        } else if (flag.equalsIgnoreCase("orderPay")) {
            OrderPayActivity.actionView(getActivity());
        } else if (flag.equals("warehouseOrderDetail")) {
            WareHouseOrderDetail.actionView(getActivity());
        }
    }

    public void reload() {
        if (mWebView != null && mWebView.getWebView() != null) {
            mWebView.getWebView().loadUrl("javascript:comeFromFlag(" + mainActivity.mOrderStatus + ")");
        }
    }

    public void cancelOrder() {
//        CarCancelOrderActivity.actionView(getActivity());
        OrderCancelListActivity.actionView(getActivity(), mainActivity.mOrderStatus);
    }

    @Override
    public void onResume() {
        // 统计页面
        MobclickAgent.onPageStart("订单");
        mWebView.getWebView().loadUrl("javascript:updateStore()");
        super.onResume();

        if (mainActivity.isOrderPayClass) {
            SharedPreferences sp = getActivity().getSharedPreferences("page", 0);
            mainActivity.mOrderStatus = sp.getInt("_page", -1);
            reload();
            mainActivity.isOrderPayClass = false;
        }

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
        if (mWebView == null || mWebView.getWebView() == null) return null;
        mWebView.getWebView().loadUrl("javascript:(function(){uuid='" + Application.getInstance().UUID + "';version='" + Application.getInstance().VERSIONCODE + "';client_type='3';})();");
        mWebView.getWebView().loadUrl("javascript:comeFromFlag(" + mainActivity.mOrderStatus + ")");
        return null;
    }

}