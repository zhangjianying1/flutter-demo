import 'package:flutter/material.dart';
class NedScrollView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _NesScrollViewState();
  }
}
class _NesScrollViewState extends State<NedScrollView> with SingleTickerProviderStateMixin {
  Animation<double> tween;
  AnimationController controller;

  /*初始化状态*/
  initState() {
    super.initState();

    /*创建动画控制类对象*/
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this);

    /*创建补间对象*/
    tween = new Tween(begin: 10.0, end: 20.0)
        .animate(controller)    //返回Animation对象
      ..addListener(() {        //添加监听
        setState(() {
          print(tween.value);   //打印补间插值
        });
      });
    controller.forward();       //执行动画
  }


  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              leading: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 34,),
              centerTitle: true,
              title: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('wodo'),
              ),
            ), preferredSize: Size.fromHeight(46)
        ),
        body:
        new GestureDetector(
        onTap: () {
          startAnimtaion();         //点击文本 重新执行动画
        },

        child: new Center(
            child: Container(
                width: double.infinity,
                height: controller.value * 120,
                color: Colors.deepOrange,
                child: new Text(
                  "Flutter Animation(一)",
                  style: TextStyle(fontSize: 20 * controller.value),   //更改文本字体大小
                )
            )
        )
        )
      );
  }

  startAnimtaion() {
    setState(() {
      controller.forward(from: 1.0);
    });
  }

  dispose() {

    //销毁控制器对象
    controller.dispose();
    super.dispose();
  }
}

