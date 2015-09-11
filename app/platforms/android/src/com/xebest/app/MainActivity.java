/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
 */

package com.xebest.app;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.xebest.app.useage.HelloFragment;
import com.xebest.plugin.XECommand;
import com.xebest.plugin.XEWebView;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

public class MainActivity extends FragmentActivity implements XECommand
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        // Set by <content src="index.html" /> in config.xml
        setContentView(R.layout.main);

        //framgemnt中封装的webview
        FragmentTransaction f = getSupportFragmentManager().beginTransaction();
        final HelloFragment helloFragment = new HelloFragment();
        f.replace(R.id.fr_hello, helloFragment).commit();

        Button btn = (Button) findViewById(R.id.button);

        //单独使用webview
        XEWebView xeWebView = (XEWebView) findViewById(R.id.wb_index);
        xeWebView.init(this, "file:///android_asset/www/hello.html", this, null, null, null);
        btn.setOnClickListener(new Button.OnClickListener(){
            public void onClick(View v) {
                helloFragment.nativeCallJs("javascript:hello()");
            }
        });
    }

    @Override
    public void jsCallNative(JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d("js call native hah ", args.toString());
    }
}
