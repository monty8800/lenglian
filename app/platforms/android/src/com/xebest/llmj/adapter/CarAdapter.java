package com.xebest.llmj.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.xebest.llmj.R;
import com.xebest.llmj.model.CarListInfo;
import com.xebest.llmj.utils.Helper;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kaisun on 15/10/3.
 */
public class CarAdapter extends BaseAdapter {

    private List<CarListInfo> list;
    private Context mContext;

    public void addData(List<CarListInfo> temp) {
        if (temp.size() != 0) {
            list.addAll(temp);
        }
    }

    public CarAdapter (Context context) {
        this.mContext = context;
        list = new ArrayList<CarListInfo>();
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        CarListInfo info = list.get(position);
        ViewHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.car_item, null);
            holder = new ViewHolder();
            convertView.setTag(holder);

            holder.destination = (TextView) convertView.findViewById(R.id.car_destination);
            holder.startPoint = (TextView) convertView.findViewById(R.id.car_start_point);
            holder.priceType = (TextView) convertView.findViewById(R.id.car_type);
            holder.goodsDes = (TextView) convertView.findViewById(R.id.car_des);
            holder.flag = (ImageView) convertView.findViewById(R.id.flag);
            holder.line = convertView.findViewById(R.id.line);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.destination.setText((info.getToProvinceName() == null ? "" : info.getToProvinceName()) + (info.getToCityName() == null ? "" : info.getToCityName()) + (info.getToAreaName() == null ? "" : info.getToAreaName()) + (info.getToStreet() == null ? "" : info.getToStreet()));

        holder.startPoint.setText(info.getFromProvinceName() + info.getFromCityName() + info.getFromAreaName()
                    + (info.getFromStreet() == null ? "" : info.getFromStreet()));

        String price = "";
        if (info.getPrice() != null && !info.getPrice().equals("null")) {
            price = info.getPrice() + "元";
        }

        holder.priceType.setText("价格类型：" + Helper.getPriceType(info.getPriceType()) + " " + price);

        String desc = "";
        // 货物类型 + 重量
        if (info.getWeight() == null || info.getWeight().equals("")) {
            desc = "货物描述：" + info.getName() + " " + info.getCube() + "方 " + Helper.getGoodsType(info.getGoodsType() + "");
        } else if (info.getCube() == null || info.getCube().equals("")) {
            desc = "货物描述：" + info.getName() + " " + info.getWeight() + "吨 " + Helper.getGoodsType(info.getGoodsType() + "");
        } else if (info.getWeight() != null && !info.getWeight().equals("") && info.getCube() != null && !info.getCube().equals("")) {
            desc = "货物描述：" + info.getName() + " " + info.getWeight() + "吨 " + info.getCube() + "方 " + Helper.getGoodsType(info.getGoodsType() + "");
        }
        holder.goodsDes.setText(desc);

        if (info.isChecked()) {
            holder.flag.setVisibility(View.VISIBLE);
        } else {
            holder.flag.setVisibility(View.GONE);
        }

        if (position + 1 == list.size()) {
            holder.line.setVisibility(View.GONE);
        } else {
            holder.line.setVisibility(View.VISIBLE);
        }

        return convertView;
    }

    public class ViewHolder {
        private TextView destination;
        private TextView startPoint;
        private TextView priceType;
        private TextView goodsDes;
        private ImageView flag;
        private View line;
    }

}
