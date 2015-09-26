package com.xebest.app.map;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.MapView;
import com.umeng.analytics.MobclickAgent;
import com.xebest.app.R;

/**
 * Created by kaisun on 15/9/21.
 */
public class MapFragment extends Fragment implements View.OnClickListener {

    private MapView mMapView;
    private BaiduMap baiduMap;

    private TextView tvGoods;
    private TextView tvCar;
    private TextView tvStore;

    private View goodsLine;
    private View carLine;
    private View storeLine;

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

        return view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        baiduMap = mMapView.getMap();

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
                tvGoods.setTextColor(Color.parseColor("#1e90ff"));
                goodsLine.setVisibility(View.VISIBLE);

                tvCar.setTextColor(Color.parseColor("#777777"));
                carLine.setVisibility(View.GONE);

                tvStore.setTextColor(Color.parseColor("#777777"));
                storeLine.setVisibility(View.GONE);
                break;
            case R.id.rl_car:
                tvGoods.setTextColor(Color.parseColor("#777777"));
                goodsLine.setVisibility(View.GONE);

                tvCar.setTextColor(Color.parseColor("#1e90ff"));
                carLine.setVisibility(View.VISIBLE);

                tvStore.setTextColor(Color.parseColor("#777777"));
                storeLine.setVisibility(View.GONE);

                break;
            case R.id.rl_store:
                tvGoods.setTextColor(Color.parseColor("#777777"));
                goodsLine.setVisibility(View.GONE);

                tvCar.setTextColor(Color.parseColor("#777777"));
                carLine.setVisibility(View.GONE);

                tvStore.setTextColor(Color.parseColor("#1e90ff"));
                storeLine.setVisibility(View.VISIBLE);
                break;
        }
    }

}
