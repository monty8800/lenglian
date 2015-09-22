package com.xebest.app.center;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.xebest.app.R;
import com.xebest.app.application.ApiUtils;
import com.xebest.app.application.Application;
import com.xebest.app.car.CarActivity;
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
                        CarActivity.actionView(getActivity());
                    } else if (flag.equalsIgnoreCase("addressList")) {
                        AddressActivity.actionView(getActivity());
                    } else if (flag.equalsIgnoreCase("attentionList")) {
                        AttentionActivity.actionView(getActivity());
                    } else if (flag.equalsIgnoreCase("more")) {
                        MoreActivity.actionView(getActivity());
                    } else if (flag.equalsIgnoreCase("login")) {
                        LoginActivity.actionView(getActivity());
                    }
                }
            });
        }

        @Override
        public void onActivityCreated(@Nullable Bundle savedInstanceState) {
            super.onActivityCreated(savedInstanceState);
            mWebView.init(getActivity(), ApiUtils.API_COMMON_URL + "userCenter.html", this, this, this, this);
        }

        @Override
        public void startActivityForResult(CordovaPlugin command, Intent intent, int requestCode) {

        }

        @Override
        public void setActivityResultCallback(CordovaPlugin plugin) {

        }

        @Override
        public Object onMessage(String id, Object data) {
            mWebView.getWebView().loadUrl("javascript:(function(){uuid='" + Application.UUID + "';version='" + ((Application) getActivity().getApplicationContext()).VERSIONCODE + "';client_type='2';})();");
            return null;
        }


}
