import 'package:flutter/cupertino.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/load_more_format.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/code/observable_field.dart';

/// @Author sunlunchang
/// mvvm接口数据拓展
/// 数据列表页、分页界面数据管理基础类
///

///刷新
typedef Refresh<T> = Future<DateWrapper<List<T>>> Function();
///加载更多
typedef LoadMore<T> = Future<DateWrapper<PageModel<T>>> Function(
    LoadMoreFormat<T> loadMoreFormat);
///item的点击事件
typedef ItemClick<T> = void Function(int index, T data);
///item长按事件
typedef ItemLongClick<T> = void Function(int index, T data);

///点击响应
mixin class ListenerItemClick<T> {
  ItemClick<T>? _itemClick;
  ItemLongClick<T>? _itemLongClick;

  void setItemClick(ItemClick<T> itemClick) {
    this._itemClick = itemClick;
  }

  void setItemLongClick(ItemLongClick<T> itemLongClick) {
    this._itemLongClick = itemLongClick;
  }

  @override
  void itemClick(int index, T data) {
    _itemClick?.call(index, data);
  }

  @override
  void itemLongClick(int index, T data) {
    _itemLongClick?.call(index, data);
  }
}

///列表包装类型
class DateWrapper<T> {
  static const CODE_SUCCESS_200 = 200;

  static const CODE_SUCCESS = 0;

  static const CODE_DEF_ERROR_CODE = -1;

  int? code;
  String? msg;
  T? data;

  DateWrapper({this.code, this.msg, this.data});

  bool isSuccess() {
    return code == CODE_SUCCESS || code == CODE_SUCCESS_200;
  }

  static DateWrapper<T> createSuccess<T>(T data) {
    return DateWrapper(code: 200, data: data);
  }

  static DateWrapper<T> createFailed<T>({int? code, String? msg}) {
    return DateWrapper(
        code: code ?? CODE_DEF_ERROR_CODE, msg: msg ?? "Failed to get data");
  }
}

///基础数据列表
abstract class IListDataVmBox<T> {
  final List<T> dataList = List.empty(growable: true);

  final ObservableField<dynamic> _refreshEventOf = ObservableField();

  Listenable get refreshEvent => _refreshEventOf;

  void sendRefreshEvent(){
    _refreshEventOf.setValueAndNotify(true);
  }

  void refreshAsync();

  void itemClick(int index, T data) {}

  void itemLongClick(int index, T data) {}
}
