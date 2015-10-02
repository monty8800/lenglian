package com.xebest.llmj.utils;

/**
 * Created by kaisun on 15/10/2.
 */
public class Helper {

    /**
     * 车辆类型
     * @param status
     */
    public static String getCarType(String status) {
        if (status == null) return "未知";
        if (status.equals("1")) {
            return "普通卡车";
        } else if (status.equals("2")) {
            return "冷藏车";
        } else if (status.equals("3")) {
            return "平板";
        } else if (status.equals("4")) {
            return "箱式";
        } else if (status.equals("5")) {
            return "集装箱";
        } else if (status.equals("6")) {
            return "高栏";
        }
        return "未知";
    }

    /**
     * 仓库类型
     * @param status
     * @return
     */
    public static String getStoreType(String status) {
        if (status == null) return "未知";
        if (status.equals("1")) {
            return "驶入式";
        } else if (status.equals("2")) {
            return "横梁式";
        } else if (status.equals("3")) {
            return "平推式";
        } else if (status.equals("4")) {
            return "自动立体货架式";
        }
        return "未知";
    }

    /**
     * 库温类型
     * @param status
     * @return
     */
    public static String getStoreTerType(String status) {
        if (status == null) return "未知";
        if (status.equals("1")) {
            return "常温";
        } else if (status.equals("2")) {
            return "冷藏";
        } else if (status.equals("3")) {
            return "冷冻";
        } else if (status.equals("4")) {
            return "急冻";
        } else if (status.equals("5")) {
            return "深冷";
        }
        return "未知";
    }

}
