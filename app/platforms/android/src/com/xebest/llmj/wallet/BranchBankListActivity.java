package com.xebest.llmj.wallet;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.xebest.llmj.R;
import com.xebest.llmj.sort.ClearEditText;
import com.xebest.llmj.sort.ContactListActivity;
import com.xebest.llmj.utils.SQLdm;

import java.util.ArrayList;

/**
 * 支行
 * Created by kaisun on 15/11/23.
 */
public class BranchBankListActivity extends Activity {

    private ListView mListView;
//    private SideBar sideBar;
//    private TextView dialog;
    private DataAdapter adapter;
    private ClearEditText mClearEditText;

    /**
     * 汉字转换成拼音的类
     */
//    private CharacterParser characterParser;
//    private List<SortModel> SourceDateList;

    private TextView tvTitle;
    private EditText filterView;

    private Button btnSearch;

    /**
     * 根据拼音来排列ListView里面的数据类
     */
//    private PinyinComparator pinyinComparator;

    /**联系人名称**/
    private ArrayList<String> mBranchName = new ArrayList<String>();

    String bankName = "";

    private Intent intent;

    public static void actionView(Context context) {
        context.startActivity(new Intent(context, ContactListActivity.class));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.branch_bank);

        intent = getIntent();
        if (intent != null) {
            bankName = intent.getStringExtra("bankName");
        }

        new UploadUserHeadTask().execute();

        initViews();

        adapter = new DataAdapter();
        mListView.setAdapter(adapter);
    }

    private void initViews() {
        filterView = (EditText) findViewById(R.id.filter_edit);
        btnSearch = (Button) findViewById(R.id.btn_search);
        tvTitle = (TextView) findViewById(R.id.tvTitle);
        tvTitle.setText("支行");

        findViewById(R.id.rlBack).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        btnSearch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                btnSearch.setVisibility(View.GONE);
                filterView.setVisibility(View.VISIBLE);
                filterView.setFocusable(true);
                filterView.requestFocus();
                toggleInput(BranchBankListActivity.this);
            }
        });

        //实例化汉字转拼音类
//        characterParser = CharacterParser.getInstance();

//        pinyinComparator = new PinyinComparator();

//        sideBar = (SideBar) findViewById(R.id.sidrbar);
//        dialog = (TextView) findViewById(R.id.dialog);
//        sideBar.setTextView(dialog);

        //设置右侧触摸监听
//        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
//
//            @Override
//            public void onTouchingLetterChanged(String s) {
//                //该字母首次出现的位置
//                int position = adapter.getPositionForSection(s.charAt(0));
//                if(position != -1){
//                    sortListView.setSelection(position);
//                }
//            }
//        });

        mListView = (ListView) findViewById(R.id.branchLv);
        mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                //这里要利用adapter.getItem(position)来获取当前position所对应的对象
//                String branchName = ((SortModel) adapter.getItem(position)).getName();
                String branchName = mBranchName.get(position);
                Intent intent = new Intent();
                intent.putExtra("branchName", branchName);
                setResult(100110, intent);
                finish();
            }
        });

//        SourceDateList = filledData(getResources().getStringArray(R.array.date));
//        SourceDateList = filledDataFromDB();

        // 根据a-z进行排序源数据
//        Collections.sort(SourceDateList, pinyinComparator);
//        adapter = new SortAdapter(this, SourceDateList);
//        sortListView.setAdapter(adapter);


        mClearEditText = (ClearEditText) findViewById(R.id.filter_edit);

        //根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                //当输入框里面的值为空，更新为原来的列表，否则为过滤数据列表
