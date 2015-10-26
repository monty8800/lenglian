package com.xebest.llmj.application;

import android.os.Environment;

/**
 * 公共变量
 * Created by kaisun on 15/7/10.
 */
public interface ApiUtils {

    // html文件公用头路径
    String API_COMMON_URL = "file:///android_asset/www/";

    String SERVER = "http://192.168.26.177:7080/llmj-app/";

    String SERVER_Z = "http://192.168.29.204:8072/";

    String SERVER_P = "http://192.168.29.149:8072/";

    // 查询货源列表
    String STORE_LIST = SERVER + "mjGoodsResource/queryMjGoodsResourceList.shtml";

    // 附近车找货下单
    String car_found_goods = SERVER + "/carFindGoods/orderTrade.shtml";

    // 附近库找货
    String store_found_goods = SERVER + "/mjOrderWarhouse/addWarhouseFoundGoodsOrder.shtml";

    // 我要找车--选择此车---货找车--订单提交
    String goods_found_car = SERVER + "goodFoundCarCtl/goodFoundCar.shtml";

    // 我的车辆空闲中
    String my_car_freedom = SERVER + "mjCarinfoCtl/queryMjCarinfoFree.shtml";

    String my_car = SERVER + "mjCarinfoCtl/queryMjCarinfo.shtml";

    String car_resource = SERVER + "/carFindGoods/listCarResources.shtml";

    String order_trade = SERVER + "/carFindGoods/orderTrade.shtml";

    String API_PIC = "http://qa-pic.lenglianmajia.com/head/130/130/";

    String goods_find_store_order = SERVER + "/mjOrderWarhouse/addGoodsFoundWarhouseOrder.shtml";


    String storePath = Environment.getExternalStorageDirectory() + "";

    // SD 跟目录
    String rootPath = Environment.getRootDirectory() + "";

    // 修改头像
    String change_head_pic = SERVER + "/loginCtl/changHeadPic.shtml";

    String my_warehouse = SERVER + "/mjWarehouseCtl/queryMjWarehouse.shtml";

    String encryption = "da971f8e9e024f579800cf20c146e6df";

    String client_type = "3";

}
