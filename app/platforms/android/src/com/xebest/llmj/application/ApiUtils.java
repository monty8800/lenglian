package com.xebest.llmj.application;

/**
 * 公共变量
 * Created by kaisun on 15/7/10.
 */
public interface ApiUtils {

    // html文件公用头路径
    String API_COMMON_URL = "file:///android_asset/www/";

    String SERVER = "http://192.168.26.177:7080/llmj-app/";

    String SERVER_Z = "http://192.168.29.204:8072/";

    // 查询货源列表
    String STORE_LIST = SERVER + "mjGoodsResource/queryMjGoodsResourceList.shtml";

    // 附近车找货下单
    String car_found_goods = SERVER + "/carFindGoods/orderTrade.shtml";

    // 附近库找货
    String store_found_goods = SERVER + "/mjOrderWarhouse/addWarhouseFoundGoodsOrder.shtml";

    // 我要找车--选择此车---货找车--订单提交
    String goods_found_car = SERVER + "goodFoundCarCtl/goodFoundCar.shtml";

}
