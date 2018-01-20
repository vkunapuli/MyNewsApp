package com.kunapulis.mynewsapp.Adapters;

/**
 * Created by venkat on 1/18/18.
 */

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.kunapulis.mynewsapp.R;
import com.kunapulis.mynewsapp.models.NewsItem;

import java.util.ArrayList;
import java.util.List;

public class NewsItemAdapter extends RecyclerView.Adapter<NewsItemAdapter.NewsItemVh> {


    private List<NewsItem> newsItems = new ArrayList<>();
    private Context context;
    private String  newsData;

    public NewsItemAdapter(Context context) {
        this.context = context;
    }
    public void loadNewItems(String newsData)
    {
        this.newsData = newsData;
        if (newsData != null)
            newsItems = NewsItem.prepareNewsItems(newsData);
    }
    public String getNewsUrl(int position)

    {
        NewsItem newsItem = newsItems.get(position);
        return newsItem.getUrl();
    }
    @Override
    public NewsItemVh onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        View view = inflater.inflate(R.layout.news_item, parent, false);
        return new NewsItemAdapter.NewsItemVh(view);
    }

    @Override
    public void onBindViewHolder(NewsItemVh holder, int position) {
        NewsItem newsItem = newsItems.get(position);
        holder.mName.setText(newsItem.getTitle());
        holder.mDescription.setText(newsItem.getDescription());
        holder.mUpdate.setText(String.valueOf(newsItem.getUpdateTime()));

    }

    @Override
    public int getItemCount() {
        return newsItems == null ? 0 : newsItems.size();
    }

    public static class NewsItemVh extends RecyclerView.ViewHolder {

        private TextView mName;
        private TextView mDescription;
        private TextView mUpdate;

        public NewsItemVh(View itemView) {
            super(itemView);

            mName = (TextView) itemView.findViewById(R.id.news_title);
            mDescription = (TextView) itemView.findViewById(R.id.news_subtitle);
            mUpdate = (TextView) itemView.findViewById(R.id.news_update);
        }
    }
}
