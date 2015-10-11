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

    /**价格类型：，
     * 价格类型
     */
    public static String getPriceType(String status) {
        if (status == null) return "未知";
        if (status.equals("1")) {
            return "一口价";
        } else if (status.equals("2")) {
            return "竞价";
        }
        return "未知";
    }

    /**
     * 货物类型 (1:常温、2:冷藏、3:冷冻、4:急冻、5:深冷)
     * @param status
     * @return
     */
    public static String getGoodsType(String status) {
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

    /**
     * 车辆类别
     * @param status 1： 单车、2：前四后四、3：前四后六、4：前四后八、5：后八轮、6：五桥:
     * @return
     */
    public static String carCategory(String status) {
        if (status == null) return "未知";
        if (status.equals("1")) {
            return "单车";
        } else if (status.equals("2")) {
            return "前四后四";
        } else if (status.equals("3")) {
            return "前四后六";
        } else if (status.equals("4")) {
            return "前四后八";
        } else if (status.equals("5")) {
            return "后八轮";
        } else if (status.equals("6")) {
            return "五桥";
        }
        return "未知";
    }

    /**
     * 车辆长度
     * @param status 3.8米、4.2、4.8、5.8、6.2、6.8、7.4、7.8、8.6、9.6、13~15、15米以上
     * @return
     */
    public static String getCarVehicle(String status) {
        if (status == null) return "未知";
        if (status.equals("1")) {
            return "3.8米";
        } else if (status.equals("2")) {
            return "4.2米";
        } else if (status.equals("3")) {
            return "4.8米";
        } else if (status.equals("4")) {
            return "5.8米";
        } else if (status.equals("5")) {
            return "6.2米";
        } else if (status.equals("6")) {
            return "6.8米";
        }  else if (status.equals("6")) {
            return "7.4米";
        } else if (status.equals("6")) {
            return "7.8米";
        } else if (status.equals("6")) {
            return "8.6米";
        } else if (status.equals("6")) {
            return "9.6米";
        } else if (status.equals("6")) {
            return "13~15米";
        } else if (status.equals("6")) {
            return "15米以上";
        }
        return "未知";
    }

    /**
     * 个人or企业
     * @return
     */
    public static String whoAreYou (String status) {
        if (status == null) return "未知";
        if (status.equals("1")) {
            return "(个人)";
        } else if (status.equals("2")) {
            return "(企业)";
        }
        return "未知";
    }

    /**
     * 15810129806
     * 123456a
     */

}
