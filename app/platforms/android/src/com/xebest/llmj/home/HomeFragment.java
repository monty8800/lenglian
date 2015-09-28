package com.xebest.llmj.home;

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
import com.xebest.llmj.car.AddCarActivity;
import com.xebest.llmj.car.FoundCarActivity;
import com.xebest.llmj.car.ReleaseCarActivity;
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
public class HomeFragment extends XEFragment implements CordovaInterface {

    private XEWebView mWebView;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fwebview, container, false);
        mWebView = (XEWebView) view.findViewById(R.id.wb);
        return view;
    }


    @Override
    public void onResume() {
        // 统计页面
        MobclickAgent.onPageStart("首页");
        super.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        MobclickAgent.onPageEnd("首页");
    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String flag = args.getString(1);
        Toast.makeText(getActivity(), "" + flag, Toast.LENGTH_SHORT).show();
        if (flag.equals("searchCar")) {
            FoundCarActivity.actionView(getActivity());
        } else if (flag.equals("addCar")) {
            AddCarActivity.actionView(getActivity());
        } else if (flag.equals("releaseCar")) {
            ReleaseCarActivity.actionView(getActivity());
        }
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mWebView.init(getActivity(), ApiUtils.API_COMMON_URL + "home.html", this, this, this, this);
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
