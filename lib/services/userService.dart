import 'package:flutter/material.dart';
import 'config.dart';
import '../utils/request.dart';
class UserService{
  static Future sendCode(BuildContext context, params) async{
    String url = Config.baseUrl + '/u/sendMsg/sendOtpMessage';
    return new Request().post(context, url, params);
  }
  static Future login(BuildContext context, params) async{
    String url = Config.baseUrl + '/u/user/authCodeLogin';
    return new Request().post(context,url, params);
  }
}