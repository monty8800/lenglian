package com.xebest.app.application;

import android.app.Activity;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import com.baidu.mapapi.SDKInitializer;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kaisun on 15/9/20.
 */
public class Application extends android.app.Application {

    private List<Activity> activities = new ArrayList<Activity>();

    public static String UUID;

    public int VERSIONCODE;

    private static Application instance;

    public static Application getInstance(){
        return instance;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        SDKInitializer.initialize(this);

        instance = this;

        // 每个应用程序的UUID是不一样的
        UUID = java.util.UUID.randomUUID().toString();

        VERSIONCODE = getAppVersionCode();

    }

    @Override
    public void onTerminate() {
        super.onTerminate();

        for (Activity activity : activities) {
            activity.finish();
        }

        System.exit(0);
    }

    public void addActivity(Activity activity) {
        activities.add(activity);
    }

    /**
     * 版本号
     * @return
     */
    private int getAppVersionCode() {
        PackageManager pm = getPackageManager();
        try {
            PackageInfo info = pm.getPackageInfo(this.getPackageName(), 0);
            return info.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return 0;
        }
    }

}
