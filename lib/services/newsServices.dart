import 'package:flutter/material.dart';
import 'package:flutter_app/utils/request.dart';

import 'config.dart';

class NewsServices{
  // 获取分类下面的内容列表
  static getFollowDocumentList(BuildContext context, Map params){
    String _url = Config.baseUrl + '/cons/document/getFollowDocumentList';
    return Request().post(context, _url, params);

  }
}