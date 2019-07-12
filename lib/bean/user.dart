import 'dart:convert';

import 'package:flutter_app/utils/sharedPreference.dart';

class User{
  String mobile;
  String userName;
  dynamic userId;
  dynamic token;
  dynamic weixin;
  User(String userName, dynamic userId, dynamic token, String mobile, dynamic weixin){
    this.userName = userName;
    this.userId = userId;
    this.token = token;
    this.weixin = weixin;
  }
  static User _instance;
  static getInstance() async{
    if (_instance == null) {
      dynamic userInfo = await SharedPreference.getString('userInfo');
      userInfo = json.decode(userInfo);
      _instance = new User(userInfo['userName'], userInfo['userId'], userInfo['token'], userInfo['mobile'],  userInfo['weixin']);
    }
    return _instance;
  }
  User.cacheUser(Map userInfo){
    this.userName = userInfo['userName'];
    this.userId = userInfo['userId'];
    this.token = userInfo['token'];
    this.weixin = userInfo['weixin'];
    SharedPreference.setString('userInfo', json.encode(userInfo));
  }
  User.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        userId = json['userId'],
        token = json['token'],
        weixin = json['weixin'];

  Map<String, dynamic> toJson() =>
      {
        'userName': userName,
        'userId': userId,
        'token': token,
        'weixin': weixin
      };
}