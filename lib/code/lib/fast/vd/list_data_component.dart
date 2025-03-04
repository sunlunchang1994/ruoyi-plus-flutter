import 'package:flutter/cupertino.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/load_more_format.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/code/observable_field.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';

import '../provider/should_set_state.dart';

/// @author sunlunchang
/// mvvm接口数据拓展
/// 数据列表页、分页界面数据管理基础类
///

///刷新
typedef Refresh<T> = Future<DataWrapper<List<T>>> Function();

///加载更多
typedef LoadMore<T> = Future<DataWrapper<PageModel<T>>> Function(
    LoadMoreFormat<T> loadMoreFormat);

///item的点击事件
typedef OnItemClick<T> = void Function(int index, T data);

///item长按事件
typedef OnItemLongClick<T> = void Function(int index, T data);

///点击响应
mixin class ListenerItemClick<T> {
  OnItemClick<T>? _itemClick;
  OnItemLongClick<T>? _itemLongClick;

  void setItemClick(OnItemClick<T> itemClick) {
    this._itemClick = itemClick;
  }

  void setItemLongClick(OnItemLongClick<T> itemLongClick) {
    this._itemLongClick = itemLongClick;
  }

  void onItemClick(int index, T data) {
    _itemClick?.call(index, data);
  }

  void onItemLongClick(int index, T data) {
    _itemLongClick?.call(index, data);
  }
}

///列表包装类型
class DataWrapper<T> {
  static const CODE_SUCCESS_200 = 200;

  static const CODE_SUCCESS = 0;

  static const CODE_DEF_ERROR_CODE = -1;

  int? code;
  String? msg;
  T? data;

  DataWrapper({this.code, this.msg, this.data});

  bool isSuccess() {
    return code == CODE_SUCCESS || code == CODE_SUCCESS_200;
  }

  static DataWrapper<T> createSuccess<T>(T data) {
    return DataWrapper(code: 200, data: data);
  }

  static DataWrapper<T> createFailed<T>({int? code, String? msg}) {
    return DataWrapper(
        code: code ?? CODE_DEF_ERROR_CODE, msg: msg ?? "Failed to get data");
  }
}

class CallRefreshParams {
  double? overOffset;
  Duration? duration;

  CallRefreshParams({this.overOffset, this.duration});
}

///基础数据列表
abstract class IListDataVmSub<T> extends FastVmSub {
  final List<T> dataList = List.empty(growable: true);

  final ShouldSetState shouldSetState = ShouldSetState();

  @protected
  final ObservableField<CallRefreshParams> _refreshEventOf = ObservableField();

  ReadObservableField<CallRefreshParams> get refreshEvent => _refreshEventOf;

  void sendRefreshEvent({CallRefreshParams? callRefreshParams}) {
    _refreshEventOf.setValueForcedNotify(callRefreshParams);
  }

  void refreshAsync();

  void itemClick(int index, T data) {}

  void itemLongClick(int index, T data) {}
}
