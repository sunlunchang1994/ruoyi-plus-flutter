import 'package:flutter_scaffold_single/code/base/api/app_page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';

class PageTransformUtils {
  static PageModel<T> iAppPageModel2PageModel<T>(
      IntensifyPageModel<T> appPageModel) {
    return appPageModel2PageModel(appPageModel.getPageModel(),
        records: appPageModel.getListNoNull());
  }

  static PageModel<T> appPageModel2PageModel<T>(AppPageModel appPageModel,
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
}
