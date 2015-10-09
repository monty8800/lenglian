package com.xebest.llmj.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.xebest.llmj.R;
import com.xebest.llmj.model.Car;
import com.xebest.llmj.utils.Helper;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kaisun on 15/10/3.
 */
public class MyCarAdapter extends BaseAdapter {

    private List<Car> list;
    private Context mContext;

    public void addData(List<Car> temp) {
        if (temp.size() != 0) {
            list.addAll(temp);
        }
    }

    public MyCarAdapter(Context context) {
        this.mContext = context;
        list = new ArrayList<Car>();
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
        Car info = list.get(position);
        ViewHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.my_car_item, null);
            holder = new ViewHolder();
            convertView.setTag(holder);

            holder.carNo = (TextView) convertView.findViewById(R.id.car_no);
            holder.category = (TextView) convertView.findViewById(R.id.car_category);
            holder.type = (TextView) convertView.findViewById(R.id.car_type);
            holder.length = (TextView) convertView.findViewById(R.id.car_length);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.carNo.setText(info.getCarno());

        holder.category.setText(Helper.carCategory(info.getCategory()));

        holder.type.setText(Helper.getCarType(info.getType()));

        holder.length.setText(Helper.getCarVehicle(info.getVehicle()));

        return convertView;
    }

    public class ViewHolder {
        private TextView carNo;
        private TextView category;
        private TextView type;
        private TextView length;
    }

}
