import '../../../base/api/app_page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';

///@Author sunlunchang
///分页转换类
///将对接的后端分页数据结构转换成本框架所需要的分页数据结构，有利于快速开发
///一般在网络访问的数据转换时使用
class PageTransformUtils {
  static PageModel<T> iAppPm2Pm<T>(
      IntensifyPageModel<T> appPageModel) {
    return appPm2Pm(appPageModel.getPageModel(),
        records: appPageModel.getListNoNull());
  }

  static PageModel<T> appPm2Pm<T>(AppPageModel appPageModel,
      {List<T>? records}) {
    return PageModel<T>(
        current: appPageModel.current,
        pages: appPageModel.pages,
        isLastPage: appPageModel.isLastPage,
        records: records,
        searchCount: appPageModel.searchCount,
        size: appPageModel.size,
        total: appPageModel.total);
  }

  //page转list
  static List<T> page2List<T>(PageModel<T>? pageModel) {
    if (pageModel == null) {
      return List.empty(growable: true);
    }
    return pageModel.getListNoNull();
  }
}
