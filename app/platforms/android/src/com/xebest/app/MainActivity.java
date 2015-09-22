/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
 */

package com.xebest.app;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

import com.xebest.app.application.Application;
import com.xebest.app.center.CenterFragment;
import com.xebest.app.home.HomeFragment;
import com.xebest.app.map.MapFragment;
import com.xebest.app.order.OrderFragment;

import java.util.Timer;
import java.util.TimerTask;

public class MainActivity extends FragmentActivity implements View.OnClickListener {

    private View homeView;
    private View mapView;
    private View orderView;
    private View centerView;
    private View topView;

    private View popView;
    private PopupWindow popupWindow;

    private TextView tvGoods;
    private TextView tvDriver;
    private TextView tvStore;

    private ImageView ivHome;
    private ImageView ivMap;
    private ImageView ivOrder;
    private ImageView ivCenter;

    private TextView tvHome;
    private TextView tvMap;
    private TextView tvOrder;
    private TextView tvCenter;

    private TextView tvTitle;

    private HomeFragment homeFragment;
    private MapFragment mapFragment;
    private OrderFragment orderFragment;
    private CenterFragment centerFragment;

    private int mCurrentItem = 0;

    private Application mApplication;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        initView();

        initFragment();

    }

    protected void initView() {

        mApplication = (Application) getApplicationContext();
        mApplication.addActivity(this);

        topView = findViewById(R.id.rl_top);
        homeView = findViewById(R.id.rl_home);
        mapView = findViewById(R.id.rl_map);
        orderView = findViewById(R.id.rl_order);
        centerView = findViewById(R.id.rl_center);

        homeView.setOnClickListener(this);
        mapView.setOnClickListener(this);
        orderView.setOnClickListener(this);
        centerView.setOnClickListener(this);

        ivHome = (ImageView) findViewById(R.id.iv_home);
        ivMap = (ImageView) findViewById(R.id.iv_map);
        ivOrder = (ImageView) findViewById(R.id.iv_order);
        ivCenter = (ImageView) findViewById(R.id.iv_center);

        tvHome = (TextView) findViewById(R.id.tv_home);
        tvMap = (TextView) findViewById(R.id.tv_map);
        tvOrder = (TextView) findViewById(R.id.tv_order);
        tvCenter = (TextView) findViewById(R.id.tv_center);

        tvTitle = (TextView) findViewById(R.id.tv_title);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rl_home:
                setViewState(0);
                break;
            case R.id.rl_map:
                setViewState(1);
                break;
            case R.id.rl_order:
                showPopMenu(orderView);
                break;
            case R.id.rl_center:
                setViewState(3);
                break;
            case R.id.tv_goods: // 货主订单
                setViewState(2);
                tvGoods.setTextColor(Color.parseColor("#00a2f2"));
                popupWindow.dismiss();
                break;
            case R.id.tv_driver: // 司机订单
                setViewState(2);
                popupWindow.dismiss();
                tvDriver.setTextColor(Color.parseColor("#00a2f2"));
                break;
            case R.id.tv_store: // 仓库订单
                setViewState(2);
                popupWindow.dismiss();
                tvStore.setTextColor(Color.parseColor("#00a2f2"));
                break;
        }
    }

    // 初始化默认fragment
    private void initFragment() {
        switch (mCurrentItem) {
            case 0:
                setViewState(0);
                break;
            case 1:
                setViewState(1);
                break;
            case 2:
                setViewState(2);
                break;
            case 3:
                setViewState(3);
                break;
            default:
                break;
        }
    }

    protected void setViewState(int index) {
        FragmentTransaction f = getSupportFragmentManager().beginTransaction();
        switch (index) {
            case 0:

                tvTitle.setText("首页");
                topView.setVisibility(View.GONE);

                ivHome.setBackgroundResource(R.drawable.bar_home_pressed_2);
                ivMap.setBackgroundResource(R.drawable.bar_map_normal_2);
                ivOrder.setBackgroundResource(R.drawable.bar_order_normal_2);
                ivCenter.setBackgroundResource(R.drawable.bar_center_normal_2);

                tvHome.setTextColor(Color.parseColor("#00a2f2"));
                tvMap.setTextColor(Color.parseColor("#777777"));
                tvOrder.setTextColor(Color.parseColor("#777777"));
                tvCenter.setTextColor(Color.parseColor("#777777"));

                if (null == homeFragment) {
                    homeFragment = new HomeFragment();
                }
                f.replace(R.id.tabcontent, homeFragment);
                break;
            case 1:

                tvTitle.setText("附近");
                topView.setVisibility(View.VISIBLE);

                ivHome.setBackgroundResource(R.drawable.bar_home_normal_2);
                ivMap.setBackgroundResource(R.drawable.bar_map_pressed_2);
                ivOrder.setBackgroundResource(R.drawable.bar_order_normal_2);
                ivCenter.setBackgroundResource(R.drawable.bar_center_normal_2);

                tvHome.setTextColor(Color.parseColor("#777777"));
                tvMap.setTextColor(Color.parseColor("#00a2f2"));
                tvOrder.setTextColor(Color.parseColor("#777777"));
                tvCenter.setTextColor(Color.parseColor("#777777"));

                if (null == mapFragment) {
                    mapFragment = new MapFragment();
                }
                f.replace(R.id.tabcontent, mapFragment);

                break;
            case 2:

                tvTitle.setText("订单");
                topView.setVisibility(View.VISIBLE);

                ivHome.setBackgroundResource(R.drawable.bar_home_normal_2);
                ivMap.setBackgroundResource(R.drawable.bar_map_normal_2);
                ivOrder.setBackgroundResource(R.drawable.bar_order_pressed_2);
                ivCenter.setBackgroundResource(R.drawable.bar_center_normal_2);

                tvHome.setTextColor(Color.parseColor("#777777"));
                tvMap.setTextColor(Color.parseColor("#777777"));
                tvOrder.setTextColor(Color.parseColor("#00a2f2"));
                tvCenter.setTextColor(Color.parseColor("#777777"));

                if (null == orderFragment) {
                    orderFragment = new OrderFragment();
                }
                f.replace(R.id.tabcontent, orderFragment);

                break;
            case 3:

                tvTitle.setText("我的");
                topView.setVisibility(View.GONE);

                ivHome.setBackgroundResource(R.drawable.bar_home_normal_2);
                ivMap.setBackgroundResource(R.drawable.bar_map_normal_2);
                ivOrder.setBackgroundResource(R.drawable.bar_order_normal_2);
                ivCenter.setBackgroundResource(R.drawable.bar_center_pressed_2);

                tvHome.setTextColor(Color.parseColor("#777777"));
                tvMap.setTextColor(Color.parseColor("#777777"));
                tvOrder.setTextColor(Color.parseColor("#777777"));
                tvCenter.setTextColor(Color.parseColor("#00a2f2"));

                if (null == centerFragment) {
                    centerFragment = new CenterFragment();
                }
                f.replace(R.id.tabcontent, centerFragment);

                break;
        }
        f.commit();
    }

    /**
     * Order PopWindow
     */
    protected void showPopMenu(View v) {

        LayoutInflater layoutInflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = layoutInflater.inflate(R.layout.order_popwindow, null);

        tvGoods = (TextView) popView.findViewById(R.id.tv_goods);
        tvGoods.setOnClickListener(this);

        tvDriver = (TextView) popView.findViewById(R.id.tv_driver);
        tvDriver.setOnClickListener(this);

        tvStore = (TextView) popView.findViewById(R.id.tv_store);
        tvStore.setOnClickListener(this);

        popupWindow = new PopupWindow(popView, 300, 400);
        // 使其聚集
        popupWindow.setFocusable(true);
        // 设置允许在外点击消失
        popupWindow.setOutsideTouchable(true);

        // 这个是为了点击“返回Back”也能使其消失，并且并不会影响你的背景
        popupWindow.setBackgroundDrawable(new BitmapDrawable());

        int[] location = new int[2];
        v.getLocationOnScreen(location);

        popupWindow.showAtLocation(v, Gravity.NO_GRAVITY, location[0], location[1] - popupWindow.getHeight() - 20);

    }

    /**
     * 菜单、返回键响应
     */
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            exitBy2Click(); // 调用双击退出函数
        }
        return false;
    }

    /**
     * 双击退出函数
     */
    private static Boolean isExit = false;

    private void exitBy2Click() {
        Timer tExit;
        if (isExit == false) {
            isExit = true; // 准备退出
            Toast.makeText(this, "再按一次退出程序", Toast.LENGTH_SHORT).show();
            tExit = new Timer();
            tExit.schedule(new TimerTask() {
                @Override
                public void run() {
                    isExit = false; // 取消退出
                }
            }, 2000); // 如果2秒钟内没有按下返回键，则启动定时器取消掉刚才执行的任务
        } else {
            mApplication.onTerminate();
        }
    }

}
