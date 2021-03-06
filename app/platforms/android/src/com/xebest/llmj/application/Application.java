package com.xebest.llmj.application;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;
import android.view.WindowManager;
import android.webkit.WebView;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.Poi;
import com.baidu.mapapi.SDKInitializer;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.nostra13.universalimageloader.core.display.RoundedBitmapDisplayer;
import com.xebest.llmj.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kaisun on 15/9/20.
 */
public class Application extends android.app.Application {

    public LocationClient mLocationClient;
    public MyLocationListener mMyLocationListener;

    public DisplayImageOptions options;

    private List<Activity> activities = new ArrayList<Activity>();

    private List<Activity> removeActivity = new ArrayList<Activity>();

    public static String UUID;

    public int VERSIONCODE = 0;

    public String VERSIONNAME = "";

    private static Application instance;

    public double latitude = 0.00;

    public double lontitude = 0.00;

    public String contacts = "";

    public String phone = "";

    public String userId = "";

    public int WIDTH = 0;

    public int HEIGHT = 0;

    public boolean loginSuccess = false;

    // 0未认证车主，1认证 2：认证中 3：审核驳回
    public int goodsStatus = -1;
    public int warehouseStatus = -1;
    public int carStatus = -1;

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserId() {
        return userId;
    }

    public static Application getInstance(){
        return instance;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        mLocationClient = new LocationClient(this.getApplicationContext());
        mMyLocationListener = new MyLocationListener();
        mLocationClient.registerLocationListener(mMyLocationListener);

        SDKInitializer.initialize(this);

        instance = this;

        // 每个应用程序的UUID是不一样的
        UUID = java.util.UUID.randomUUID().toString();

        VERSIONCODE = getAppVersionCode();

        VERSIONNAME = getAppVersionName();

        mLocationClient.start();

        SharedPreferences sp = getSharedPreferences("userInfo", 0);
        String id = sp.getString("userId", "");
        int goodStatus = sp.getInt("goodsStatus", -1);
        int warehouseStatuss = sp.getInt("warehouseStatus", -1);
        int carStatuss = sp.getInt("carStatus", -1);
        userId = id;
        if (goodStatus != -1) goodsStatus = goodStatus;
        if (warehouseStatuss != -1) warehouseStatus = warehouseStatuss;
        if (carStatuss != -1) carStatus = carStatuss;


        initImageLoader(getApplicationContext());

        options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.icon_def)
                .showImageForEmptyUri(R.drawable.icon_def)
                .showImageOnFail(R.drawable.icon_def)
                .cacheInMemory(true)
                .cacheOnDisc(true)
                .considerExifParams(true)
                .displayer(new RoundedBitmapDisplayer(20))
                .build();


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true);
        }

        WindowManager wm = (WindowManager) getApplicationContext()
                .getSystemService(Context.WINDOW_SERVICE);

        WIDTH = wm.getDefaultDisplay().getWidth();
        HEIGHT = wm.getDefaultDisplay().getHeight();

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

    public void addRemoveActivity(Activity activity) {
        removeActivity.add(activity);
    }

    public void removeActivity() {
       for (Activity activity : removeActivity) {
           activity.finish();
       }
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

    /**
     * 版本名称
     * @return
     */
    private String getAppVersionName() {
        PackageManager pm = getPackageManager();
        try {
            PackageInfo info = pm.getPackageInfo(this.getPackageName(), 0);
            return info.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return "1.0.0";
        }
    }

    /**
     * 实现实时位置回调监听
     */
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
            if (location.getLocType() == BDLocation.TypeGpsLocation){// GPS定位结果
                sb.append("\nspeed : ");
                sb.append(location.getSpeed());// 单位：公里每小时
                sb.append("\nsatellite : ");
                sb.append(location.getSatelliteNumber());
                sb.append("\nheight : ");
                sb.append(location.getAltitude());// 单位：米
                sb.append("\ndirection : ");
                sb.append(location.getDirection());
                sb.append("\naddr : ");
                sb.append(location.getAddrStr());
                sb.append("\ndescribe : ");
                sb.append("gps定位成功");

            } else if (location.getLocType() == BDLocation.TypeNetWorkLocation){// 网络定位结果
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
            sb.append("\nlocationdescribe : ");// 位置语义化信息
            sb.append(location.getLocationDescribe());
            List<Poi> list = location.getPoiList();// POI信息
            if (list != null) {
                sb.append("\npoilist size = : ");
                sb.append(list.size());
                for (Poi p : list) {
                    sb.append("\npoi= : ");
                    sb.append(p.getId() + " " + p.getName() + " " + p.getRank());
                }
            }
            Log.i("BaiduLocationApi", "-------" + sb.toString());

            latitude = location.getLatitude();
            lontitude = location.getLongitude();
        }

    }

    public void setContacts(String contacts) {
        this.contacts = contacts;
    }

    public String getContacts() {
        return contacts;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPhone() {
        return phone;
    }

    public static void initImageLoader(Context context) {
        // This configuration tuning is custom. You can tune every option, you may tune some of them,
        // or you can create default configuration by
        //  ImageLoaderConfiguration.createDefault(this);
        // method.
        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(context)
                .threadPriority(Thread.NORM_PRIORITY - 2)
                .denyCacheImageMultipleSizesInMemory()
                .discCacheFileNameGenerator(new Md5FileNameGenerator())
                .tasksProcessingOrder(QueueProcessingType.LIFO)
                .writeDebugLogs() // Remove for release app
                .build();
        // Initialize ImageLoader with configuration.
        ImageLoader.getInstance().init(config);
    }

    public boolean isLoginSuccess() {
        return loginSuccess;
    }

    public void setLoginSuccess(boolean loginSuccess) {

        this.loginSuccess = loginSuccess;
    }

    public int getWarehouseStatus() {
        return warehouseStatus;
    }

    public void setWarehouseStatus(int warehouseStatus) {

        this.warehouseStatus = warehouseStatus;
    }

    public void setCarStatus(int carStatus) {

        this.carStatus = carStatus;
    }

    public void setGoodsStatus(int goodsStatus) {
        this.goodsStatus = goodsStatus;
    }

    public int getCarStatus() {

        return carStatus;
    }

    public int getGoodsStatus() {
        return goodsStatus;
    }

}