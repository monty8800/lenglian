package com.xebest.llmj.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.xebest.llmj.R;
import com.xebest.llmj.model.Goods;
import com.xebest.llmj.utils.Helper;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kaisun on 15/10/3.
 */
public class GoodsAdapter extends BaseAdapter {

    private List<Goods> list;
    private Context mContext;

    public void addData(List<Goods> temp) {
        if (temp.size() != 0) {
            list.addAll(temp);
        }
    }

    public GoodsAdapter(Context context) {
        this.mContext = context;
        list = new ArrayList<Goods>();
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
        Goods info = list.get(position);
        ViewHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.goods_item, null);
            holder = new ViewHolder();
            convertView.setTag(holder);

            holder.carNo = (TextView) convertView.findViewById(R.id.carNo);
            holder.carCategory = (TextView) convertView.findViewById(R.id.carCategory);
            holder.carType = (TextView) convertView.findViewById(R.id.carType);
            holder.carVehicle = (TextView) convertView.findViewById(R.id.carVehicle);
            holder.flag = (ImageView) convertView.findViewById(R.id.flag);
            holder.line = convertView.findViewById(R.id.line);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.carNo.setText("车辆牌号：" + info.getCarno());

        holder.carCategory.setText("车辆类别：" + Helper.carCategory(info.getCategory()));

        holder.carType.setText("车辆类型：" + Helper.getCarType(info.getType()));

        holder.carVehicle.setText("车辆长度：" + Helper.getCarVehicle(info.getVehicle()));

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
        private TextView carNo;
        private TextView carCategory;
        private TextView carType;
        private TextView carVehicle;
        private ImageView flag;
        private View line;
    }

}
