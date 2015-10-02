package com.xebest.llmj.map;

import android.graphics.Color;
import android.graphics.Point;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.model.LatLng;
import com.google.gson.Gson;
import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.R;
import com.xebest.llmj.model.CarDetailInfo;
import com.xebest.llmj.model.NearInfo;
import com.xebest.llmj.model.StoreDetailInfo;
import com.xebest.llmj.utils.Helper;
import com.xebest.llmj.utils.UploadFile;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by kaisun on 15/9/21.
 */
public class MapFragment extends Fragment implements View.OnClickListener, BaiduMap.OnMapLoadedCallback, BaiduMap.OnMapStatusChangeListener {

    private MapView mMapView;
    private BaiduMap baiduMap;

    private TextView tvGoods;
    private TextView tvCar;
    private TextView tvStore;

    private View goodsLine;
    private View carLine;
    private View storeLine;

    private View goodsBottomView;

    private View carBottomView;

    private View storeBottomView;

    private ImageView goodsClose;
    private ImageView carClose;
    private ImageView storeClose;

    private TextView carDestination;
    private TextView carStartPoint;
    private TextView carDes;

    private TextView storeAddress;
    private TextView storeType;
    private TextView storeTemperatureType;
    private TextView storePrice;

    private int status = 1;

    private List<NearInfo> list = new ArrayList<NearInfo>();

