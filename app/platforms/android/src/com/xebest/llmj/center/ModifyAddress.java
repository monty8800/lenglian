package com.xebest.llmj.center;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.geocode.GeoCodeOption;
import com.baidu.mapapi.search.geocode.GeoCodeResult;
import com.baidu.mapapi.search.geocode.GeoCoder;
import com.baidu.mapapi.search.geocode.OnGetGeoCoderResultListener;
import com.baidu.mapapi.search.geocode.ReverseGeoCodeResult;
import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.R;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.application.LocationActivity;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

/**
 * 编辑地址
 * Created by kaisun on 15/9/22.
 */
public class ModifyAddress extends BaseCordovaActivity implements CordovaInterface, OnGetGeoCoderResultListener {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private TextView bank;

    private boolean isOncreate = false;

    private static int who = -1;

    private double latitude;
    private double longitude;

    GeoCoder mSearch = null; // 搜索模块，也可去掉地图模块独立使用

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context, int flag) {
        who = flag;
        context.startActivity(new Intent(context, ModifyAddress.class));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.wallet);
        isOncreate = true;
        initView();

        if (who == 1) {
            tvTitle.setText("编辑地址");
        } else if (who == 2) {
            tvTitle.setText("新增地址");
        }


        // 初始化搜索模块，注册事件监听
        mSearch = GeoCoder.newInstance();
        mSearch.setOnGetGeoCodeResultListener(this);

    }

    String city;
    String detail;
    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        if (args.getString(0).equals("19")) {
            city = args.getString(1);
            detail = args.getString(2);
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mSearch.geocode(new GeoCodeOption().city(city).address(detail));
                }
            });
            // 拿到经纬度，
//            this.runOnUiThread(new Runnable() {
//                @Override
//                public void run() {
//                    Geocoder gc = new Geocoder(ModifyAddress.this, Locale.CHINA);
//                    List<Address> list;
//                    try {
//                        if (TextUtils.isEmpty(city)) return;
//                        list = gc.getFromLocationName(city, 1);
//                        Address address_temp = list.get(0);
//                        //计算经纬度
//                        latitude = address_temp.getLatitude();
//                        longitude = address_temp.getLongitude();
//                    } catch (Exception e) {
//                        e.printStackTrace();
//                    }
//                    mWebView.getWebView().loadUrl("javascript:doSubmit('" + latitude + "', '" + longitude + "')");
//                }
//            });
        } else {
            String flag = args.getString(1);
            if (flag.equalsIgnoreCase("location")) {
                LocationActivity.actionView(this);
            } else if (flag.equals("modify_success") || flag.equals("add_success")) {
                AddressActivity.isUpdate = true;
                finish();
            }
        }
    }

    protected void initView() {
        bank = (TextView) findViewById(R.id.add);
        bank.setVisibility(View.GONE);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("编辑地址");
        mWebView = (XEWebView) findViewById(R.id.wb);
        backView = findViewById(R.id.rlBack);
        backView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("编辑地址");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOncreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "modifyAddress.html", this, this, this, this);
        }
        isOncreate = false;

        SharedPreferences sp = getSharedPreferences("location", 0);
        if (sp.getString("mLatitude", "") != "") {
            String mLatitude = sp.getString("mLatitude", "");
            String mLontitud = sp.getString("mLontitud", "");
            String mProvince = sp.getString("mProvince", "");
            String mCity = sp.getString("mCity", "");
            String mArea = sp.getString("mArea", "");
            String mStreet = sp.getString("mStreet", "");
            String mStreetNumber = sp.getString("mStreetNumber", "");
            String mStr = mStreet + mStreetNumber;
            mWebView.getWebView().loadUrl("javascript:(function(){window.updateAddress({provinceName:'" + mProvince + "', cityName:'" + mCity + "', areaName:'" + mArea + "', street: '" + mStr + "', lati:'" + mLatitude + "', longi:'" + mLontitud + "'})})()");
        }
        SharedPreferences.Editor editor = getSharedPreferences("location", 0).edit();
        editor.putString("mLatitude", "");
        editor.putString("mLontitud", "");
        editor.putString("mProvince", "");
        editor.putString("mCity", "");
        editor.putString("mArea", "");
        editor.putString("mStreet", "");
        editor.putString("mStreetNumber", "");
        editor.commit();
        super.onResume();
    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("编辑地址");
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

    @Override
    public void onGetGeoCodeResult(GeoCodeResult result) {
        if (result == null || result.error != SearchResult.ERRORNO.NO_ERROR) {
            Toast.makeText(ModifyAddress.this, "抱歉，未能找到结果", Toast.LENGTH_LONG)
                    .show();
            return;
        }
//        String strInfo = String.format("纬度：%f 经度：%f",
//                result.getLocation().latitude, result.getLocation().longitude);
        mWebView.getWebView().loadUrl("javascript:doSubmit('" + result.getLocation().latitude + "', '" + result.getLocation().longitude + "')");
    }

    @Override
    public void onGetReverseGeoCodeResult(ReverseGeoCodeResult result) {
//        if (result == null || result.error != SearchResult.ERRORNO.NO_ERROR) {
//            Toast.makeText(GeoCoderDemo.this, "抱歉，未能找到结果", Toast.LENGTH_LONG)
//                    .show();
//            return;
//        }
//        mBaiduMap.clear();
//        mBaiduMap.addOverlay(new MarkerOptions().position(result.getLocation())
//                .icon(BitmapDescriptorFactory
//                        .fromResource(R.drawable.icon_marka)));
//        mBaiduMap.setMapStatus(MapStatusUpdateFactory.newLatLng(result
//                .getLocation()));
//        Toast.makeText(GeoCoderDemo.this, result.getAddress(),
//                Toast.LENGTH_LONG).show();

    }


}
