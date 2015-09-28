package com.xebest.plugin;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.RelativeLayout;

import com.xebest.llmj.utils.Tools;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by ywen on 15/7/21.
 */
public class XEFragment extends Fragment implements XECommand, XEToast, XELoading, CordovaInterface {

    private final ExecutorService threadPool = Executors.newCachedThreadPool();

    private int resource;
    private XEWebView xeWebView;
    private String launchUrl;
    private CordovaInterface cordovaInterface;

    public CordovaInterface getCordovaInterface() {
        return cordovaInterface;
    }

    public void setCordovaInterface(CordovaInterface cordovaInterface) {
        this.cordovaInterface = cordovaInterface;
    }

    public int getResource() {
        return resource;
    }

    public void setResource(int resource) {
        this.resource = resource;
    }

    public XEWebView getXeWebView() {
        return xeWebView;
    }

    public void setXeWebView(XEWebView xeWebView) {
        this.xeWebView = xeWebView;
    }

    public String getLaunchUrl() {
        return launchUrl;
    }

    public void setLaunchUrl(String launchUrl) {
        this.launchUrl = launchUrl;
    }

    public XEToast getXeToast() {
        return xeToast;
    }

    public void setXeToast(XEToast xeToast) {
        this.xeToast = xeToast;
    }

    public XELoading getXeLoading() {
        return xeLoading;
    }

    public void setXeLoading(XELoading xeLoading) {
        this.xeLoading = xeLoading;
    }

    private XEToast xeToast;
    private XELoading xeLoading;
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
//        return inflater.inflate(R.id.fragment_hello, container, false)
        xeWebView = new XEWebView(this.getActivity());
        xeWebView.init(this.getActivity(), launchUrl, this, xeToast, xeLoading, cordovaInterface);
        xeWebView.setId(new Integer(101));
        RelativeLayout.LayoutParams wvlp = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.MATCH_PARENT);
        xeWebView.setLayoutParams(wvlp);
        container.addView(xeWebView);

        // sunkai
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true);
        }

        return inflater.inflate(this.resource, container, false);

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (xeWebView != null && xeWebView.getWebView() != null) {
            xeWebView.getWebView().handleDestroy();
        }
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d("js call native", args.toString());
    }

    public void nativeCallJs(String js) {
        Log.d("native call js", js);
        xeWebView.getWebView().loadUrl(js);
    }

    @Override
    public void startActivityForResult(CordovaPlugin command, Intent intent, int requestCode) {

    }

    @Override
    public void setActivityResultCallback(CordovaPlugin plugin) {

    }

    @Override
    public Object onMessage(String id, Object data) {
//        mWebView.getWebView().loadUrl("javascript:(function(){uuid='" + Application.UUID + "';version='" + ((Application) getActivity().getApplicationContext()).VERSIONCODE + "';client_type='2';})();");
        return null;
    }

    @Override
    public ExecutorService getThreadPool() {
        return threadPool;
    }

    @Override
    public void show(String message, boolean isForce) {
        Tools.createLoadingDialog(getActivity(), message);
    }

    @Override
    public void hide() {
        Tools.dismissLoading();
    }

    @Override
    public void showToast(String message, double time, XEToast.ToastPosition position) {
        Tools.showToast(getActivity(), message);
    }

    @Override
    public void showToast(String message) {
        Tools.showToast(getActivity(), message);
    }

    @Override
    public void showSuccess(String message) {
        Tools.showSuccessToast(getActivity(), message);
    }

    @Override
    public void showErr(String message) {
        Tools.showErrorToast(getActivity(), message);
    }


}
