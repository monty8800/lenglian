package com.xebest.app.common;

import android.os.Bundle;
import android.util.Log;

import com.xebest.app.application.ApiUtils;
import com.xebest.app.application.Application;
import com.xebest.app.utils.Tools;
import com.xebest.plugin.XECommand;
import com.xebest.plugin.XELoading;
import com.xebest.plugin.XEToast;
import com.xebest.plugin.Xebest;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaActivity;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * Created by kaisun on 15/7/10.
 */
public class BaseCordovaActivity extends CordovaActivity implements XECommand, XELoading, XEToast {



    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Application mApp = (Application) getApplicationContext();
        mApp.addActivity(this);

    }

    public void firstLoadUrl(String url) {
        this.launchUrl = ApiUtils.API_COMMON_URL + url;
        loadUrl(launchUrl);

        // 注册Command接口
        Xebest xebest = (Xebest) appView.getPluginManager().getPlugin("XEPlugin");
        xebest.setXeCommand(this);
        xebest.setXeToast(this);
        xebest.setXeLoading(this);

    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.i("info", "------args:" + args.toString());
    }

    public void native2Js(String url) {
        appView.loadUrl(url);
    }

    @Override
    public Object onMessage(String id, Object data) {
        if ("exit".equals(id)) {
            this.finish();
        }

        if ("onPageFinished".equals(id)) {
            appView.loadUrl("javascript:(function(){uuid='" + Application.UUID + "';version='"+
                    ((Application)getApplicationContext()).VERSIONCODE +"';client_type='1';})();");
        }
        return null;
    }

    @Override
    public void show(String message, boolean isForce) {
//        Tools.showLoading(this, message, isForce);
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

}
