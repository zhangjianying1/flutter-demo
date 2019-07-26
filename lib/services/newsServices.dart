import 'package:flutter/material.dart';
import 'package:flutter_app/utils/request.dart';

import 'config.dart';

class NewsServices{
  NewsServices._internal() {}
  static NewsServices _instance;
  BuildContext context;
  static NewsServices of(BuildContext context){
    context = context;
    if (_instance == null) {
      _instance = new NewsServices._internal();
    }
    return _instance;
  }
  // 获取分类下面的内容列表
  getFollowDocumentList(Map params){
    String _url = Config.baseUrl + '/cons/document/getFollowDocumentList';
    return Request().post(context, _url, params);

  }
  getDocumentContent(String documentId){
    String _url = Config.baseUrl + '/cons/document/documentContent/' + documentId;
    return Request().get(context, _url);
  }
}