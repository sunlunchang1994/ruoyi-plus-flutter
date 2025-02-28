import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';

///@Author sunlunchang
///分页转换类
///将对接的后端分页数据结构转换成本框架所需要的分页数据结构，有利于快速开发
///一般在网络访问的数据转换时使用
class PageTransformUtils {

  //page转list
  static List<T> page2List<T>(PageModel<T>? pageModel) {
    if (pageModel == null) {
      return List.empty(growable: true);
    }
    return pageModel.getListNoNull();
  }
}
