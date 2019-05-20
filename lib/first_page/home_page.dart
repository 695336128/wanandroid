import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid/config/url_config.dart';
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
  ScrollController _scrollController;
  List<Article> articleList = new List();
  HomePageArticleItem articleData;

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // 如果下拉的当前位置到scroll的最下面
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
      if (_scrollController.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_scrollController.offset >= 1000 && !showToTopBtn) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // 避免内存泄露
    _scrollController.dispose();
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
          child: ListView.builder(
            itemCount: articleList.length + 1,
            controller: _scrollController,
            itemBuilder: buildItemBuilder,
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

  /// 构建列表Item
  Widget buildItemBuilder(BuildContext context, int index) {
    if (index == 0 && index != articleList.length) {
      //　显示headview
      return Center(
          key: Key('ListHeader'),
          child: Container(
            color: Colors.blue[100],
            width: double.infinity,
            height: 120.0,
            child: Center(
              child: Text('此处应该有个Banner'),
            ),
          ));
    }
    if (index == articleList.length) {
      // 显示加载更多
      return _buildProgressIndicator();
    }
    return buildListTile(index);
  }

  /// 构建列表Item内容
  Widget buildListTile(int index) {
    var _isFavorite = articleList[index].collect;
    var _title = articleList[index].title;
    var _author = articleList[index].author;
    var _niceDate = articleList[index].niceDate;

    return Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: ListTile(
          onTap: () {
            Fluttertoast.showToast(
                msg: _title, backgroundColor: Colors.black54);
          },
          leading: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                Fluttertoast.showToast(msg: 'Favorite');
              }),
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: SizedBox(
              height: 40.0,
              child: Text(
                _title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            )
          ),
          subtitle: Stack(
            alignment: AlignmentDirectional.centerStart,
            textDirection: TextDirection.ltr,
            fit: StackFit.loose,
            children: <Widget>[
              Padding(
                child: Text('by:$_author'),
                padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
              ),
              Positioned(
                right: 0.0,
                child: Text(_niceDate),
              )
            ],
          ),
        ));
  }

  /// 底部加载更多
  Widget _buildProgressIndicator() {
    if (_hasMore) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Opacity(
                opacity: isLoading ? 1.0 : 0.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                '拼命加载中...',
                style: TextStyle(color: Colors.grey[700], fontSize: 14.0),
              )
            ],
          ),
        ),
      );
    } else {
      // 没有更多数据了
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text('没有更多数据了'),
        ),
      );
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
