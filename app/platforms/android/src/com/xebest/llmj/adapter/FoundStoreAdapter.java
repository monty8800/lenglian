package com.xebest.llmj.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.xebest.llmj.R;
import com.xebest.llmj.model.CarListInfo;
import com.xebest.llmj.utils.Helper;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kaisun on 15/10/3.
 */
public class FoundStoreAdapter extends BaseAdapter {

    private List<CarListInfo> list;
    private Context mContext;

    public void addData(List<CarListInfo> temp) {
        if (temp.size() != 0) {
            list.addAll(temp);
        }
    }

    public FoundStoreAdapter(Context context) {
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
            convertView = LayoutInflater.from(mContext).inflate(R.layout.found_store_item, null);
            holder = new ViewHolder();
            convertView.setTag(holder);

            holder.type = (TextView) convertView.findViewById(R.id.goods_type);
            holder.name = (TextView) convertView.findViewById(R.id.goods_name);
            holder.weight = (TextView) convertView.findViewById(R.id.goods_weight);
            holder.startAddress = (TextView) convertView.findViewById(R.id.start_store_address);
            holder.endAddress = (TextView) convertView.findViewById(R.id.end_store_address);

        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        holder.startAddress.setText("起始地需要仓库地：" + info.getFromAreaName());
        if (info.getToAreaName().equals("") || info.getToAreaName() == null) {
            holder.endAddress.setVisibility(View.GONE);
        } else {
            holder.endAddress.setVisibility(View.VISIBLE);
            holder.endAddress.setText("目的地需要仓库地：" + info.getToAreaName());
        }
        holder.type.setText("货物名称：" + info.getName());
        holder.name.setText("货物种类：" + Helper.getGoodsType(info.getGoodsType() + ""));
        if (info.getWeight() != null && !info.getWeight().equals("") && info.getCube() != null && !info.getCube().equals("")) {
            holder.weight.setText("货物规格：" + info.getWeight() + "吨 " + info.getCube() + "方");
        } else if (info.getWeight() != null && !info.getWeight().equals("")) {
            holder.weight.setText("货物规格：" + info.getWeight() + "吨");
        } else if (info.getCube() != null && !info.getCube().equals("")) {
            holder.weight.setText("货物规格：" + info.getCube() + "方");
        }

        return convertView;
    }

    public class ViewHolder {
        private TextView type;
        private TextView name;
        private TextView weight;
        private TextView startAddress;
        private TextView endAddress;
    }

}