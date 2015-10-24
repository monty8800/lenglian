package com.xebest.llmj.map;

import android.app.Dialog;
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
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;
import android.widget.Toast;

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
import com.xebest.llmj.adapter.CarAdapter;
import com.xebest.llmj.adapter.GoodsAdapter;
import com.xebest.llmj.adapter.StoreAdapter;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.goods.BiddingActivity;
import com.xebest.llmj.model.CarDetailInfo;
import com.xebest.llmj.model.CarListInfo;
import com.xebest.llmj.model.Goods;
import com.xebest.llmj.model.GoodsDetailInfo;
import com.xebest.llmj.model.NearInfo;
import com.xebest.llmj.model.StoreDetailInfo;
import com.xebest.llmj.utils.Helper;
import com.xebest.llmj.utils.ImageLoader;
import com.xebest.llmj.utils.Tools;
import com.xebest.llmj.utils.UploadFile;
import com.xebest.llmj.widget.CircleImageView;
import com.xebest.llmj.widget.XListView;
import com.xebest.llmj.widget.XListView.IXListViewListener;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by kaisun on 15/9/21.
 */
public class MapFragment extends Fragment implements View.OnClickListener, BaiduMap.OnMapLoadedCallback,
            BaiduMap.OnMapStatusChangeListener {

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

    private Button goodsBtn;
    private Button carBtn;
    private Button storeBtn;

    private Dialog mDialog;

    private XListView mListView;
    private CarAdapter carAdapter;
    private StoreAdapter storeAdapter;

    private int status = 1;

    private String carId = "";

    private String storeId = "";

    private String goodsId = "";

    private List<NearInfo> list = new ArrayList<NearInfo>();

    private List<CarListInfo> carList = new ArrayList<CarListInfo>();

    // 附近的货源--要冷库
    private BitmapDescriptor goodsCold = BitmapDescriptorFactory
            .fromResource(R.drawable.near_goods_cold);
    // 附近的货源--不要冷库
    private BitmapDescriptor goods = BitmapDescriptorFactory
            .fromResource(R.drawable.near_goods);

    private BitmapDescriptor nearCar = BitmapDescriptorFactory
            .fromResource(R.drawable.near_car);

    private BitmapDescriptor nearStore = BitmapDescriptorFactory
            .fromResource(R.drawable.near_store);

    // 货源信息
    private TextView userName;
    private RatingBar rate;
    private TextView destination;
    private TextView start_point;
    private TextView priceType;
    private TextView goods_des;
    private TextView start_time;
    private TextView store_time;
    private CircleImageView userLogo;

    // 价格类型 1：一口价 2：竞价
    private String mPriceType = "";

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

        goodsBtn = (Button) view.findViewById(R.id.select_goods);
        carBtn = (Button) view.findViewById(R.id.select_driver);
        storeBtn = (Button) view.findViewById(R.id.select_store);
        goodsBtn.setOnClickListener(this);
        carBtn.setOnClickListener(this);
        storeBtn.setOnClickListener(this);

        userName = (TextView) view.findViewById(R.id.userName);
        rate = (RatingBar) view.findViewById(R.id.rate);
        destination = (TextView) view.findViewById(R.id.destination);
        start_point = (TextView) view.findViewById(R.id.start_point);
        priceType = (TextView) view.findViewById(R.id.price_type);
        goods_des = (TextView) view.findViewById(R.id.goods_des);
        start_time = (TextView) view.findViewById(R.id.start_time);
        store_time = (TextView) view.findViewById(R.id.store_time);
        userLogo = (CircleImageView) view.findViewById(R.id.user_logo);

        status = 1;

        return view;
    }

    SimpleDateFormat format;

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        baiduMap = mMapView.getMap();
        mMapView.getMap().setOnMarkerClickListener(new BaiduMap.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker) {
                String title = marker.getTitle();
                String id = list.get(Integer.parseInt(title)).getId();
                if (status == 1) {
                    goodsId = id;
                } else if (status == 2) {
                    carId = id;
                } else if (status == 3) {
                    storeId = id;
                }
                new DetailTask().execute(id);
                return false;
            }
        });

        format = new SimpleDateFormat("yyyy-MM-dd");

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
            case R.id.select_goods: // 抢单
                if (Application.getInstance().carStatus == 1) {
                    new CarResourceTask().execute();
                } else {
                    Tools.showErrorToast(getActivity(), "还未认证车主");
                }
                break;
            case R.id.select_driver: // 选择司机
                if (Application.getInstance().goodsStatus == 1) {
                    new SelectDriverTask().execute();
                } else {
                    Tools.showErrorToast(getActivity(), "还未认证货主");
                }
                break;
            case R.id.select_store: // 选择仓库
                if (Application.getInstance().goodsStatus == 1) {
                    new SelectDriverTask().execute();
                } else {
                    Tools.showErrorToast(getActivity(), "还未认证货主");
                }

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
                if (!jsonObject.getString("code").equals("0000")) {
                    Tools.showErrorToast(getActivity(), jsonObject.getString("msg"));
                    return;
                }
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
                OverlayOptions ooA = null;
                if (status == 1) {
                    if (list.get(i).getColdStoreFlag() == null || list.get(i).getColdStoreFlag().equals("1")) {
                        ooA = new MarkerOptions().position(llA).icon(goods)
                                .zIndex(9).draggable(false);
                    } else if (list.get(i).getColdStoreFlag() != null && list.get(i).getColdStoreFlag().equals("2")) {
                        ooA = new MarkerOptions().position(llA).icon(goodsCold)
                                .zIndex(9).draggable(false);
                    }
                } else if (status == 2) {
                    ooA = new MarkerOptions().position(llA).icon(nearCar)
                            .zIndex(9).draggable(false);
                } else {
                    ooA = new MarkerOptions().position(llA).icon(nearStore)
                            .zIndex(9).draggable(false);
                }

                if (ooA != null && mMapView != null && mMapView.getMap() != null) {
                    Marker marker = (Marker) (mMapView.getMap().addOverlay(ooA));
                    marker.setTitle(i + "");
                }
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
                url = ApiUtils.SERVER + "/carFindGoods/list.shtml";
            } else if (status == 2) {
                url = ApiUtils.SERVER + "/searchCarCtl/searchCar.shtml";
            } else if (status == 3) {
                url = ApiUtils.SERVER + "/searchWarehouseCtl/searchWarehouse.shtml";
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
                    if (list.size() == 0) {
                        Toast.makeText(getActivity(), "没有查询到相关数据", Toast.LENGTH_LONG).show();
                        return;
                    }
                    carBottomView.setVisibility(View.VISIBLE);
                    carDestination.setText(list.get(0).getToProvinceName() + list.get(0).getToCityName() +
                            list.get(0).getToAreaName());
                    carStartPoint.setText(list.get(0).getFromProvinceName() + list.get(0).getFromCityName() +
                            list.get(0).getFromAreaName());
                    carDes.setText("车辆描述：" + Helper.getCarVehicle(list.get(0).getVehicle()) + " " + Helper.getCarType(list.get(0).getCarType()));
                } else if (status == 3) { // 库
                    List<StoreDetailInfo> list = JSON.parseArray(data, StoreDetailInfo.class);
                    if (list.size() == 0) {
                        Toast.makeText(getActivity(), "没有查询到相关数据", Toast.LENGTH_LONG).show();
                        return;
                    }
                    storeBottomView.setVisibility(View.VISIBLE);
                    storeAddress.setText("仓库地址：" + list.get(0).getProvinceName() + list.get(0).getCityName() +
                            list.get(0).getAreaName());
//                    storeType.setText("仓库类型：" + Helper.getStoreType(list.get(0).getWareHouseType()));
                    storeType.setText("仓库类型：" + list.get(0).getWareHouseType());
                    storeTemperatureType.setText("库温类型：" + list.get(0).getCuvinType());
                    storePrice.setText("价格：" + list.get(0).getPrice());
                } else if (status == 1) {// 货
                    JSONObject jsonObject1 = new JSONObject(data);
                    List<GoodsDetailInfo> list = JSON.parseArray(jsonObject1.getString("goods"), GoodsDetailInfo.class);
                    if (list.size() == 0) {
                        Toast.makeText(getActivity(), "没有查询到相关数据", Toast.LENGTH_LONG).show();
                        return;
                    }
                    goodsBottomView.setVisibility(View.VISIBLE);
                    mPriceType = list.get(0).getPriceType();
                    if (mPriceType.equals("1")) {
                        goodsBtn.setText("抢单");
                    } else if (mPriceType.equals("2")) {
                        goodsBtn.setText("竞价");
                    }
                    userName.setText(list.get(0).getUserName() + Helper.whoAreYou(list.get(0).getCertificAtion()));
                    if (list.get(0).getUserImgUrl() != null && list.get(0).getUserImgUrl().contains("|")) {
                        String imgUrl = list.get(0).getUserImgUrl();
                        Log.i("info", "-----------imgUrl:" + imgUrl);
                        int ind = imgUrl.lastIndexOf("|");
                        String im = imgUrl.substring(0, ind);
                        Log.i("info", "---------realUrl:" + im);
                        ImageLoader loader = new ImageLoader(getActivity(), R.drawable.icon_def);
                        loader.DisplayImage(ApiUtils.API_PIC + im, userLogo);
//                        ImageLoader.getInstance().displayImage(ApiUtils.API_PIC + im, userLogo, Application.getInstance().options);
                    }

                    destination.setText(list.get(0).getToProvinceName() + list.get(0).getToCityName() + list.get(0).getToAreaName());
                    start_point.setText(list.get(0).getFromProvinceName() + list.get(0).getFromCityName() + list.get(0).getFromAreaName());
                    priceType.setText("价格类型：" + Helper.getPriceType(list.get(0).getPriceType()) + " " + list.get(0).getPrice() + "元");
                    if (list.get(0).getCube() != null && list.get(0).getWeight() != null) {
                        goods_des.setText("货物描述：" + (list.get(0).getName() == null ? "" : list.get(0).getName()) + " " + list.get(0).getWeight() + "吨" + " " + list.get(0).getCube() + "方");
                    } else if (list.get(0).getCube() == null) {
                        goods_des.setText("货物描述：" + (list.get(0).getName() == null ? "" : list.get(0).getName()) + " " + list.get(0).getWeight() + "吨");
                    } else if (list.get(0).getWeight() == null) {
                        goods_des.setText("货物描述：" + (list.get(0).getName() == null ? "" : list.get(0).getName()) + " " + list.get(0).getCube() + "方");
                    }

                    int score = Integer.parseInt(list.get(0).getUserScore());
                    if (score == 0) {
                        rate.setVisibility(View.GONE);
                    } else {
                        float curScore = score / 2;
                        int ma = Math.round(score / 2);
                        rate.setNumStars(ma);
                        rate.setRating(curScore);
                        rate.setVisibility(View.VISIBLE);
                    }
                    long time = Long.valueOf(list.get(0).getInstallStime());
                    Date d1=new Date(time);
                    long time1 = Long.valueOf(list.get(0).getInstallStime());
                    Date d2=new Date(time1);
                    start_time.setText("装货时间：" + format.format(d1) + "到" + format.format(d2));
                    store_time.setVisibility(View.GONE);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }

    /**
     * 查询货源列表--让该司机拉我的那批货
     */
    private class SelectDriverTask extends AsyncTask<String, Void, String> {

        @Override
        protected String doInBackground(String... params) {
            Map<String, String> map = new HashMap<String, String>();
            map.put("userId", Application.getInstance().userId);
            map.put("resourceStatus", "1");
            map.put("pageNow", "1");
            map.put("pageSize", "100");
//            map.put("priceType", "1");
//            map.put("coldStoreFlag", "1");
            return UploadFile.postWithJsonString(ApiUtils.STORE_LIST, new Gson().toJson(map));
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            if (s != null && s != "") {
                try {
                    JSONObject jsonObject = new JSONObject(s);
                    String data = jsonObject.getString("data");
                    String str = new JSONObject(data).getString("GoodsResource");
                    List<CarListInfo> list = JSON.parseArray(str, CarListInfo.class);
                    carList.addAll(list);
                    if (list.size() == 0) {
                        Tools.showErrorToast(getActivity(), "还没发布货源哦");
                        return;
                    }
                    carBottomView.setVisibility(View.GONE);
                    goodsBottomView.setVisibility(View.GONE);
                    storeBottomView.setVisibility(View.GONE);
                    showDialog(list);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 货源、车源、库源列表
     */
    public void showDialog(final List<CarListInfo> list) {
        mDialog = Tools.getCustomDialogBg(getActivity(), R.layout.near_lv_dialog,
        new Tools.BindEventView() {
            @Override
            public void bindEvent(final View view) {
                getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mListView = (XListView) view.findViewById(R.id.xlv);
                        mListView.setPullRefreshEnable(false);
//                        mListView.setXListViewListener((XListView.IXListViewListener) mainActivity);
                        mListView.setXListViewListener(new IXListViewListener() {
                            @Override
                            public void onRefresh() {

                            }

                            @Override
                            public void onLoadMore() {

                            }
                        });
                        if (list.size() < 10) {
                            mListView.setPullLoadEnable(false);
                        } else {
                            mListView.setPullLoadEnable(true);
                        }
                        if (status == 1) {
                            // 货
                        } else if (status == 2) {
                            carAdapter = new CarAdapter(getActivity());
                            mListView.setAdapter(carAdapter);
                            // 车
                            carAdapter.addData(list);
                            carAdapter.notifyDataSetChanged();
                        } else if (status == 3) {
                            // 库
                            storeAdapter = new StoreAdapter(getActivity());
                            mListView.setAdapter(storeAdapter);
                            storeAdapter.addData(list);
                            storeAdapter.notifyDataSetChanged();
                        }

                        mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                            @Override
                            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                                String goodsId = carList.get(position - 1).getId();
                                new CarFoundGoodsTask().execute(goodsId);
                                carBottomView.setVisibility(View.GONE);
                                storeBottomView.setVisibility(View.GONE);
                                mDialog.dismiss();
                            }
                        });
                    }
                });

            }
        });
    }

    /**
     * 车找货下单
     */
    public class CarFoundGoodsTask extends AsyncTask<String, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            Tools.createLoadingDialog(getActivity(), "正在提交...");
        }

        @Override
        protected String doInBackground(String... params) {
            String url = "";
            Map<String, String> map = new HashMap<String, String>();
            map.put("userId", Application.getInstance().userId);
            if (status == 2) {
                map.put("carResourceId", carId);
                map.put("goodsResourceId", params[0]);
                url = ApiUtils.car_found_goods;
            } else if (status == 3) {
                map.put("warehouseId", storeId);
                map.put("orderGoodsId", params[0]);
//                url = ApiUtils.store_found_goods;
                url = ApiUtils.goods_find_store_order;
            } else if (status == 1) {
                url = ApiUtils.goods_found_car;
                map.put("goodsResouseId", goodsId);
                map.put("carResouseId", params[0]);
            }

            return UploadFile.postWithJsonString(url, new Gson().toJson(map));
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            if (s != null && s != "") {
                try {
                    JSONObject jsonObject = new JSONObject(s);
                    String code = jsonObject.getString("code");
                    if (code.equals("0000")) {
                        Tools.showSuccessToast(getActivity(), "下单成功");
                    } else {
                        Tools.showErrorToast(getActivity(), jsonObject.getString("msg"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            Tools.dismissLoading();
        }

    }

    /**
     * 库找货下单
     */
    public class StoreFoundGoodsTash extends AsyncTask<String, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            Tools.createLoadingDialog(getActivity(), "正在提交...");
        }

        @Override
        protected String doInBackground(String... params) {
            Map<String, String> map = new HashMap<String, String>();
            map.put("userId", Application.getInstance().userId);
            map.put("carResourceId", carId);
            map.put("orderGoodsId", params[0]);
            return UploadFile.postWithJsonString(ApiUtils.car_found_goods, new Gson().toJson(map));
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            Log.i("info", "-------------result:" + s);
            if (s != null && s != "") {
                try {
                    JSONObject jsonObject = new JSONObject(s);
                    String code = jsonObject.getString("code");
                    if (code.equals("0000")) {
                        Tools.showSuccessToast(getActivity(), "下单成功");
                    } else {
                        Tools.showErrorToast(getActivity(), jsonObject.getString("msg"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            Tools.dismissLoading();
        }
    }

    /**
     * 抢单列表
     */
    private class CarResourceTask extends AsyncTask<String, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            Tools.createLoadingDialog(getActivity(), "加载中...");
        }

        @Override
        protected String doInBackground(String... params) {
            Map<String, String> map = new HashMap<String, String>();
            map.put("userId", Application.getInstance().userId);
            map.put("goodsResourceId", goodsId);
            return UploadFile.postWithJsonString(ApiUtils.car_resource, new Gson().toJson(map));
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            Log.i("info", "-------ssss:" + s);
            if (s == null || s.equals("")) {
                return;
            }
            try {
                JSONObject jsonObject = new JSONObject(s);
                String data = jsonObject.getString("data");
                List<Goods> list = JSON.parseArray(data, Goods.class);
                Log.i("info", "--------list:" + list.size());
                if (list.size() == 0) return;
                showDialogGoods(list);
                goodsBottomView.setVisibility(View.GONE);
            } catch (Exception e) {
                e.printStackTrace();
            }

            Tools.dismissLoading();
        }
    }

    public void showDialogGoods(final List<Goods> list) {
        mDialog = Tools.getCustomDialogBg(getActivity(), R.layout.near_lv_dialog,
                new Tools.BindEventView() {
                    @Override
                    public void bindEvent(final View view) {
                        getActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                mListView = (XListView) view.findViewById(R.id.xlv);
                                mListView.setPullRefreshEnable(false);
                                mListView.setXListViewListener(new IXListViewListener() {
                                    @Override
                                    public void onRefresh() {

                                    }

                                    @Override
                                    public void onLoadMore() {

                                    }
                                });
                                if (list.size() < 10) {
                                    mListView.setPullLoadEnable(false);
                                } else {
                                    mListView.setPullLoadEnable(true);
                                }

                                // 货
                                GoodsAdapter adapter = new GoodsAdapter(getActivity());
                                mListView.setAdapter(adapter);
                                // 车
                                adapter.addData(list);
                                adapter.notifyDataSetChanged();

                                mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                    @Override
                                    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                                        String carId = list.get(position - 1).getId();
                                        if (mPriceType.equals("1")) {
                                            new GoodsFindCarTask().execute(carId);
                                        } else if (mPriceType.equals("2")) {
                                            // 竞价列表
                                            BiddingActivity.actionView(getActivity(), goodsId, carId);
                                        }
                                        carBottomView.setVisibility(View.GONE);
                                        storeBottomView.setVisibility(View.GONE);
                                        mDialog.dismiss();
                                    }
                                });
                            }
                        });

                    }
                });
    }

    /**
     * 货找车提交订单
     */
    private class GoodsFindCarTask extends AsyncTask<String, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            Tools.createLoadingDialog(getActivity(), "加载中...");
        }

        @Override
        protected String doInBackground(String... params) {
            Map<String, String> map = new HashMap<String, String>();
            map.put("userId", Application.getInstance().userId);
            map.put("goodsResouseId", goodsId);
            map.put("carResouseId", params[0]);
            return UploadFile.postWithJsonString(ApiUtils.goods_found_car, new Gson().toJson(map));
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            if (s != null && !s.equals("")) {
                try {
                    JSONObject jsonObject = new JSONObject(s);
                    String code = jsonObject.getString("code");
                    if (code.equals("0000")) {
                        Tools.showSuccessToast(getActivity(), "下单成功");
                    } else {
                        Tools.showErrorToast(getActivity(), jsonObject.getString("msg"));
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                Tools.dismissLoading();
            }
        }

    }

}
