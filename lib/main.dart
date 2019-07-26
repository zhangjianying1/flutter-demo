import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/services/colors.dart';
import 'package:flutter_app/view/article.dart';
import 'package:flutter_app/widgets/toast.dart';
import 'nedesScrollview.dart';
import 'splash.dart';
import 'login.dart';
import 'package:flutter_app/view/news.dart';
import 'view/home.dart';
import 'view/my.dart';

void main(){
//
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.landscapeRight,
//      DeviceOrientation.landscapeRight,
//    ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.transparent,
  ));
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(NamedRouter.initApp());
}
class NamedRouter{
  static Map<String, WidgetBuilder> routes;
  static Widget initApp() {
    return  new MaterialApp(
      initialRoute: '/',
      routes: NamedRouter.initRoutes(),
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primaryColor: MyColors.primary,
          accentColor: Colors.orangeAccent
      ),
    );
  }

  static initRoutes() {
    return {
      '/': (context) => new Splash(),
      '/main': (context) => new MainPage(),
      '/login': (context) => new LoginPage()
    };
  }
}
class MainPage extends StatefulWidget {
  MainPage();
  @override
  _MainPageState createState() => new _MainPageState();
}
class _MainPageState extends State<MainPage>  {
  bool showTop = false;
  static int _tabIndex = 0;
  static final List<Widget> _children = <Widget>[
    HomePage(), NewsPage(), NedScrollView(), MyPage()
  ];
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    _connectivitySubscription = new Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      print(result);
      String msg;
      switch (result) {
        case  ConnectivityResult.wifi:
          msg = 'wifi';
          break;
        case  ConnectivityResult.none:
          msg = '网络连接已断开';
          break;
        default:
          msg = '';
      }
      Toast.show(context, msg);
    });
  }
  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: IndexedStack(
          alignment: Alignment.center,
          index: _tabIndex,
          children: _children
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabHandler,
          currentIndex: _tabIndex,
          items: _bottomNavigationBar(_tabIndex),
        ),
    );
  }
  _bottomNavigationBar(int index){
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.info, color: _tabIndex == 0 ? MyColors.primary : MyColors.gray40),
          title: Text('首页', style: TextStyle(color: _tabIndex == 0 ? MyColors.primary : MyColors.gray40),)
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.info, color: _tabIndex == 1 ? MyColors.primary : MyColors.gray40),
          title: Text('悦社', style: TextStyle(color: _tabIndex == 1 ? MyColors.primary : MyColors.gray40),)
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.info, color: _tabIndex == 2 ? MyColors.primary : MyColors.gray40),
          title: Text('服务', style: TextStyle(color: _tabIndex == 2 ? MyColors.primary : MyColors.gray40),)
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.info, color: _tabIndex == 3 ? MyColors.primary : MyColors.gray40),
          title: Text('我的', style: TextStyle(color: _tabIndex == 3 ? MyColors.primary : MyColors.gray40),)
      )
    ];
  }
  void onTabHandler(int value) {
    setState(() {
      _tabIndex = value;
    });
  }
}
