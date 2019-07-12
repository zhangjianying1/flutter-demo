import 'package:flutter/material.dart';

class Vertical{
  Vertical._();
  static String verticalPhone(String phone){
    String msg = '';
    if (phone.isEmpty) {
      msg = '手机号不能为空';
    } else if (!RegExp('^1[0-9]{10}\$').hasMatch(phone)) {
      msg = '手机号不正确';
    }
    return msg;
  }
}