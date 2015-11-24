package com.xebest.llmj.wallet;

import android.app.Activity;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.util.Log;

import com.xebest.llmj.R;
import com.xebest.llmj.utils.SQLdm;

/**
 * 支行
 * Created by kaisun on 15/11/23.
 */
public class BranchBankListActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.contact);
        SQLdm sqLdm = new SQLdm();
        SQLiteDatabase db = sqLdm.openDatabase(getApplicationContext());
        Log.i("info", "------------db:" + db);
    }

}
