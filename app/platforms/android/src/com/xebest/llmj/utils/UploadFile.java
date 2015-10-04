package com.xebest.llmj.utils;

import android.util.Log;

import com.xebest.llmj.application.Application;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kaisun on 15/9/24.
 */
public class UploadFile {

    private static final String TAG = "uploadFile";


    private static final int TIME_OUT = 10 * 1000; // 超时时间


    private static final String CHARSET = "utf-8"; // 设置编码

    /**
     * 通过拼接的方式构造请求内容，实现参数传输以及文件传输
     *
     * @param url Service net address
     * @param params text content
     * @param
     * @return String result of Service response
     * @throws IOException
     */
    public static String post(String url, Map<String, Object> params, Map<String, File> file1, Map<String, File> file2, Map<String, File> file3)
            throws IOException {
        String BOUNDARY = java.util.UUID.randomUUID().toString();
        String PREFIX = "--", LINEND = "\r\n";
        String MULTIPART_FROM_DATA = "multipart/form-data";
        String CHARSET = "UTF-8";


//        url = "http://192.168.29.176:8072/mjPersonInfoAuthCtl/personInfoAuth.shtml";
//        url = "http://192.168.27.188:8072/enterprise/enterpriseAuthentication.shtml";
//        url = "http://m.lenglianmajia.com/mjPersonInfoAuthCtl/personInfoAuth.shtml";
//        url = "http://192.168.29.176:8072/mjCarinfoCtl/addMjCarinfo.shtml";
        URL uri = new URL(url);
        HttpURLConnection conn = (HttpURLConnection) uri.openConnection();
        conn.setReadTimeout(10 * 1000); // 缓存的最长时间
        conn.setDoInput(true);// 允许输入
        conn.setDoOutput(true);// 允许输出
        conn.setUseCaches(false); // 不允许使用缓存
        conn.setRequestMethod("POST");
        conn.setRequestProperty("connection", "keep-alive");
        conn.setRequestProperty("Charsert", "UTF-8");
        conn.setRequestProperty("Content-Type", MULTIPART_FROM_DATA + ";boundary=" + BOUNDARY);


        // 首先组拼文本类型的参数
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, Object> entry : params.entrySet()) {
            sb.append(PREFIX);
            sb.append(BOUNDARY);
            sb.append(LINEND);
            sb.append("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"" + LINEND);
            sb.append("Content-Type: text/plain; charset=" + CHARSET + LINEND);
            sb.append("Content-Transfer-Encoding: 8bit" + LINEND);
            sb.append(LINEND);
            sb.append(entry.getValue());
            sb.append(LINEND);
        }


                        DataOutputStream outStream = new DataOutputStream(conn.getOutputStream());
        outStream.write(sb.toString().getBytes());
        // 发送文件数据
        if (file1 != null)
            for (Map.Entry<String, File> file : file1.entrySet()) {
                StringBuilder sb1 = new StringBuilder();
                sb1.append(PREFIX);
                sb1.append(BOUNDARY);
                sb1.append(LINEND);
                sb1.append("Content-Disposition: form-data; name=\"" + file.getKey() + "\"; filename=\""
//                sb1.append("Content-Disposition: form-data; name=\""
                        + file.getValue().getName() + "\"" + LINEND);
                sb1.append("Content-Type: application/octet-stream; charset=" + CHARSET + LINEND);
                sb1.append(LINEND);
                outStream.write(sb1.toString().getBytes());


                InputStream is = new FileInputStream(file.getValue());
                byte[] buffer = new byte[1024];
                int len = 0;
                while ((len = is.read(buffer)) != -1) {
                    outStream.write(buffer, 0, len);
                }


                is.close();
                outStream.write(LINEND.getBytes());
            }

        if (file2 != null)
            for (Map.Entry<String, File> file : file2.entrySet()) {
                StringBuilder sb1 = new StringBuilder();
                sb1.append(PREFIX);
                sb1.append(BOUNDARY);
                sb1.append(LINEND);
                sb1.append("Content-Disposition: form-data; name=\"" + file.getKey() + "\"; filename=\""
//                sb1.append("Content-Disposition: form-data; name=\""
                        + file.getValue().getName() + "\"" + LINEND);
                sb1.append("Content-Type: application/octet-stream; charset=" + CHARSET + LINEND);
                sb1.append(LINEND);
                outStream.write(sb1.toString().getBytes());


                InputStream is = new FileInputStream(file.getValue());
                byte[] buffer = new byte[1024];
                int len = 0;
                while ((len = is.read(buffer)) != -1) {
                    outStream.write(buffer, 0, len);
                }


                is.close();
                outStream.write(LINEND.getBytes());
            }

        if (file3 != null)
            for (Map.Entry<String, File> file : file3.entrySet()) {
                StringBuilder sb1 = new StringBuilder();
                sb1.append(PREFIX);
                sb1.append(BOUNDARY);
                sb1.append(LINEND);
                sb1.append("Content-Disposition: form-data; name=\"" + file.getKey() + "\"; filename=\""
//                sb1.append("Content-Disposition: form-data; name=\""
                        + file.getValue().getName() + "\"" + LINEND);
                sb1.append("Content-Type: application/octet-stream; charset=" + CHARSET + LINEND);
                sb1.append(LINEND);
                outStream.write(sb1.toString().getBytes());


                InputStream is = new FileInputStream(file.getValue());
                byte[] buffer = new byte[1024];
                int len = 0;
                while ((len = is.read(buffer)) != -1) {
                    outStream.write(buffer, 0, len);
                }


                is.close();
                outStream.write(LINEND.getBytes());
            }


        // 请求结束标志
        byte[] end_data = (PREFIX + BOUNDARY + PREFIX + LINEND).getBytes();
        outStream.write(end_data);
        outStream.flush();
        // 得到响应码
        int res = conn.getResponseCode();
        InputStream in = conn.getInputStream();
        StringBuilder sb2 = new StringBuilder();
        if (res == 200) {
            int ch;
            while ((ch = in.read()) != -1) {
                sb2.append((char) ch);
            }
        }
        outStream.close();
        conn.disconnect();
        return sb2.toString();
    }

