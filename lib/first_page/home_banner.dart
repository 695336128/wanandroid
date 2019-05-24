import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid/first_page/banner_data.dart';

/// User: Pluto
/// Date: 2019/5/21
/// Tile: 21:00 PM
/// Target: 首页Banner
class HomeBanner extends StatefulWidget {
  final List<BannerItem> bannerList;

  HomeBanner(this.bannerList, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeBannerState();
  }
}

class _HomeBannerState extends State<HomeBanner> {
  PageController _controller;
  int _currentPage;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PageView(
            controller: _controller,
            onPageChanged: _onPageChanged,
            children: _buildItems(),
          )
        ],
      ),
    );
  }

  /// pageview 切换时执行
  _onPageChanged(int value) {}

  /// 构建page item
  List<Widget> _buildItems() {
    List<Widget> items = [];
    if (widget.bannerList.isNotEmpty) {
      // 头部添加一个尾部Item,模拟循环
      items.add(_buildItem(widget.bannerList[widget.bannerList.length - 1]));
      // 正常添加
      items.addAll(widget.bannerList
          .map((bannerItem) => _buildItem(bannerItem))
          .toList(growable: false));
      // 尾部添加一个Item
      items.add(_buildItem(widget.bannerList[0]));
    }
    return items;
  }

  /// 构建item 布局
  Widget _buildItem(BannerItem bannerItem) {
    return GestureDetector(
      onTap: () {
        _onBannerTap(bannerItem);
      },
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            bannerItem.imagePath,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 5.0,
            right: 5.0,
            child: Text(
              bannerItem.title,
              style: TextStyle(
                  color: Colors.white,
                  background: Paint()..color = Colors.black38),
            ),
          )
        ],
      ),
    );
  }

  /// banner 点击事件
  _onBannerTap(BannerItem bannerItem) {
    Fluttertoast.showToast(msg: bannerItem.url);
  }
}
