package com.kunapulis.mynewsapp.models;

import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * Created by venkat on 1/18/18.
 */

public class NewsItem {

    private String title;
    private String description;
    private String url;
    private String publishedAt;
    private String urlToImage;
    private String updateTime;

   /* public NewsItem(String title, String description, String update) {
        this.title = title;
        this.updateTime = update;
        this.description = description;
    }*/

    public String getTitle() {
        return title;
    }
    public String getUrl() {
        return url;
    }
    public String getDescription() {
        return description;
    }


    public String getUpdateTime() {
        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
        try {
            Date date = dateFormat.parse(updateTime);
            Date currDate = new Date();
            long diff =  currDate.getTime() - date.getTime();
            return diff/60000 + " min";
        } catch (Exception e)
        {
            return "0 min";
        }
    }

    public static List<NewsItem> prepareNewsItems(String json) {
        try {
            JSONObject myJson = new JSONObject(json);
            JSONArray list = myJson.getJSONArray("articles");
            Gson gson = new Gson();
            NewsItem[] newsItems = gson.fromJson(list.toString(), NewsItem[].class);
            return Arrays.asList(newsItems);
        }catch (Exception e)
        {
            return null;
        }
// use myJson as needed, for example
    }

}