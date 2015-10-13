package com.xebest.llmj.common;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.webkit.WebView;

import com.xebest.llmj.R;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.utils.Tools;
import com.xebest.plugin.XECommand;
import com.xebest.plugin.XELoading;
import com.xebest.plugin.XEToast;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by kaisun on 15/7/10.
 */
public class BaseCordovaActivity extends CordovaActivity implements XECommand, XEToast, XELoading, CordovaInterface {

    private final ExecutorService threadPool = Executors.newCachedThreadPool();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.empty);

        Application mApp = (Application) getApplicationContext();
        mApp.addActivity(this);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true);
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
//        mWebView.getWebView().loadUrl("javascript:(function(){uuid='" + Application.UUID + "';version='" + ((Application) getApplicationContext()).VERSIONCODE + "';client_type='2';})();");
        return null;
    }

    @Override
    public ExecutorService getThreadPool() {
        return threadPool;
    }

    @Override
    public void show(String message, boolean isForce) {
        Tools.createLoadingDialog(this, message);
    }

    @Override
    public void hide() {
        Tools.dismissLoading();
    }

    @Override
    public void showToast(String message, double time, XEToast.ToastPosition position) {
        Tools.showToast(this, message);
    }

    @Override
    public void showToast(String message) {
        Tools.showToast(this, message);
    }

    @Override
    public void showSuccess(String message) {
        Tools.showSuccessToast(this, message);
    }

    @Override
    public void showErr(String message) {
        Tools.showErrorToast(this, message);
    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {

    }

}
