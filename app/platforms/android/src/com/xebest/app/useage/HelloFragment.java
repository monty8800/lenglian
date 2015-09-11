package com.xebest.app.useage;


import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.xebest.app.R;
import com.xebest.plugin.XEFragment;

/**
 * A simple {@link Fragment} subclass.
 */
public class HelloFragment extends XEFragment {


    public HelloFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        this.setLaunchUrl("file:///android_asset/www/hello.html");
        this.setResource(R.layout.fragment_hello);
        return super.onCreateView(inflater, container, savedInstanceState);
    }
}
