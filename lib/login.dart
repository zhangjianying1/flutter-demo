import 'dart:async';
import 'package:flutter_app/bean/user.dart';
import 'package:flutter_app/utils/vertical.dart';
import 'package:flutter_app/widgets/Toast.dart';
import 'package:flutter_app/widgets/netLoadingDialog.dart';

import './services/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/userService.dart';
class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}
class _LoginPageState extends State<LoginPage>{
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String sendStatus = 'start';
  int countTime = 60;
  Timer _timer;
  FocusNode oPhone = new FocusNode();
  FocusNode oCode = new FocusNode();
  String userName = '';
  bool sending = false;
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.all(30.0),
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15.0),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     Text('您好~', style: TextStyle(height: 1.4, color: MyColors.gray, fontSize: 20.0, fontWeight: FontWeight.bold),),
                     Text('欢迎来到查悦社保', style: TextStyle(height: 1.4, color: MyColors.gray, fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              _setInputs(),
              Padding(
                padding: EdgeInsets.only(top:  30.0),
                child: RaisedButton(
                  onPressed: _subLogin,
                  child: new Text('登录', style: TextStyle(color: MyColors.white)),
                  color: MyColors.primary,
                  shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                ),
              ),
            ],
          ),
          Transform(
            transform: Matrix4.translationValues(-20.0, 0, 0),
            child: FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: new Icon(Icons.close, color: MyColors.gray, size: 16.0,),
            ),
          )
        ],
      )
    );
  }

  /**
   * 发送短信验证码
   */
  _sendCode(BuildContext context){
    String phone = phoneController.text;
    String msg = Vertical.verticalPhone(phone);
    print(msg);
    if (msg.isNotEmpty || sending) {
      if (msg.isNotEmpty)
      Toast.show(context, msg);
      return;
    }
    sending = true;
    setState(() {
      sendStatus = 'sending';
    });
    UserService.sendCode(context, {'moible': phone}).then((data){
      sendStatus = 'sended';
      FocusScope.of(context).requestFocus(oCode);
      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer){
        if (countTime == 0) {
          _cancelTimer();
          countTime = 60;
          return;
        }
        countTime -= 1;
        setState(() {});
        if (countTime == 0) {
          sendStatus = 'start';
          setState(() {});
        }
      });
    }).whenComplete((){
      sending = false;
    });
  }
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }
  _subLogin(){
    var phone = phoneController.text;
    String code = codeController.text.trim();
    String msg = Vertical.verticalPhone(phone);
    print(sending);
    if (msg.isEmpty && code.isEmpty) {
      msg = '短信验证码不能为空';
    }
    if (msg.isNotEmpty || sending) {
      if (msg.isNotEmpty)
      Toast.show(context, msg);
      return;
    }
    sending = true;
    showDialog(
        context: context,
        builder: (context) {
          return new NetLoadingDialog(
            requestCallBack: _reqestCallback(phone, code),
            outsideDismiss: false,
          );
        }
    );
  }
  _reqestCallback(String phone, String code) async{
    return UserService.login(context, {'mobile': phone, 'rcode': code}).then((res){
      print(res);
      if (res['userName'] != null) {
        setState(() {
          userName = res['userName'];
        });
        User.cacheUser(res);
      } else {
        if (res['message'] != null)
        Toast.show(context, res['message']);
      }
      sending = false;
    });
  }
  Widget _setInputs(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child:  Stack(
            children: <Widget>[
              TextField(
                focusNode: oPhone,
                controller: phoneController,
                keyboardType: TextInputType.number,
                maxLengthEnforced: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 6.0, top: 12.0),
                    hintText: '请输入手机号码'
                ),
              ),
              Positioned(
                height: 30.0,
                right: 0,
                top: 10,
                child:  FlatButton(
                  onPressed: (){
                    sendStatus == 'start' ? _sendCode(context) : null;
                  },
                  highlightColor: MyColors.transparent,
                  child: new Text(sendStatus == 'start' ? '获取验证码' :  sendStatus == 'sending' ? '发送中...' : '$countTime',
                      style: TextStyle(color: sendStatus != 'sended' ? MyColors.primary : MyColors.gray, fontSize: 14.0)),
                ),
              )
            ],
          ),
        ),
        Divider(color: MyColors.gray40,),
        TextField(
          focusNode: oCode,
          controller: codeController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.send,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(bottom: 6.0, top: 12.0),
              hintText: '请输入短信验证码',
          ),
        ),
        Divider(color: MyColors.gray40,),
        Text(userName)
      ],
    );
  }
}