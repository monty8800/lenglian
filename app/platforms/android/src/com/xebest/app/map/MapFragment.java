package com.xebest.app.map;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.baidu.mapapi.map.MapView;
import com.umeng.analytics.MobclickAgent;
import com.xebest.app.MainActivity;
import com.xebest.app.R;
import com.xebest.plugin.XEFragment;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;

/**
 * Created by kaisun on 15/9/21.
 */
public class MapFragment extends XEFragment implements CordovaInterface {

//    private XEWebView mWebView;

    private MapView mMapView = null;

    private MainActivity mainActivity;

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        mainActivity = (MainActivity) activity;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.map_webview, container, false);
//        mWebView = (XEWebView) view.findViewById(R.id.wb);

        //获取地图控件引用
        mMapView = (MapView) view.findViewById(R.id.bmapView);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
//        mWebView.init(getActivity(), ApiUtils.API_COMMON_URL + "goodsOwnerOrderList.html", this, this, this, this);
    }

    @Override
    public void onResume() {
        // 统计页面 pwd
        MobclickAgent.onPageStart("附近");
        super.onResume();
        //在activity执行onResume时执行mMapView. onResume ()，实现地图生命周期管理
        mMapView.onResume();
    }

    @Override
    public void onPause() {
        super.onPause();
        MobclickAgent.onPageEnd("附近");
        //在activity执行onPause时执行mMapView. onPause ()，实现地图生命周期管理
        mMapView.onPause();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        //在activity执行onDestroy时执行mMapView.onDestroy()，实现地图生命周期管理
        mMapView.onDestroy();
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


}
