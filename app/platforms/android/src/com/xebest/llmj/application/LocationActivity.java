package com.xebest.llmj.application;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.location.Poi;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.InfoWindow;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.geocode.GeoCodeResult;
import com.baidu.mapapi.search.geocode.GeoCoder;
import com.baidu.mapapi.search.geocode.OnGetGeoCoderResultListener;
import com.baidu.mapapi.search.geocode.ReverseGeoCodeOption;
import com.baidu.mapapi.search.geocode.ReverseGeoCodeResult;
import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.R;

import java.util.List;

/**
 * Created by kaisun on 15/9/22.
 */
public class LocationActivity extends Activity implements OnGetGeoCoderResultListener {

    private Marker mMarkerA;
    private MapView mMapView = null;
    private BaiduMap mBaiduMap;
    public LocationClient mLocationClient = null;
    private GeoCoder mSearch = null; // 搜索模块，也可去掉地图模块独立使用
    private InfoWindow mInfoWindow;
    public BDLocationListener myListener = new MyLocationListener();


    // 初始化全局 bitmap 信息，不用时及时 recycle
    private BitmapDescriptor bdA = BitmapDescriptorFactory
            .fromResource(R.drawable.my_location);

    private View view;

    private TextView loc;
    private TextView des;

    private Button btnSubmit;

    private double mLatitude = 0.00;

    private double mLontitud = 0.00;

    private String mProvince = "";

    private String mCity = "";

    private String mArea = "";

    private String mStreet = "";

