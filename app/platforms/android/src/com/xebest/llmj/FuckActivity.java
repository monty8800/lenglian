package com.xebest.llmj;

import android.content.res.Configuration;
import android.os.Bundle;
import android.os.PersistableBundle;

import org.apache.cordova.CordovaActivity;

/**
 * It's cordova bug
 * Created by kaisun on 15/9/26.
 */
public class FuckActivity extends CordovaActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        // TouchSlop 最小滑动距离，如果小于这个值，就不认为是滑动操作
//        int x = ViewConfiguration.get(getApplicationContext()).getScaledTouchSlop();
    }

    @Override
    public void onSaveInstanceState(Bundle outState, PersistableBundle outPersistentState) {
        super.onSaveInstanceState(outState, outPersistentState);
    }
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }

}
