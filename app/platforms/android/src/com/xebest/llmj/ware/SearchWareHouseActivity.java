package com.xebest.llmj.ware;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.umeng.analytics.MobclickAgent;
import com.xebest.llmj.R;
import com.xebest.llmj.adapter.CarAdapter;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.center.LoginActivity;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.llmj.model.CarListInfo;
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
public class SearchWareHouseActivity extends BaseCordovaActivity implements CordovaInterface {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private boolean isOnCreate = false;

    private TextView tvOk;

    private String wareHouseId = "";

    private Dialog mDialog;

    private XListView mListView;

    private List<CarListInfo> carList = new ArrayList<CarListInfo>();

    private CarAdapter carAdapter;

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, SearchWareHouseActivity.class));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.found_car);
        isOnCreate = true;
        initView();
        tvOk.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                Toast.makeText(SearchWareHouseActivity.this, "调用JS", Toast.LENGTH_LONG).show();
                mWebView.getWebView().loadUrl("javascript:doSearchWarehouse()");
            }
        });

    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("我要找仓库");
        MobclickAgent.onPause(this);
    }

    protected void initView() {
        tvOk = (TextView) findViewById(R.id.near);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("我要找仓库");
        mWebView = (XEWebView) findViewById(R.id.wb);
        backView = findViewById(R.id.rlBack);
        backView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        super.jsCallNative(args, callbackContext);
        String flag = args.getString(1);
        if (flag.equals("select:goods")) {
            // 选择该仓库
            wareHouseId = args.getString(2);
            new GoodsFoundCar().execute();
        } else if (flag.equalsIgnoreCase("searchWarehouseDetail")) {
            SearchWarehouseDetailActivity.actionView(SearchWareHouseActivity.this);
        } else if (flag.equalsIgnoreCase("login")) {
            LoginActivity.actionView(SearchWareHouseActivity.this);
        }
    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("我要找仓库");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOnCreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "searchWarehouse.html", this, this, this, this);
        }
        isOnCreate = false;

        mWebView.getWebView().loadUrl("javascript:updateStore()");
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
     * 货物列表
     */
    public class GoodsFoundCar extends AsyncTask<String, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            Tools.createLoadingDialog(SearchWareHouseActivity.this, "正在加载...");
        }

        @Override
        protected String doInBackground(String... params) {
            Map<String, String> map = new HashMap<String, String>();
            map.put("userId", Application.getInstance().userId);
            map.put("resourceStatus", "1");
            map.put("pageNow", "1");
            map.put("pageSize", "100");
            return UploadFile.postWithJsonString(ApiUtils.STORE_LIST, new Gson().toJson(map));
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            Tools.dismissLoading();
            if (s != null && s != "") {
                try {
                    JSONObject jsonObject = new JSONObject(s);
                    String data = jsonObject.getString("data");
                    String str = new JSONObject(data).getString("GoodsResource");
                    List<CarListInfo> list = JSON.parseArray(str, CarListInfo.class);
                    carList.addAll(list);
                    if (list.size() == 0) {
                        Tools.showErrorToast(SearchWareHouseActivity.this, "还没发布货源哦");
                        return;
                    }
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
                            carAdapter = new CarAdapter(getActivity());
                            mListView.setAdapter(carAdapter);
                            // 车
                            carAdapter.addData(list);
                            carAdapter.notifyDataSetChanged();

                            mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                @Override
                                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                                    String goodsId = carList.get(position - 1).getId();
                                    new CarFoundGoodsTask().execute(goodsId);
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
            Map<String, String> map = new HashMap<String, String>();
//            map.put("goodsUserId", Application.getInstance().userId);
//            map.put("goodsResouseId", params[0]);
//            map.put("carResouseId", wareHouseId);
            map.put("userId", Application.getInstance().userId);
            map.put("warehouseId", wareHouseId);
            map.put("orderGoodsId", params[0]);
            return UploadFile.postWithJsonString(ApiUtils.goods_find_store_order, new Gson().toJson(map));
//            return UploadFile.postWithJsonString(ApiUtils.store_found_goods, new Gson().toJson(map));
//            return UploadFile.postWithJsonString(ApiUtils.goods_found_car, new Gson().toJson(map));
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

}