    private String mStreetNumber = "";

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, LocationActivity.class));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.location);

        initView();

        // 声明LocationClient类
        mLocationClient = new LocationClient(getApplicationContext());
        mLocationClient.registerLocationListener(myListener);

        initLocation();

        mLocationClient.start();

        btnSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.i("info", "-------mLatitude" + mLatitude);
                Log.i("info", "-------mLontitud" + mLontitud);
                Log.i("info", "-------mProvince" + mProvince);
                Log.i("info", "-------mCity" + mCity);
                Log.i("info", "-------mStreet" + mStreet);
                Log.i("info", "-------mStreetNumber" + mStreetNumber);

                SharedPreferences.Editor editor = getSharedPreferences("location", 0).edit();
                editor.putString("mLatitude", mLatitude + "");
                editor.putString("mLontitud", mLontitud + "");
                editor.putString("mProvince", mProvince + "");
                editor.putString("mCity", mCity + "");
                editor.putString("mArea", mArea + "");
                editor.putString("mStreet", mStreet + "");
                editor.putString("mStreetNumber", mStreetNumber + "");
                editor.commit();
                finish();
            }
        });

    }

    public void initLocation() {
        LocationClientOption option = new LocationClientOption();
        option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy
        );//可选，默认高精度，设置定位模式，高精度，低功耗，仅设备
        option.setCoorType("bd09ll");//可选，默认gcj02，设置返回的定位结果坐标系
        int span = 1000;
        option.setScanSpan(span);//可选，默认0，即仅定位一次，设置发起定位请求的间隔需要大于等于1000ms才是有效的
        option.setIsNeedAddress(true);//可选，设置是否需要地址信息，默认不需要
        option.setOpenGps(true);//可选，默认false,设置是否使用gps
        option.setLocationNotify(true);//可选，默认false，设置是否当gps有效时按照1S1次频率输出GPS结果
        option.setIsNeedLocationDescribe(true);//可选，默认false，设置是否需要位置语义化结果，可以在BDLocation.getLocationDescribe里得到，结果类似于“在北京天安门附近”
        option.setIsNeedLocationPoiList(true);//可选，默认false，设置是否需要POI结果，可以在BDLocation.getPoiList里得到
        option.setIgnoreKillProcess(false);//可选，默认false，定位SDK内部是一个SERVICE，并放到了独立进程，设置是否在stop的时候杀死这个进程，默认杀死
        option.SetIgnoreCacheException(false);//可选，默认false，设置是否收集CRASH信息，默认收集
        option.setEnableSimulateGps(false);//可选，默认false，设置是否需要过滤gps仿真结果，默认需要
        mLocationClient.setLocOption(option);
    }

    @Override
    public void onGetGeoCodeResult(GeoCodeResult geoCodeResult) {

    }

    @Override
    public void onGetReverseGeoCodeResult(ReverseGeoCodeResult result) {
        if (result == null || result.error != SearchResult.ERRORNO.NO_ERROR) {
            Toast.makeText(LocationActivity.this, "抱歉，未能找到结果", Toast.LENGTH_LONG)
                    .show();
            return;
        }

        mLatitude = result.getLocation().latitude;

        mLontitud = result.getLocation().longitude;

        mProvince = result.getAddressDetail().province;

        mCity = result.getAddressDetail().city;

        mArea = result.getAddressDetail().district;

        mStreet = result.getAddressDetail().street;

        mStreetNumber = result.getAddressDetail().streetNumber;

        if (result.getAddress() != null) {
            loc.setText(result.getAddress());
        }
        if (result != null && result.getAddressDetail() != null && result.getAddressDetail().street != null) {
            des.setText(result.getAddressDetail().street + result.getAddressDetail().streetNumber);
        }

        if (result.getLocation() == null) return;
        mInfoWindow = new InfoWindow(view, result.getLocation(), -120);
        if (mInfoWindow != null) {
            mBaiduMap.showInfoWindow(mInfoWindow);
        }
    }


    public class MyLocationListener implements BDLocationListener {

        @Override
        public void onReceiveLocation(BDLocation location) {
            //Receive Location
            StringBuffer sb = new StringBuffer(256);
            sb.append("time : ");
            sb.append(location.getTime());
            sb.append("\nerror code : ");
            sb.append(location.getLocType());
            sb.append("\nlatitude : ");
            sb.append(location.getLatitude());
            sb.append("\nlontitude : ");
            sb.append(location.getLongitude());
            sb.append("\nradius : ");
            sb.append(location.getRadius());
            if (location.getLocType() == BDLocation.TypeGpsLocation) {// GPS定位结果
                sb.append("\nspeed : ");
                sb.append(location.getSpeed());// 单位：公里每小时
                sb.append("\nsatellite : ");
                sb.append(location.getSatelliteNumber());
                sb.append("\nheight : ");
                sb.append(location.getAltitude());// 单位：米
                sb.append("\ndirection : ");
                sb.append(location.getDirection());// 单位度
                sb.append("\naddr : ");
                sb.append(location.getAddrStr());
                sb.append("\ndescribe : ");
                sb.append("gps定位成功");


            } else if (location.getLocType() == BDLocation.TypeNetWorkLocation) {// 网络定位结果
                sb.append("\naddr : ");
                sb.append(location.getAddrStr());
                //运营商信息
                sb.append("\noperationers : ");
                sb.append(location.getOperators());
                sb.append("\ndescribe : ");
                sb.append("网络定位成功");
            } else if (location.getLocType() == BDLocation.TypeOffLineLocation) {// 离线定位结果
                sb.append("\ndescribe : ");
                sb.append("离线定位成功，离线定位结果也是有效的");
            } else if (location.getLocType() == BDLocation.TypeServerError) {
                sb.append("\ndescribe : ");
                sb.append("服务端网络定位失败，可以反馈IMEI号和大体定位时间到loc-bugs@baidu.com，会有人追查原因");
            } else if (location.getLocType() == BDLocation.TypeNetWorkException) {
                sb.append("\ndescribe : ");
                sb.append("网络不同导致定位失败，请检查网络是否通畅");
            } else if (location.getLocType() == BDLocation.TypeCriteriaException) {
                sb.append("\ndescribe : ");
                sb.append("无法获取有效定位依据导致定位失败，一般是由于手机的原因，处于飞行模式下一般会造成这种结果，可以试着重启手机");
            }
            sb.append("\nlocationdescribe : ");
            sb.append(location.getLocationDescribe());// 位置语义化信息
            List<Poi> list = location.getPoiList();// POI数据
            if (list != null) {
                sb.append("\npoilist size = : ");
                sb.append(list.size());
                for (Poi p : list) {
                    sb.append("\npoi= : ");
                    sb.append(p.getId() + " " + p.getName() + " " + p.getRank());
                }
            }
            Log.i("area", "--------------" + location.getAddress().district);
            Log.i("BaiduLocationApiDem", "--------------" + sb.toString());

            // 物理地址
            String addr = location.getAddrStr();
            // 精度
            double latitude = location.getLatitude();
            // 维度
            double lontitud = location.getLongitude();

            mLatitude = latitude;

            mLontitud = lontitud;

            mProvince = location.getProvince();

            mCity = location.getCity();

            mArea = location.getAddress().district;

            mStreet = location.getStreet();

            mStreetNumber = location.getStreetNumber();

            initOverlay(latitude, lontitud);

            loc.setText(location.getAddrStr());
            des.setText(location.getLocationDescribe());

        }
    }

    public void initOverlay(double lat, double lon) {
        LatLng llA = new LatLng(lat, lon);

        MapStatus mMapStatus = new MapStatus.Builder().target(llA).zoom(14.0f).build();

        MapStatusUpdate mMapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mMapStatus);

        mBaiduMap.setMapStatus(mMapStatusUpdate);

        OverlayOptions ooA = new MarkerOptions().position(llA).icon(bdA)
                .zIndex(9).draggable(true);
        mMarkerA = (Marker) (mBaiduMap.addOverlay(ooA));

        mBaiduMap.setOnMarkerDragListener(new BaiduMap.OnMarkerDragListener() {
            @Override
            public void onMarkerDrag(Marker marker) {

            }

            @Override
            public void onMarkerDragEnd(Marker marker) {

                LatLng ll = marker.getPosition();

                mSearch.reverseGeoCode(new ReverseGeoCodeOption()
                        .location(ll));

                // 重新设置地图中心点
                MapStatus mMapStatus = new MapStatus.Builder().target(ll).zoom(14.0f).build();

                MapStatusUpdate mMapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mMapStatus);

                mBaiduMap.setMapStatus(mMapStatusUpdate);

            }

            @Override
            public void onMarkerDragStart(Marker marker) {
                mBaiduMap.hideInfoWindow();
            }
        });

    }

    public void initView() {
        mMapView = (MapView) findViewById(R.id.bmapView);
        btnSubmit = (Button) findViewById(R.id.submit);

        mBaiduMap = mMapView.getMap();

        // 初始化搜索模块，注册事件监听
        mSearch = GeoCoder.newInstance();
        mSearch.setOnGetGeoCodeResultListener(this);

        view = LayoutInflater.from(LocationActivity.this).inflate(R.layout.location_over, null);

        loc = (TextView) view.findViewById(R.id.loc);
        des = (TextView) view.findViewById(R.id.des);


        findViewById(R.id.tvTitle).setVisibility(View.VISIBLE);
        ((TextView) findViewById(R.id.tvTitle)).setText("定位");

        findViewById(R.id.rlBack).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        mBaiduMap.setOnMarkerClickListener(new BaiduMap.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker) {
                LatLng ll = marker.getPosition();
                mInfoWindow = new InfoWindow(view, ll, -120);
                mBaiduMap.showInfoWindow(mInfoWindow);
                return false;
            }
        });
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
    protected void onStop() {
        super.onStop();
        mMapView.getMap().setMyLocationEnabled(false);
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
        bdA.recycle();
    }

}
