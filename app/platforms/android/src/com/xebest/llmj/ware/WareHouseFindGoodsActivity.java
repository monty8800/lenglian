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
import com.xebest.llmj.adapter.WareHouseAdapter;
import com.xebest.llmj.application.ApiUtils;
import com.xebest.llmj.application.Application;
import com.xebest.llmj.auth.AuthActivity;
import com.xebest.llmj.auth.CompanyCarAuthActivity;
import com.xebest.llmj.auth.CompanyGoodsAuthActivity;
import com.xebest.llmj.auth.CompanyWareHouseAuthActivity;
import com.xebest.llmj.auth.PersonalCarAuthActivity;
import com.xebest.llmj.auth.PersonalGoodsAuthActivity;
import com.xebest.llmj.auth.PersonalWareHouseAuthActivity;
import com.xebest.llmj.center.LoginActivity;
import com.xebest.llmj.common.BaseCordovaActivity;
import com.xebest.llmj.goods.SearchGoodsDetailActivity;
import com.xebest.llmj.model.WareHouseInfo;
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
 * 仓库找货
 * Created by kaisun on 15/9/22.
 */
public class WareHouseFindGoodsActivity extends BaseCordovaActivity implements CordovaInterface {

    private XEWebView mWebView;

    private View backView;

    private TextView tvTitle;

    private boolean isOnCreate = false;

    private TextView tvOk;

    private String goodsId = "";

    private Dialog mDialog;

    private XListView mListView;

    private List<WareHouseInfo> carList = new ArrayList<WareHouseInfo>();

    private WareHouseAdapter carAdapter;