    public static String postWithJsonString(String api, String jsonStr) {
        Map<String, String> finalParams = new HashMap<String, String>();
        finalParams.put("client_type", "3");
        finalParams.put("uuid", Application.getInstance().UUID);
        finalParams.put("version", Application.getInstance().VERSIONCODE + "");
        finalParams.put("data", jsonStr);
        Log.i("info", "--------jsonStr-----" + jsonStr);
        String result = httpPost(api, finalParams);
        return result;
    }

    // post请求
    public static String httpPost(String urlStr, Map<String, String> params) {
        String result = null;
        HttpURLConnection connection = null;
        DataOutputStream outputStream = null;
        try {
            URL url = new URL(urlStr);
            connection = (HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(10 * 1000);
            connection.setDoOutput(true);
            connection.setRequestMethod("POST");

            connection.setInstanceFollowRedirects(true);
            connection.setUseCaches(false);
            connection.connect();
            outputStream = new DataOutputStream(
                    connection.getOutputStream());
            StringBuffer paramStr = new StringBuffer();
            for (Map.Entry<String, String> entry : params.entrySet()) {
                paramStr.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
                paramStr.append("=");
                paramStr.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
                paramStr.append("&");
            }
            paramStr.deleteCharAt(paramStr.length() - 1);

            Log.d("post json string is", paramStr.toString());
            outputStream.write(paramStr.toString().getBytes());
            if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                result = readStream(connection.getInputStream());
            } else {
                Log.e("server err",
                        "response code " + connection.getResponseCode());
            }
            outputStream.flush();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return result;

    }

    public static String readStream(InputStream is) {
        StringBuffer result = new StringBuffer();
        try {
            InputStreamReader reader = new InputStreamReader(is);
            BufferedReader bufferedReader = new BufferedReader(reader);
            String line = "";
            while ((line = bufferedReader.readLine()) != null) {
                result.append(line);
            }
        } catch (IOException e) {
            Log.e("error while read stream", e.getLocalizedMessage());
        } finally {
            try {
                is.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return result.toString();
    }

}
