package com.xebest.llmj.model;

/**
 * Created by kaisun on 15/10/2.
 */
public class NearInfo {

    private String coldStoreFlag;
    private String lat;
    private String id;
    private String lng;

    public void setColdStoreFlag(String coldStoreFlag) {
        this.coldStoreFlag = coldStoreFlag;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setLng(String lng) {
        this.lng = lng;
    }

    public String getColdStoreFlag() {

        return coldStoreFlag;
    }

    public String getLat() {
        return lat;
    }

    public String getId() {
        return id;
    }

    public String getLng() {
        return lng;
    }

    @Override
    public String toString() {
        return "coldStoreFlag:" + coldStoreFlag + " lat:" + lat + " lng:" + lng;
    }
}