package com.xebest.llmj.application;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;

import com.xebest.llmj.MainActivity;
import com.xebest.llmj.R;

/**
 * 闪屏页
 * Created by kaisun on 15/10/21.
 */
public class SplashActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.splash);

        Application.getInstance().addActivity(this);

        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(3000);
                } catch (Exception e) {
                    e.printStackTrace();
                }
//                MainActivity.actionView(SplashActivity.this, 0);
                SharedPreferences sp = getSharedPreferences(ApiUtils.IS_FIRST_IN, 0);
                Boolean firstTime = sp.getBoolean("first", true);
                if (firstTime) {
//                    // 进入引导页
                    GuideActivity.actionView(SplashActivity.this);
                } else {
                    MainActivity.actionView(SplashActivity.this, 0);
                }
                finish();
            }
        }).start();

    }

}
