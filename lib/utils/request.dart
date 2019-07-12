import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bean/devices.dart';
import 'package:flutter_app/widgets/toast.dart';
import 'package:package_info/package_info.dart';
class Request{
  static final Request _instance = new Request._internal();
  final BuildContext context = null;
  factory Request(){
    return _instance;
  }
  Request._internal();
  Dio dio = new Dio();
  static Map<String, String>_header = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json'
  };
  dynamic _http(String methods, BuildContext context, String url, [Map<String, dynamic> data, Map<String, dynamic> header]) async{
    dynamic body = {};
    Response response;
    // 判断网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none){
      Toast.show(context, '请打开连接网络');
    } else {
      _setHeader(header);
      Options options = new Options(headers: _header, contentType: ContentType.json, connectTimeout: 2000);
      try {
        if (methods == 'get') {
          response = await dio.get(url, queryParameters: data, options: options);
        } else {
          response = await dio.post(url, data: data, options: options);
        }
        if (response.statusCode == 200) {
          if ( response.data['code'] == '000000') {
            body = response.data['data'];
          } else {
            body = response.data;
          }
        } else {
          Toast.show(context, '网络错误');
        }
      } on DioError catch (error){
        String msg = '网络连接失败';
        if (error.response != null) {
          body = error.response;
        }
        // 超时
        if (error.type == DioErrorType.CONNECT_TIMEOUT) {
          msg = '网络超时';
        }
        Toast.show(context, msg??'网络连接失败');
      }
    }
    return body??{};
  }
  dynamic get(BuildContext context, String url, [Map<String, dynamic> data, Map<String, dynamic> options]) async{
    dynamic body = _http('get', context, url, data, options);
    return body;
  }
  dynamic post(BuildContext context, String url, [Map<String, dynamic> data, Map<String, dynamic> options]) async{
    dynamic body = _http('post', context, url, data, options);
    return body;
  }
  _setHeader(Map header) async{
    Devices devices = await Devices.getInfo();
    _header[ 'deviceid'] = devices.device;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _header[ 'appid'] = packageInfo.appName;
    _header[ 'appversion'] = packageInfo.version;
    if (header != null) {
      _header.addEntries(header.entries);
    }
  }
}