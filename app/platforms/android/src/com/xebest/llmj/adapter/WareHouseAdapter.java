package com.xebest.llmj.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.xebest.llmj.R;
import com.xebest.llmj.model.WareHouseInfo;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kaisun on 15/10/3.
 */
public class WareHouseAdapter extends BaseAdapter {

    private List<WareHouseInfo> list;
    private Context mContext;

    public void addData(List<WareHouseInfo> temp) {
        if (temp.size() != 0) {
            list.addAll(temp);
        }
    }

    public WareHouseAdapter(Context context) {
        this.mContext = context;
        list = new ArrayList<WareHouseInfo>();
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
        WareHouseInfo info = list.get(position);
        ViewHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.ware_item, null);
            holder = new ViewHolder();
            convertView.setTag(holder);

            holder.destination = (TextView) convertView.findViewById(R.id.destination);
            holder.name = (TextView) convertView.findViewById(R.id.name);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.name.setText(info.getName());
        holder.destination.setText(info.getProvinceName() + info.getCityName() + info.getAreaName() + info.getStreet());

        return convertView;
    }

    public class ViewHolder {
        private TextView destination;
        private TextView name;
    }

}
