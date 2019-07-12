import 'dart:async';

import 'package:flutter/material.dart';
class Splash extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _SplashState();
  }

}
class _SplashState extends State<Splash>{
  startTimer() async{
    var _durction = Duration(milliseconds: 1500);
    return new Timer(_durction, navigationPage);
  }
  navigationPage(){
    print("end");
    Navigator.pushReplacementNamed(context, '/main');
//    Navigator.of(context).pushReplacementNamed('/main');
  }
  @override
  void initState() {
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Image.asset('images/splash.png', fit: BoxFit.fitWidth),
      ),
    );
  }

}