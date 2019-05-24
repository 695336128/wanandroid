import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid/config/url_config.dart';
import 'package:wanandroid/first_page/home_list.dart';
import 'package:wanandroid/first_page/home_page_article_item.dart';

/// User: Pluto
/// Date: 2019/5/7
/// Tile: 11:30 AM
/// Target: WanAndroid 首页
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var _scrollController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshListView();
  }
}

/// 首页文章列表
class RefreshListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RefreshListViewState();
  }
}

class _RefreshListViewState extends State<RefreshListView> {
  static const loadingTag = '正在努力加载中...';
  var showToTopBtn = false; // 是否显示'返回到顶部'按钮
  var _tipMsg = ''; // 请求异常返回信息
  var _currentPage = 0; // 当前加载的页数
  var isLoading = false; // 是否正在请求数据中
  var _hasMore = true; // 是否还有更多的数据可以加载
  var showLoadingCover = true; // 是否显示Cover页面(loading)
  List<Article> articleList = new List();
  HomePageArticleItem articleData;

  @override
  void initState() {
    super.initState();
    _getMoreData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Colors.blue,
          child: HomeListView(
            articleList:articleList,
            getMoreData:_getMoreData,
              hasMore: _hasMore,
            isLoading: isLoading
          ),
        ),
        buildCoverLayout(),
      ],
    );
  }

  /// 构建 loading cover
  Widget buildCoverLayout() {
    if (showLoadingCover) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[300],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Loading...',
                style: TextStyle(color: Colors.grey[700]),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(height: 0.0, width: 0.0);
    }
  }

  /// 下拉刷新列表
  Future<void> _handleRefresh() async {
    HomePageArticleItem newData = await _getArticleData();
    if (this.mounted) {
      setState(() {
        articleList.clear();
        articleList = newData.data.datas;
        _currentPage = 0;
        isLoading = false;
      });
    }
  }

  /// 上拉加载更多
  Future<void> _getMoreData() async {
    if (!isLoading && _hasMore) {
      // 如果上一次异步请求已经完成，并且有数据可以加载
      if (mounted) {}
      setState(() {
        isLoading = true;
      });
      HomePageArticleItem newData = await _getArticleData();
      if (newData != null) {
        _hasMore = (newData.data.curPage <= newData.data.total);
        if (this.mounted) {
          setState(() {
            showLoadingCover = false;
            articleList.addAll(newData.data.datas);
            _currentPage++;
            isLoading = false;
          });
        }
      } else {
        // 请求异常，返回的数据为null
      }
    } else if (!isLoading && !_hasMore) {
      _currentPage = 0;
    }
  }

  /// 获取首页文章列表
  Future<HomePageArticleItem> _getArticleData() async {
    HomePageArticleItem homePageArticleItem;
    try {
      HttpClient httpClient = new HttpClient();
      httpClient.idleTimeout = Duration(seconds: 20);
      var url = UrlConfig.HomeArticleUrl + _currentPage.toString() + '/json';
      print('请求地址是:$url');
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      var _data = await response.transform(utf8.decoder).join();
      print('返回的数据是:$_data');
      // Json 转 Model
      var articleMap = json.decode(_data);
      homePageArticleItem = HomePageArticleItem.fromJson(articleMap);
      return homePageArticleItem;
    } catch (e) {
      _tipMsg = '请求失败：$e';
      return null;
    } finally {
      print('请求完成');
    }
  }
}
