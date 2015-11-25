package com.xebest.llmj.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kaisun on 15/10/3.
 */
public class CarListInfo {

    private boolean isChecked = false;

    public void setIsChecked(boolean isChecked) {
        this.isChecked = isChecked;
    }

    public boolean isChecked() {

        return isChecked;
    }

    private int advance;

    private String arrivalEtime;

    private String arrivalStime;

    private String coldStoreFlag;

    private String contacts;

    private String createTime;

    private String cube;

    private String fromArea;

    private String fromAreaName;

    private String fromCity;

    private String fromCityName;

    private String fromProvince;

    private String fromProvinceName;

    private String fromStreet;

    private int goodsType;

    private String id;

    private String imgurl;

    private String installEtime;

    private String installStime;

    private String isinvoice;

    private List<GoodsRoutes> mjGoodsRoutess = new ArrayList<GoodsRoutes>();

    private String name;

    private String packType;

    private int payType;

    private String phone;

    private String price;

    private String priceType;

    private String remark;

    private String resourceStatus;

    private int status;

    private String toArea;

    private String toCity;

    private String toProvince;

    private String toStreet;

    private String userId;

    private String weight;

    private String toProvinceName;

    private String toCityName;

    private String toAreaName;

    public void setToAreaName(String toAreaName) {
        this.toAreaName = toAreaName;
    }

    public void setToCityName(String toCityName) {
        this.toCityName = toCityName;
    }

    public void setToProvinceName(String toProvinceName) {
        this.toProvinceName = toProvinceName;
    }

    public String getToAreaName() {
        return toAreaName;
    }

    public String getToCityName() {
        return toCityName;
    }

    public String getToProvinceName() {
        return toProvinceName;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public String getWeight() {

        return weight;
    }

    public void setAdvance(int advance){
        this.advance = advance;
    }
    public int getAdvance(){
        return this.advance;
    }
    public void setArrivalEtime(String arrivalEtime){
        this.arrivalEtime = arrivalEtime;
    }
    public String getArrivalEtime(){
        return this.arrivalEtime;
    }
    public void setArrivalStime(String arrivalStime){
        this.arrivalStime = arrivalStime;
    }
    public String getArrivalStime(){
        return this.arrivalStime;
    }
    public void setColdStoreFlag(String coldStoreFlag){
        this.coldStoreFlag = coldStoreFlag;
    }
    public String getColdStoreFlag(){
        return this.coldStoreFlag;
    }
    public void setContacts(String contacts){
        this.contacts = contacts;
    }
    public String getContacts(){
        return this.contacts;
    }
    public void setCreateTime(String createTime){
        this.createTime = createTime;
    }
    public String getCreateTime(){
        return this.createTime;
    }
    public void setCube(String cube){
        this.cube = cube;
    }
    public String getCube(){
        return this.cube;
    }
    public void setFromArea(String fromArea){
        this.fromArea = fromArea;
    }
    public String getFromArea(){
        return this.fromArea;
    }
    public void setFromAreaName(String fromAreaName){
        this.fromAreaName = fromAreaName;
    }
    public String getFromAreaName(){
        return this.fromAreaName;
    }
    public void setFromCity(String fromCity){
        this.fromCity = fromCity;
    }
    public String getFromCity(){
        return this.fromCity;
    }
    public void setFromCityName(String fromCityName){
        this.fromCityName = fromCityName;
    }
    public String getFromCityName(){
        return this.fromCityName;
    }
    public void setFromProvince(String fromProvince){
        this.fromProvince = fromProvince;
    }
    public String getFromProvince(){
        return this.fromProvince;
    }
    public void setFromProvinceName(String fromProvinceName){
        this.fromProvinceName = fromProvinceName;
    }
    public String getFromProvinceName(){
        return this.fromProvinceName;
    }
    public void setFromStreet(String fromStreet){
        this.fromStreet = fromStreet;
    }
    public String getFromStreet(){
        return this.fromStreet;
    }
    public void setGoodsType(int goodsType){
        this.goodsType = goodsType;
    }
    public int getGoodsType(){
        return this.goodsType;
    }
    public void setId(String id){
        this.id = id;
    }
    public String getId(){
        return this.id;
    }
    public void setImgurl(String imgurl){
        this.imgurl = imgurl;
    }
    public String getImgurl(){
        return this.imgurl;
    }
    public void setInstallEtime(String installEtime){
        this.installEtime = installEtime;
    }
    public String getInstallEtime(){
        return this.installEtime;
    }
    public void setInstallStime(String installStime){
        this.installStime = installStime;
    }
    public String getInstallStime(){
        return this.installStime;
    }
    public void setIsinvoice(String isinvoice){
        this.isinvoice = isinvoice;
    }
    public String getIsinvoice(){
        return this.isinvoice;
    }
    public void setMjGoodsRoutes(List<GoodsRoutes> mjGoodsRoutes){
        this.mjGoodsRoutess = mjGoodsRoutes;
    }
    public List<GoodsRoutes> getMjGoodsRoutes(){
        return this.mjGoodsRoutess;
    }
    public void setName(String name){
        this.name = name;
    }
    public String getName(){
        return this.name;
    }
    public void setPackType(String packType){
        this.packType = packType;
    }
    public String getPackType(){
        return this.packType;
    }
    public void setPayType(int payType){
        this.payType = payType;
    }
    public int getPayType(){
        return this.payType;
    }
    public void setPhone(String phone){
        this.phone = phone;
    }
    public String getPhone(){
        return this.phone;
    }
    public void setPrice(String price){
        this.price = price;
    }
    public String getPrice(){
        return this.price;
    }
    public void setPriceType(String priceType){
        this.priceType = priceType;
    }
    public String getPriceType(){
        return this.priceType;
    }
    public void setRemark(String remark){
        this.remark = remark;
    }
    public String getRemark(){
        return this.remark;
    }
    public void setResourceStatus(String resourceStatus){
        this.resourceStatus = resourceStatus;
    }
    public String getResourceStatus(){
        return this.resourceStatus;
    }
    public void setStatus(int status){
        this.status = status;
    }
    public int getStatus(){
        return this.status;
    }
    public void setToArea(String toArea){
        this.toArea = toArea;
    }
    public String getToArea(){
        return this.toArea;
    }
    public void setToCity(String toCity){
        this.toCity = toCity;
    }
    public String getToCity(){
        return this.toCity;
    }
    public void setToProvince(String toProvince){
        this.toProvince = toProvince;
    }
    public String getToProvince(){
        return this.toProvince;
    }
    public void setToStreet(String toStreet){
        this.toStreet = toStreet;
    }
    public String getToStreet(){
        return this.toStreet;
    }
    public void setUserId(String userId){
        this.userId = userId;
    }
    public String getUserId(){
        return this.userId;
    }



}