    /**
     * 活跃当前窗口
     * @param context
     */
    public static void actionView(Context context) {
        context.startActivity(new Intent(context, WareHouseFindGoodsActivity.class));
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
//                Toast.makeText(WareHouseFindGoodsActivity.this, "调用JS", Toast.LENGTH_LONG).show();
                mWebView.getWebView().loadUrl("javascript:doWarehouseSearchGoods()");
            }
        });

    }

    public void onPause() {
        super.onPause();
        // （仅有Activity的应用中SDK自动调用，不需要单独写）保证 onPageEnd 在onPause 之前调用,因为 onPause 中会保存信息
        MobclickAgent.onPageEnd("仓库找货");
        MobclickAgent.onPause(this);
    }

    protected void initView() {
        tvOk = (TextView) findViewById(R.id.near);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("仓库找货");
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
        if (flag.equals("select:warehouse")) {
            // 选择该仓库
            goodsId = args.getString(2);
            new GoodsFoundCar().execute();
        } else if (flag.equalsIgnoreCase("searchGoodsDetail")) {
            SearchGoodsDetailActivity.actionView(WareHouseFindGoodsActivity.this);
        } else if (flag.equalsIgnoreCase("login")) {
            LoginActivity.actionView(WareHouseFindGoodsActivity.this);
        } else if (flag.equalsIgnoreCase("auth")) {
            AuthActivity.actionView(getActivity());
        }
        // 个人车主认证
        else if (flag.equalsIgnoreCase("personalCarAuth")) {
            PersonalCarAuthActivity.actionView(WareHouseFindGoodsActivity.this);
        }

        // 个人货主认证
        else if (flag.equalsIgnoreCase("personalGoodsAuth")) {
            PersonalGoodsAuthActivity.actionView(WareHouseFindGoodsActivity.this);
        }

        // 个人仓库认证
        else if (flag.equalsIgnoreCase("personalWarehouseAuth")) {
            PersonalWareHouseAuthActivity.actionView(WareHouseFindGoodsActivity.this);
        }

        // 公司车主认证
        else if (flag.equalsIgnoreCase("companyCarAuth")) {
            CompanyCarAuthActivity.actionView(WareHouseFindGoodsActivity.this);
        }

        // 公司货主认证
        else if (flag.equalsIgnoreCase("companyGoodsAuth")) {
            CompanyGoodsAuthActivity.actionView(WareHouseFindGoodsActivity.this);
        }

        // 公司仓库认证
        else if (flag.equalsIgnoreCase("companyWarehouseAuth")) {
            CompanyWareHouseAuthActivity.actionView(WareHouseFindGoodsActivity.this);
        }
    }

    @Override
    protected void onResume() {
        // 统计页面(仅有Activity的应用中SDK自动调用，不需要单独写)
        MobclickAgent.onPageStart("仓库找货");
        // 统计时长
        MobclickAgent.onResume(this);
        if (isOnCreate) {
            mWebView.init(this, ApiUtils.API_COMMON_URL + "warehouseSearchGoods.html", this, this, this, this);
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
     * 仓库列表
     */
    public class GoodsFoundCar extends AsyncTask<String, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            Tools.createLoadingDialog(WareHouseFindGoodsActivity.this, "正在加载...");
        }

        @Override
        protected String doInBackground(String... params) {
            Map<String, String> map = new HashMap<String, String>();
            map.put("userId", Application.getInstance().userId);
//            map.put("resourceStatus", "1");
            map.put("pageNow", "1");
            map.put("pageSize", "100");
            map.put("status", "2");
//            map.put("priceType", "1");
//            map.put("coldStoreFlag", "1");
            return UploadFile.postWithJsonString(ApiUtils.my_warehouse, new Gson().toJson(map));
//            return UploadFile.postWithJsonString(ApiUtils.STORE_LIST, new Gson().toJson(map));
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
            Tools.dismissLoading();
            if (s != null && s != "") {
                try {
                    JSONObject jsonObject = new JSONObject(s);
                    if (jsonObject.getString("code").equals("0000")) {
                        String data = jsonObject.getString("data");
                        String str = new JSONObject(data).getString("myWarehouse");
                        List<WareHouseInfo> list = JSON.parseArray(str, WareHouseInfo.class);
                        carList.addAll(list);
                        if (list.size() == 0) {
                            Tools.showErrorToast(WareHouseFindGoodsActivity.this, "还没发布库源哦");
                            return;
                        }
                        showDialog(list);
                    } else {
                        Tools.showErrorToast(WareHouseFindGoodsActivity.this, jsonObject.getString("msg"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 货源、车源、库源列表
     */
    public void showDialog(final List<WareHouseInfo> list) {
        mDialog = Tools.getCustomDialogBg(getActivity(), R.layout.near_lv_dialog,
            new Tools.BindEventView() {
                @Override
                public void bindEvent(final View view) {
                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            mListView = (XListView) view.findViewById(R.id.xlv);
                            mListView.setPullRefreshEnable(false);
                            mListView.setPullLoadEnable(false);
                            mListView.setXListViewListener(new XListView.IXListViewListener() {
                                @Override
                                public void onRefresh() {

                                }

                                @Override
                                public void onLoadMore() {

                                }
                            });

                            view.findViewById(R.id.btnCancel).setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    mDialog.dismiss();
                                }
                            });
                            view.findViewById(R.id.btnOk).setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    int temPos = getCheckedPosition(list);
                                    if (temPos == -1) return;
                                    String warehouseId = carList.get(temPos).getMjWarehouseResourceId();
                                    new CarFoundGoodsTask().execute(warehouseId);
                                    mDialog.dismiss();
                                }
                            });

                            carAdapter = new WareHouseAdapter(getActivity());
                            mListView.setAdapter(carAdapter);
                            // 车
                            carAdapter.addData(list);
                            carAdapter.notifyDataSetChanged();

                            mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                @Override
                                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
//                                    String warehouseId = carList.get(position - 1).getMjWarehouseResourceId();
//                                    new CarFoundGoodsTask().execute(warehouseId);
//                                    mDialog.dismiss();

                                    setChecked(list, position - 1);
                                    carAdapter.notifyDataSetChanged();
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
            map.put("warehouseId", params[0]);
            map.put("orderGoodsId", goodsId);
//            return UploadFile.postWithJsonString(ApiUtils.goods_found_car, new Gson().toJson(map));
            return UploadFile.postWithJsonString(ApiUtils.store_found_goods, new Gson().toJson(map));
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

    public void setChecked(List<WareHouseInfo> list, int position) {
        int size = list.size();
        for (int i = 0; i < size; i++) {
            if (position == i) {
                list.get(i).setIsChecked(true);
            } else {
                list.get(i).setIsChecked(false);
            }
        }
    }

    public int getCheckedPosition(List<WareHouseInfo> list) {
        int size = list.size();
        for (int i = 0; i < size; i++) {
            if (list.get(i).isChecked()) {
                return i;
            }
        }
        return -1;
    }

}