//                filterData(s.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count,
                                          int after) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (s.toString().equals("")) {
                    bankName = intent.getStringExtra("bankName");
                } else {
                    bankName = s.toString();
                }
                new UploadUserHeadTask().execute();
            }
        });
    }

    public class UploadUserHeadTask extends AsyncTask<String, Void, String> {

        @Override
        protected String doInBackground(String... params) {
            SQLdm sqLdm = new SQLdm();
            SQLiteDatabase db = sqLdm.openDatabase(getApplicationContext());
            String sql = "select * from branch_bank where branch_name like ?";
            Cursor cursor = db.rawQuery(sql, new String[]{"%" + bankName + "%"});
            if (mBranchName != null && mBranchName.size() != 0) mBranchName.clear();
            while (cursor.moveToNext()) {
                String name = cursor.getString(0);
                mBranchName.add(name);
            }
            Log.i("info", "------------size:" + mBranchName.size());
            return null;
        }

        @Override
        protected void onPostExecute(String s) {
            super.onPostExecute(s);
//            long start = System.currentTimeMillis();
//            Log.i("info", "------------start:" + start);
//            SourceDateList = filledDataFromDB();
//            Collections.sort(SourceDateList, pinyinComparator);
//            adapter = new SortAdapter(BranchBankListActivity.this, SourceDateList);
            adapter.notifyDataSetChanged();;
        }
    }

    /**
     * 填充数据
     * @return
     */
//    private List<SortModel> filledDataFromDB() {
//        List<SortModel> mSortList = new ArrayList<SortModel>();
//        int size = mBranchName.size();
//        for (int i = 0; i < size; i++) {
//            SortModel sortModel = new SortModel();
//            sortModel.setName(mBranchName.get(i));
//            // 汉字转换成拼音
//            String pinyin = characterParser.getSelling(mBranchName.get(i));
//            String sortString = pinyin.substring(0, 1).toUpperCase();
//
//            // 正则表达式，判断首字母是否是英文字母
//            if (sortString.matches("[A-Z]")) {
//                sortModel.setSortLetters(sortString.toUpperCase());
//            } else {
//                sortModel.setSortLetters("#");
//            }
//            mSortList.add(sortModel);
//        }
//        return mSortList;
//    }

    /**
     * 根据输入框中的值来过滤数据并更新ListView
     * @param filterStr
     */
//    private void filterData(String filterStr){
//        List<SortModel> filterDateList = new ArrayList<SortModel>();
//
//        if(TextUtils.isEmpty(filterStr)){
//            filterDateList = SourceDateList;
//        }else{
//            filterDateList.clear();
//            for(SortModel sortModel : SourceDateList){
//                String name = sortModel.getName();
//                if(name.indexOf(filterStr.toString()) != -1 || characterParser.getSelling(name).startsWith(filterStr.toString())){
//                    filterDateList.add(sortModel);
//                }
//            }
//        }
//
//        // 根据a-z进行排序
//        Collections.sort(filterDateList, pinyinComparator);
//        adapter.updateListView(filterDateList);
//    }

    /**
     * 切换软键盘的状态
     * 如当前为收起变为弹出,若当前为弹出变为收起
     */
    private void toggleInput(Context context){
        InputMethodManager inputMethodManager =
                (InputMethodManager)context.getSystemService(Context.INPUT_METHOD_SERVICE);
        inputMethodManager.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
    }

    /**
     * 强制隐藏输入法键盘
     */
    private void hideInput(Context context,View view){
        InputMethodManager inputMethodManager =
                (InputMethodManager)context.getSystemService(Context.INPUT_METHOD_SERVICE);
        inputMethodManager.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }

    private class DataAdapter extends BaseAdapter {

        public int getCount() {
            return mBranchName.size();
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public Object getItem(int position) {
            return null;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ViewHolder holder = null;
            if (convertView == null) {
                convertView = LayoutInflater.from(BranchBankListActivity.this).inflate(R.layout.branch_item, null);
                holder = new ViewHolder();

                holder.tvTitle = (TextView) convertView.findViewById(R.id.title);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }

            holder.tvTitle.setText(mBranchName.get(position));

            return convertView;
        }

        final class ViewHolder {
            TextView tvTitle;
        }
    }

}
