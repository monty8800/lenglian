package com.xebest.llmj.model;

/**
 * Created by kaisun on 15/10/9.
 */
public class Goods {

    String carno;
    String id;
    String category;
    String type;
    String vehicle;

    public void setCarno(String carno) {
        this.carno = carno;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setVehicle(String vehicle) {
        this.vehicle = vehicle;
    }

    public String getCarno() {

        return carno;
    }

    public String getCategory() {
        return category;
    }

    public String getId() {
        return id;
    }

    public String getType() {
        return type;
    }

    public String getVehicle() {
        return vehicle;
    }
}
