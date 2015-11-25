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
public class StoreAdapter extends BaseAdapter {

    private List<CarListInfo> list;
    private Context mContext;

    public void addData(List<CarListInfo> temp) {
        if (temp.size() != 0) {
            list.addAll(temp);
        }
    }

    public StoreAdapter(Context context) {
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
            convertView = LayoutInflater.from(mContext).inflate(R.layout.store_item, null);
            holder = new ViewHolder();
            convertView.setTag(holder);

            holder.type = (TextView) convertView.findViewById(R.id.goods_type);
            holder.name = (TextView) convertView.findViewById(R.id.goods_name);
            holder.weight = (TextView) convertView.findViewById(R.id.goods_weight);
            holder.flag = (ImageView) convertView.findViewById(R.id.flag);

        } else {
            holder = (ViewHolder) convertView.getTag();
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

        if (info.isChecked()) {
            holder.flag.setVisibility(View.VISIBLE);
        } else {
            holder.flag.setVisibility(View.GONE);
        }

        return convertView;
    }

    public class ViewHolder {
        private TextView type;
        private TextView name;
        private TextView weight;
        private ImageView flag;
    }

}
