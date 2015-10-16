package com.xebest.llmj.goods;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.R;
import com.xebest.llmj.adapter.GoodsAdapter;
import com.xebest.llmj.adapter.MyCarAdapter;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.llmj.model.Car;
import com.xebest.llmj.model.Goods;
import com.xebest.llmj.utils.Tools;
import com.xebest.llmj.utils.UploadFile;
import com.xebest.llmj.widget.XListView;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by kaisun on 15/9/22.
 */
public class CarFindGoodsActivity extends BaseCordovaActivity implements CordovaInterface {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private TextView addCar;

    private boolean isOnCreate = false;

    private Dialog mDialog;

    private XListView mListView;

    private List<Car> carList = new ArrayList<Car>();

    private MyCarAdapter myCarAdapter;

    private String goodsId = "";

    private boolean isBidding = false;

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, CarFindGoodsActivity.class));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.my_ware);
        isOnCreate = true;
        initView();

    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("司机找货");
        MobclickAgent.onPause(this);
    }

    protected void initView() {
        addCar = (TextView) findViewById(R.id.add);
        addCar.setText("搜索");
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("司机找货");
        mWebView = (XEWebView) findViewById(R.id.wb);
        backView = findViewById(R.id.rlBack);
        backView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        addCar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mWebView.getWebView().loadUrl("javascript:doCarSearchGoods()");
            }
        });
    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String flag = args.getString(1);
        if (flag.equalsIgnoreCase("select:car")) {
            // true 抢单  false竞价
            isBidding = args.getBoolean(3);
            goodsId = args.getString(2);
            new CarResourceTask().execute();
        } else if (flag.equals("carBidGoods")) {
            BiddingActivity.actionView(CarFindGoodsActivity.this, "", "");
        }

    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("司机找货");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOnCreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "carFindGoods.html", this, this, this, this);
        }
        isOnCreate = false;
        super.onResume();
    }

    @Override
    public void startActivityForResult(CordovaPlugin command, Intent intent, int requestCode) {

    }

    @Override
    public void setActivityResultCallback(CordovaPlugin plugin) {

    }

    @Override
    public Activity getActivity() {
        return this;
    }

    @Override
    public Object onMessage(String id, Object data) {
        mWebView.getWebView().loadUrl("javascript:(function(){uuid='" + Application.UUID + "';version='" + ((Application) getApplicationContext()).VERSIONCODE + "';client_type='2';})();");
        return super.onMessage(id, data);
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
            if (s == null || s.equals("")) {
                return;
            }
            try {
                JSONObject jsonObject = new JSONObject(s);
                String data = jsonObject.getString("data");
                List<Goods> list = JSON.parseArray(data, Goods.class);
                Log.i("info", "--------list:" + list.size());
                if (list.size() == 0) {
                    Tools.showSuccessToast(CarFindGoodsActivity.this, "没有可选择的车辆哦");
                } else {
                    showDialogGoods(list);
                }
                Tools.dismissLoading();
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
    }

    public void showDialogGoods(final List<Goods> list) {
        mDialog = Tools.getCustomDialog(getActivity(), R.layout.near_lv_dialog,
                new Tools.BindEventView() {
                    @Override
                    public void bindEvent(final View view) {
                        getActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                mListView = (XListView) view.findViewById(R.id.xlv);
                                mListView.setPullRefreshEnable(false);
                                mListView.setXListViewListener(new XListView.IXListViewListener() {
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
                                        mDialog.dismiss();
                                        if (isBidding) {
                                            mWebView.getWebView().loadUrl("javascript:goBid('" + carId + "', '" + goodsId + "')");
                                        } else {
                                            new GoodsFindCarTask().execute(carId);
                                        }
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
            Tools.createLoadingDialog(getActivity(), "提交中...");
        }

        @Override
        protected String doInBackground(String... params) {
            Map<String, String> map = new HashMap<String, String>();
            map.put("userId", Application.getInstance().userId);
            map.put("goodsResourceId", goodsId);
            map.put("carResourceId", params[0]);
            return UploadFile.postWithJsonString(ApiUtils.order_trade, new Gson().toJson(map));
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
