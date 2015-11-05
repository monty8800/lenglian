package com.xebest.llmj.application;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;

import com.xebest.llmj.R;
import com.xebest.llmj.adapter.ViewPagerAdapter;

import java.util.ArrayList;
import java.util.List;

/**
 * 引导页
 * Created by kaisun on 15/11/4.
 */
public class GuideActivity extends Activity {

    private ViewPagerAdapter vpAdapter;
    private ViewPager mViewPage;
    private List<View> views;

    private Application mApplication;

    public static void actionView(Context context) {
        context.startActivity(new Intent(context, GuideActivity.class));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.guide);

        mApplication = (Application) getApplicationContext();
        mApplication.addActivity(this);

        views = new ArrayList<View>();

        mViewPage = (ViewPager) findViewById(R.id.viewpager);

        LayoutInflater inflater = LayoutInflater.from(this);

        views.add(inflater.inflate(R.layout.guid1, null));
        views.add(inflater.inflate(R.layout.guid2, null));
        views.add(inflater.inflate(R.layout.guid3, null));
        views.add(inflater.inflate(R.layout.guid4, null));

        vpAdapter = new ViewPagerAdapter(views, this);

        mViewPage = (ViewPager) findViewById(R.id.viewpager);
        mViewPage.setAdapter(vpAdapter);

    }

}
