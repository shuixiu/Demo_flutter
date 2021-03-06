import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/constants/Constants.dart';
import 'package:flutter_demo/events/ChangeThemeEvent.dart';
import 'package:flutter_demo/pages/DiscoveryPage.dart';
import 'package:flutter_demo/pages/HomeDemoDart.dart';
import 'package:flutter_demo/pages/MyInfoPage.dart';
import 'package:flutter_demo/pages/NewsHomeListPage.dart';
import 'package:flutter_demo/pages/TweetsListPage.dart';
import 'package:flutter_demo/util/DataUtils.dart';
import 'package:flutter_demo/util/ThemeUtils.dart';
import 'package:flutter_demo/widgets/MyDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeClientState();
}

class HomeClientState extends State<HomePage> {
  final appBarTitles = ['首页', '推荐', '现货', '我的'];
  final tabTextStyleSelected = new TextStyle(color: const Color(0xFF0083ff));
  final tabTextStyleNormal = new TextStyle(color: const Color(0xff969696));

  Color themeColor = ThemeUtils.currentColorTheme;
  int _tabIndex = 0;

  var tabImages;
  var _body;
  var pages;

  Image getTabImage(path) {
    return new Image.asset(path, width: 20.0, height: 20.0);
  }

  @override
  void initState() {
    super.initState();
    DataUtils.getColorThemeIndex().then((index) {
      print('color theme index = $index');
      if (index != null) {
        ThemeUtils.currentColorTheme = ThemeUtils.supportColors[index];
        Constants.eventBus
            .fire(new ChangeThemeEvent(ThemeUtils.supportColors[index]));
      }
    });
    Constants.eventBus.on<ChangeThemeEvent>().listen((event) {
      setState(() {
        themeColor = event.color;
      });
    });
    pages = <Widget>[
      new CustomScrollViewDemo(),
//      new NewsHomeListPage(),
      new TweetsListPage(),
      new DiscoveryPage(),
      new MyInfoPage()
    ];
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('images/ic_nav_news_normal.png'),
          getTabImage('images/ic_nav_news_actived.png')
        ],
        [
          getTabImage('images/ic_nav_tweet_normal.png'),
          getTabImage('images/ic_nav_tweet_actived.png')
        ],
        [
          getTabImage('images/ic_nav_discover_normal.png'),
          getTabImage('images/ic_nav_discover_actived.png')
        ],
        [
          getTabImage('images/ic_nav_my_normal.png'),
          getTabImage('images/ic_nav_my_pressed.png')
        ]
      ];
    }
  }

  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabTextStyleSelected;
    }
    return tabTextStyleNormal;
  }

  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  Text getTabTitle(int curIndex) {
    return new Text(appBarTitles[curIndex], style: getTabTextStyle(curIndex));
  }

  @override
  Widget build(BuildContext context) {
    _body = new IndexedStack(
      children: pages,
      index: _tabIndex,
    );
    return new MaterialApp(
//      theme: new ThemeData(primaryColor: themeColor),
      home: new Scaffold(
//          appBar: new AppBar(
//              title: new Text(appBarTitles[_tabIndex],
//                  style: new TextStyle(color: Colors.white)),
//              iconTheme: new IconThemeData(color: Colors.white)),
          body: _body,
          bottomNavigationBar: new CupertinoTabBar(
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                  icon: getTabIcon(0), title: getTabTitle(0)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(1), title: getTabTitle(1)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(2), title: getTabTitle(2)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(3), title: getTabTitle(3)),
            ],
            currentIndex: _tabIndex,
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
          ),
//          drawer: new MyDrawer()
      ),
    );
  }

}