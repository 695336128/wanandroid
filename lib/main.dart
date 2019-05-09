import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanandroid/MessagePage.dart';
import 'package:wanandroid/NavigationPage.dart';
import 'package:wanandroid/PersonPage.dart';
import 'package:wanandroid/first_page/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WanAndroid',
      theme: ThemeData(primarySwatch: Colors.blue, primaryColor: Colors.blue),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  PageController _pageController;

  static List tabData = [
    {'text': '首页', 'icon': Icon(Icons.home)},
    {'text': '导航', 'icon': Icon(Icons.navigation)},
    {'text': '公众号', 'icon': Icon(Icons.message)},
    {'text': '我的', 'icon': Icon(Icons.person)},
  ];

  static List pages = [
    HomePage(),
    NavigationPage(),
    MessagePage(),
    PersonPage()
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: _buildAppBar(),
        drawer: MyDrawer(),
        bottomNavigationBar: _buildBottomNavigationBar(),
        floatingActionButton: _buildFloatingActionButton(),
        body: PageView.builder(
          onPageChanged: _pageChange,
          controller: _pageController,
          itemCount: pages.length,
          itemBuilder: (BuildContext context, int index) {
            return pages[index];
          },
        ));
  }

  /// 创建AppBar
  _buildAppBar() {
    return AppBar(
      title: Text(tabData[_selectedIndex]['text']),
      actions: <Widget>[
        // 导航栏右侧菜单
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () => {_showToast("分享WanAndroid")},
        )
      ],
    );
  }

  /// 创建底部导航栏
  _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: tabData
          .map((e) =>
              BottomNavigationBarItem(title: Text(e['text']), icon: e['icon']))
          .toList(),
      currentIndex: _selectedIndex,
      fixedColor: Colors.blue,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }

  /// 导航栏点击事件
  void _onItemTapped(int value) {
    // 用pageview的pageController的animateToPage方法可以跳转
    _pageController.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  /// 构建导航FAB
  _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      tooltip: 'FAB',
      onPressed: () => {_showToast("FAB is clicked")},
    );
  }

  /// pageview 的改变
  void _pageChange(int value) {
    setState(() {
      if (_selectedIndex != value) {
        _selectedIndex = value;
      }
    });
  }
}

/// 抽屉
class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ClipOval(
                        child: Image(
                          width: 80.0,
                          height: 80.0,
                          image: AssetImage('assets/images/userimg.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "username",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Add account'),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Manager account'),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

/// 显示Toast
_showToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0);
}
