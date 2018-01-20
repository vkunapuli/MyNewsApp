package com.kunapulis.mynewsapp.Fragments;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.kunapulis.mynewsapp.Activities.NewsDetails;
import com.kunapulis.mynewsapp.Adapters.NewsItemAdapter;
import com.kunapulis.mynewsapp.R;
import com.kunapulis.mynewsapp.Services.AsyncListener;
import com.kunapulis.mynewsapp.Services.NewsService;
import com.kunapulis.mynewsapp.Services.RecyclerItemClickListener;

/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link NewsFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link NewsFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class NewsFragment extends Fragment implements AsyncListener {
    private String category;
    private String newsData;
    NewsItemAdapter adapter;

    public NewsFragment() {
    }
    public void postAsyncResponse(String data)
    {
        this.newsData = data;
        if(adapter != null) {
            adapter.loadNewItems(newsData);
            adapter.notifyDataSetChanged();
        }
    }
    @SuppressLint("ValidFragment")
    public NewsFragment(String category) {

        this.category = category;
        String news_url = "https://newsapi.org/v2/top-headlines?country=us&category=" + category +
                "&apiKey=9f1515000c9d4d24919d25c44a3b7dc8";
        new NewsService(this, news_url).execute();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.news_fragment, container, false);

        final FrameLayout frameLayout = (FrameLayout) view.findViewById(R.id.dummyfrag_bg);

        RecyclerView recyclerView = (RecyclerView) view.findViewById(R.id.dummyfrag_scrollableview);

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity().getBaseContext());
        recyclerView.setLayoutManager(linearLayoutManager);
        recyclerView.setHasFixedSize(true);
        adapter = new NewsItemAdapter(getContext());
        adapter.loadNewItems(newsData);
        recyclerView.addItemDecoration( new VerticalSpaceItemDecoration(30));
        recyclerView.setAdapter(adapter);
        recyclerView.addOnItemTouchListener(
                new RecyclerItemClickListener(getContext(), recyclerView ,new RecyclerItemClickListener.OnItemClickListener() {
                    @Override public void onItemClick(View view, int position) {
                        // do whatever
                        Intent intent = new Intent(getContext(), NewsDetails.class);

                        intent.putExtra("URL", adapter.getNewsUrl(position));
                        startActivity(intent);
                    }

                    @Override public void onLongItemClick(View view, int position) {
                        // do whatever
                    }
                })
        );

        return view;
    }
}
class VerticalSpaceItemDecoration extends RecyclerView.ItemDecoration {

    private final int verticalSpaceHeight;

    public VerticalSpaceItemDecoration(int verticalSpaceHeight) {
        this.verticalSpaceHeight = verticalSpaceHeight;
    }

    @Override
    public void getItemOffsets(Rect outRect, View view, RecyclerView parent,
                               RecyclerView.State state) {
        outRect.bottom = verticalSpaceHeight;
    }
}

