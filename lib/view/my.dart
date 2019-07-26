import 'package:flutter/material.dart';
import 'package:flutter_app/services/colors.dart';
import 'package:flutter_app/services/MySize.dart';
class MyPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin{
  static const String routeName = '/material/tabs';
  static double _opacityNum = 0.0;
  Animation<double> animation;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 120.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
        children: <Widget>[
          Scrollbar(
            child: NotificationListener(//实现对列表得监听  --  接收 onNotification 得回调，每次滚动得时候都会回调这个函数
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                    print(scrollNotification.metrics.pixels);
                    _opacityNum = scrollNotification.metrics.pixels/120.toDouble();
                    _opacityNum = _opacityNum > 1.0 ? 1.0 : _opacityNum;
                    setState(() {
                      print(_opacityNum);
                    });
                  }
                },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _header(),
                  _entryList(),
                  _navList(context),
                ],
              ),
            )
            )
            ),
            Opacity(
              opacity: _opacityNum,
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                height: 46 + MediaQuery.of(context).padding.top,
                color: MyColors.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('我的', style: TextStyle(fontSize: MySize.s_18, color: MyColors.white),),
                    )
                  )
                ],),
              )
            )
          ],
      )
    );
  }
  _entryList(){
    List<Map> entryList = [{'name': '社保订单', 'icon': Icons.add_box}, {'name': '医疗订单', 'icon': Icons.message}, {'name': '我的收藏', 'icon': Icons.map}];
    return Container(
      padding: EdgeInsets.symmetric(vertical: MySize.s_20, horizontal: MySize.s_40),
      color: MyColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: entryList.map((res){
          return Column(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: MyColors.primary,
                    borderRadius: BorderRadius.circular(40.0)
                ),
                child: Icon(res['icon'], color: MyColors.white,),
              ),
              Text(res['name'], style: TextStyle(color: MyColors.gray, fontSize: MySize.s_14, height: 2),)
            ],
          );
        }).toList()
      ),
    );
  }

  _navList(BuildContext context) {
    List<Map> data = [{'name': '我的社保卡', 'icon': Icons.add}, {'name': '我的社保卡', 'icon': Icons.add}, {'name': '我的社保卡', 'icon': Icons.add},{'name': '我的社保卡', 'icon': Icons.add},{'name': '我的社保卡', 'icon': Icons.add},{'name': '我的社保卡', 'icon': Icons.add},{'name': '我的社保卡', 'icon': Icons.add},{'name': '我的社保卡', 'icon': Icons.add},{'name': '我的社保卡', 'icon': Icons.add}];
    List<Widget> widgetList =  data.map((res) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
        child: Row(
          children: <Widget>[
            Icon(res['icon']),
            Expanded(
              child: Text(res['name']),
            ),
            Icon(Icons.keyboard_arrow_right),
          ],
        ),
      );
    }).toList();
    print(widgetList);
    return Column(
      children: widgetList,
    );
  }
  _header() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: MySize.s_14),
        height: 140,
        decoration:  BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF02a7a9), Color(0xFF2bb6a1), ],
                begin: Alignment.topCenter, end: Alignment.bottomCenter)
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  margin: EdgeInsets.only(right: MySize.s_14, left: MySize.s_8),
                  child: ClipOval(child: Image.asset('images/4.jpg', fit: BoxFit.cover,)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('金克拉尽', style: TextStyle(fontSize: MySize.s_18, height: 1.2, color: MyColors.white),),
                    Text('马上登录', style: TextStyle(fontSize: MySize.s_14, height: 1.2, color: MyColors.white),),
                  ],
                )
              ],
            ),
            Icon(Icons.edit, color: MyColors.gray80, size: MySize.s_18,),
          ],
        ),
    );
  }
}