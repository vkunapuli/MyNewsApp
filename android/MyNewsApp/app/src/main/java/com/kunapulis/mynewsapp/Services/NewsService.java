package com.kunapulis.mynewsapp.Services;

import android.os.AsyncTask;
import android.util.Log;

import com.kunapulis.mynewsapp.Utils.StreamUtil;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import static android.content.ContentValues.TAG;

/**
 * Created by venkat on 1/19/18.
 */

public class NewsService extends AsyncTask<Void, Void, String> {
    //private Context context;
    private String news_url;
    private Exception mException;
    private AsyncListener listener;
    public NewsService(AsyncListener listener, String url) {
        this.listener = listener;
        this.news_url = url;
    }
    @Override
    protected String doInBackground(Void... voids) {

        URL url;
        HttpURLConnection conn = null;
        String server_response = null;
        InputStream is = null;
        try {
            url = new URL(news_url); //10.0.2.2
            Log.d("url", news_url);
            conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);
            int responseCode = conn.getResponseCode();
            if(responseCode == HttpURLConnection.HTTP_OK){
                is = conn.getInputStream();
                server_response = StreamUtil.readInputStream(is);
                return server_response;
            }
            else
            {
                //Log.d(TAG, "rejected" + responseCode);
                return null;
            }

        } catch (MalformedURLException e) {
            mException = e;
            Log.d(TAG,"MalformedURLException");
            e.printStackTrace();
        } catch (IOException e) {
            mException = e;
            Log.d(TAG,"Exception");
            e.printStackTrace();
        }
        return null;
    }
    @Override
    protected void onPostExecute(String json) {
        if (mException != null) {
            mException.printStackTrace();
            return;
        }
        if(json != null)
        {
            listener.postAsyncResponse(json);
        }

    }
}