    // 附近的货源--要冷库
    private BitmapDescriptor goodsCold = BitmapDescriptorFactory
            .fromResource(R.drawable.near_goods_cold);
    // 附近的货源--不要冷库
    private BitmapDescriptor goods = BitmapDescriptorFactory
            .fromResource(R.drawable.near_goods);

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.map_webview, container, false);

        view.findViewById(R.id.rl_goods).setOnClickListener(this);
        view.findViewById(R.id.rl_car).setOnClickListener(this);
        view.findViewById(R.id.rl_store).setOnClickListener(this);

        tvGoods = (TextView) view.findViewById(R.id.tv_goods);
        tvCar = (TextView) view.findViewById(R.id.tv_car);
        tvStore = (TextView) view.findViewById(R.id.tv_store);

        goodsLine = view.findViewById(R.id.line_goods);
        carLine = view.findViewById(R.id.line_car);
        storeLine = view.findViewById(R.id.line_store);

        //获取地图控件引用
        mMapView = (MapView) view.findViewById(R.id.bmapView);

        mMapView.getMap().setOnMapLoadedCallback(this);
        mMapView.getMap().setOnMapStatusChangeListener(this);

        goodsBottomView = view.findViewById(R.id.bottom_view_goods);
        carBottomView = view.findViewById(R.id.bottom_view_car);
        storeBottomView = view.findViewById(R.id.bottom_view_store);

        goodsClose = (ImageView) view.findViewById(R.id.goods_close);
        carClose = (ImageView) view.findViewById(R.id.car_close);
        storeClose = (ImageView) view.findViewById(R.id.store_close);
        goodsClose.setOnClickListener(this);
        carClose.setOnClickListener(this);
        storeClose.setOnClickListener(this);

        carDestination = (TextView) view.findViewById(R.id.car_destination);
        carStartPoint = (TextView) view.findViewById(R.id.car_start_point);
        carDes = (TextView) view.findViewById(R.id.car_des);

        storeAddress = (TextView) view.findViewById(R.id.store_address);
        storeType = (TextView) view.findViewById(R.id.store_type);
        storeTemperatureType = (TextView) view.findViewById(R.id.store_temperature_type);
        storePrice = (TextView) view.findViewById(R.id.store_price);

        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        baiduMap = mMapView.getMap();

        mMapView.getMap().setOnMarkerClickListener(new BaiduMap.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker) {
                String title = marker.getTitle();
                Log.i("info", "-----------title:" + title);
                String id = list.get(Integer.parseInt(title)).getId();
                Log.i("info", "-----------id:" + id);
                if (status == 1) {
                    goodsBottomView.setVisibility(View.VISIBLE);
                } else if (status == 2) {
                    carBottomView.setVisibility(View.VISIBLE);
                } else if (status == 3) {
                    storeBottomView.setVisibility(View.VISIBLE);
                }
                new DetailTask().execute(id);
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
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rl_goods:
                // 清空覆盖物
                mMapView.getMap().clear();

                goodsBottomView.setVisibility(View.GONE);
                carBottomView.setVisibility(View.GONE);
                storeBottomView.setVisibility(View.GONE);

                tvGoods.setTextColor(Color.parseColor("#1e90ff"));
                goodsLine.setVisibility(View.VISIBLE);

                tvCar.setTextColor(Color.parseColor("#777777"));
                carLine.setVisibility(View.GONE);

                tvStore.setTextColor(Color.parseColor("#777777"));
                storeLine.setVisibility(View.GONE);

                status = 1;
                new NearTask().execute();

                break;
            case R.id.rl_car:
                // 清空覆盖物
                mMapView.getMap().clear();
                goodsBottomView.setVisibility(View.GONE);
                carBottomView.setVisibility(View.GONE);
                storeBottomView.setVisibility(View.GONE);

                tvGoods.setTextColor(Color.parseColor("#777777"));
                goodsLine.setVisibility(View.GONE);

                tvCar.setTextColor(Color.parseColor("#1e90ff"));
                carLine.setVisibility(View.VISIBLE);

                tvStore.setTextColor(Color.parseColor("#777777"));
                storeLine.setVisibility(View.GONE);

                status = 2;
                new NearTask().execute();

                break;
            case R.id.rl_store:
                // 清空覆盖物
                mMapView.getMap().clear();
                goodsBottomView.setVisibility(View.GONE);
                carBottomView.setVisibility(View.GONE);
                storeBottomView.setVisibility(View.GONE);

                tvGoods.setTextColor(Color.parseColor("#777777"));
                goodsLine.setVisibility(View.GONE);

                tvCar.setTextColor(Color.parseColor("#777777"));
                carLine.setVisibility(View.GONE);

                tvStore.setTextColor(Color.parseColor("#1e90ff"));
                storeLine.setVisibility(View.VISIBLE);

                status = 3;
                new NearTask().execute();
                break;
            case R.id.goods_close:
                goodsBottomView.setVisibility(View.GONE);
                break;
            case R.id.car_close:
                carBottomView.setVisibility(View.GONE);
                break;
            case R.id.store_close:
                storeBottomView.setVisibility(View.GONE);
                break;
        }
    }

    private double leftLng = 0.00;
    private double leftLat = 0.00;
    private double rightLng = 0.00;
    private double rightLat = 0.00;

    @Override
    public void onMapLoaded() {

        getPoint();

        new NearTask().execute();

    }

    @Override
    public void onMapStatusChangeStart(MapStatus mapStatus) {
        Log.i("info", "----onMapStatusChangeStart------");
    }

    @Override
    public void onMapStatusChange(MapStatus mapStatus) {
    }

    @Override
    public void onMapStatusChangeFinish(MapStatus mapStatus) {
        Log.i("info", "----onMapStatusChangeFinish------");
        getPoint();
        new NearTask().execute();

    }

    private class NearTask extends AsyncTask<String, Void, String> {

        @Override
        protected String doInBackground(String... params) {
            String url = "";
            if (status == 1) {
                url = "http://192.168.26.177:7080/llmj-app/findNear/nearGoods.shtml";
            } else if (status == 2) {
                url = "http://192.168.26.177:7080/llmj-app/findNear/nearCar.shtml";
            } else if (status == 3) {
                url = "http://192.168.26.177:7080/llmj-app/findNear/nearWarehouse.shtml";
            }
            Map<String, String> map = new HashMap<String, String>();
            map.put("leftLng", leftLng + "");
            map.put("leftLat", leftLat + "");
            map.put("rightLng", rightLng + "");
            map.put("rightLat", rightLat + "");
            String result = UploadFile.postWithJsonString(url, new Gson().toJson(map));
            Log.i("info", "-------------result:" + result);
            return result;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            // {"code":"0000","data":[{"coldStoreFlag":null,"id":"cdbc35fecae44db783b320691df32a98","lat":39.978765,"lng":116.326359}],"msg":"操作成功"}
            if (s == "" || s == null) return;
            try {
                JSONObject jsonObject = new JSONObject(s);
                String data = jsonObject.getString("data");
                list = JSON.parseArray(data, NearInfo.class);
                Log.i("info", "----------list:" + list.size());
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (list.size() == 0) return;

            for (int i = 0; i < list.size(); i++) {
                // 开始添加覆盖物
                LatLng llA = new LatLng(Double.parseDouble(list.get(i).getLat()), Double.parseDouble(list.get(i).getLng()));
                OverlayOptions ooA;
                if (list.get(i).getColdStoreFlag() != null && list.get(i).getColdStoreFlag().equals("true")) {
                    ooA = new MarkerOptions().position(llA).icon(goodsCold)
                            .zIndex(9).draggable(true);
                } else {
                    ooA = new MarkerOptions().position(llA).icon(goods)
                            .zIndex(9).draggable(true);
                }

                Marker marker = (Marker) (mMapView.getMap().addOverlay(ooA));
                marker.setTitle(i + "");
            }


        }

    }

    public void getPoint() {
        DisplayMetrics dm = new DisplayMetrics();
        getActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
        int Max_X = dm.widthPixels;
        int Max_Y = dm.heightPixels;
        Log.i("info", "-------屏幕宽:" + Max_X + " 高:" + Max_Y);

        // 左下角的经纬度
        Point point = new Point();
        point.x = 0;
        point.y = Max_Y;
        LatLng ll = mMapView.getMap().getProjection().fromScreenLocation(point);
        leftLng = ll.longitude;
        leftLat = ll.latitude;
        Log.i("info", "-----左下角经纬度 x:" + ll.latitude + " y:" + ll.longitude);

        // 右上角的经纬度
        Point point1 = new Point();
        point1.x = Max_X;
        point1.y = 0;
        LatLng ll2 = mMapView.getMap().getProjection().fromScreenLocation(point1);
        rightLng = ll2.longitude;
        rightLat = ll2.latitude;
        Log.i("info", "-----右上角经纬度 x:" + ll2.latitude + " y:" + ll2.longitude);
    }

    /**
     * 详情
     */
    private class DetailTask extends AsyncTask<String, Void, String> {

        @Override
        protected String doInBackground(String... params) {
            String url = "";
            if (status == 1) {
                url = "http://192.168.26.177:7080/llmj-app/carFindGoods/list.shtml";
            } else if (status == 2) {
                url = "http://192.168.26.177:7080/llmj-app/searchCarCtl/searchCar.shtml";
            } else if (status == 3) {
                url = "http://192.168.26.177:7080/llmj-app/searchWarehouseCtl/searchWarehouse.shtml";
            }
            Map<String, String> map = new HashMap<String, String>();
            map.put("id", params[0]);
            String result = UploadFile.postWithJsonString(url, new Gson().toJson(map));
            return result;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            Log.i("info", "------------detail:" + s);
            try {
                JSONObject jsonObject = new JSONObject(s);
                String data = jsonObject.getString("data");
                if (status == 2) { // 车
                    List<CarDetailInfo> list = JSON.parseArray(data, CarDetailInfo.class);
                    carDestination.setText(list.get(0).getToProvinceName() + list.get(0).getToCityName() +
                            list.get(0).getToAreaName());
                    carStartPoint.setText(list.get(0).getFromProvinceName() + list.get(0).getFromCityName() +
                            list.get(0).getFromAreaName());
                    carDes.setText("车辆描述：" + list.get(0).getVehicle() + "米 " + Helper.getCarType(list.get(0).getCarType()));
                } else if (status == 3) { // 库
                    List<StoreDetailInfo> list = JSON.parseArray(data, StoreDetailInfo.class);
                    storeAddress.setText("仓库地址：" + list.get(0).getProvinceName() + list.get(0).getCityName() +
                            list.get(0).getAreaName() + list.get(0).getName());
                    storeType.setText("仓库类型：" + Helper.getStoreType(list.get(0).getWareHouseType()));
                    storeTemperatureType.setText("库温类型：" + list.get(0).getCuvinType());
                    storePrice.setText("价格：" + list.get(0).getPrice());
                } else if (status == 1) {// 货

                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

    }

}
