import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid/first_page/home_page_article_item.dart';

class HomeListView extends StatefulWidget{

  final List<Article> articleList;
  final ValueChanged getMoreData;
  final bool hasMore;
  final bool isLoading; // 是否正在请求数据中

  HomeListView({this.articleList,@required this.getMoreData,this.hasMore,this.isLoading,Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeListViewState();
  }
}

class _HomeListViewState extends State<HomeListView>{

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // 如果下拉的当前位置到scroll的最下面
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.getMoreData;
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

    return ListView.builder(
      itemCount: widget.articleList.length + 1,
      controller: _scrollController,
      itemBuilder: buildItemBuilder,
    );
  }


  /// 构建列表Item
  Widget buildItemBuilder(BuildContext context, int index) {
    if (index == 0 && index != widget.articleList.length) {
      //　显示headview
      return Center(
          key: Key('ListHeader'),
          child: Container(
            color: Colors.blue[100],
            width: double.infinity,
            height: 200.0,
            child: Center(
              child: Text('此处应该有个Banner'),
            ),
          ));
    }
    if (index == widget.articleList.length) {
      // 显示加载更多
      return _buildProgressIndicator();
    }
    return buildListTile(index);
  }

  /// 构建列表Item内容
  Widget buildListTile(int index) {
    var _isFavorite = widget.articleList[index].collect;
    var _title = widget.articleList[index].title;
    var _author = widget.articleList[index].author;
    var _niceDate = widget.articleList[index].niceDate;

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
                )),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 15.0,bottom: 5.0),
              child:  Stack(
                alignment: AlignmentDirectional.centerStart,
                textDirection: TextDirection.ltr,
                fit: StackFit.loose,
                children: <Widget>[
                  Positioned(
                    child: Text('by:$_author'),
                  ),
                  Positioned(
                    right: 50.0,
                    child: Text(_niceDate),
                  ),
                  Positioned(
                      right: 0.0,
                      child: IconButton(
                          icon: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                          color: Colors.redAccent,
                          onPressed: (){
                            Fluttertoast.showToast(msg: 'favorite');
                          })
                  ),
                ],
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios)));
  }

  /// 底部加载更多
  Widget _buildProgressIndicator() {
    if (widget.hasMore) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Opacity(
                opacity: widget.isLoading ? 1.0 : 0.0,
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

}