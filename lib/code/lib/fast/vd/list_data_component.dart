import 'package:flutter/cupertino.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/load_more_format.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/code/observable_field.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';

import '../provider/should_set_state.dart';

/// @author sunlunchang
/// mvvm接口数据拓展
/// 数据列表页、分页界面数据管理基础类
///

///刷新
typedef Refresh<T> = Future<DataWrapper<List<T>>> Function();

///加载更多
typedef LoadMore<T> = Future<DataWrapper<PageModel<T>>> Function(LoadMoreFormat<T> loadMoreFormat);

///item的点击事件
typedef OnItemClick<T> = void Function(int index, T data);

///item长按事件
typedef OnItemLongClick<T> = void Function(int index, T data);

///点击响应
abstract class IListenerItemClick<T> {
  void setItemClick(OnItemClick<T> itemClick);

  void setItemLongClick(OnItemLongClick<T> itemLongClick);

  void onItemClick(int index, T data);

  void onItemLongClick(int index, T data);
}

///点击响应
mixin class ListenerItemClick<T> implements IListenerItemClick<T> {
  OnItemClick<T>? _itemClick;
  OnItemLongClick<T>? _itemLongClick;

  @override
  void setItemClick(OnItemClick<T> itemClick) {
    this._itemClick = itemClick;
  }

  @override
  void setItemLongClick(OnItemLongClick<T> itemLongClick) {
    this._itemLongClick = itemLongClick;
  }

  @override
  void onItemClick(int index, T data) {
    _itemClick?.call(index, data);
  }

  @override
  void onItemLongClick(int index, T data) {
    _itemLongClick?.call(index, data);
  }
}

///点击响应
mixin class ListenerItemSelect<T> implements IListenerItemClick<T> {
  static const int SELECT_MODEL_DISABLE = -1;
  static const int SELECT_MODEL_ENABLE = 0;
  static const int SELECT_MODEL_RUN = 1;

  OnItemClick<T>? _itemClick;
  OnItemLongClick<T>? _itemLongClick;

  int _selectModel = SELECT_MODEL_DISABLE;

  //是否开启选择模式
  bool get enableSelectModel => _selectModel != SELECT_MODEL_DISABLE;

  //启用选择模式
  set enableSelectModel(bool value) {
    int selectModelTmp = value ? SELECT_MODEL_ENABLE : SELECT_MODEL_DISABLE;
    if (selectModelTmp == _selectModel) {
      return;
    }
    _selectModel = selectModelTmp;
  }

  //是否是选择模式
  bool get selectModelIsRun => _selectModel == SELECT_MODEL_RUN;

  set selectModelIsRun(bool value) {
    if (!enableSelectModel) {
      throw Exception("enableSelectModel is false");
    }
    int selectModelTmp = value ? SELECT_MODEL_RUN : SELECT_MODEL_ENABLE;
    if (selectModelTmp == _selectModel) {
      return;
    }
    _selectModel = value ? SELECT_MODEL_RUN : SELECT_MODEL_ENABLE;
    updateShouldSetVersion();
  }

  @OvalBorder()
  void setItemClick(OnItemClick<T> itemClick) {
    this._itemClick = itemClick;
  }

  @OvalBorder()
  void setItemLongClick(OnItemLongClick<T> itemLongClick) {
    this._itemLongClick = itemLongClick;
  }

  @OvalBorder()
  void onItemClick(int index, T data) {
    if (selectModelIsRun) {
      if (data is ISelectBox) {
        onItemSelect(index, data, !data.isBoxChecked());
      } else {
        LogUtil.e("data is not ISelectBox");
      }
      return;
    }
    _itemClick?.call(index, data);
  }

  @OvalBorder()
  void onItemLongClick(int index, T data) {
    //未启用，直接返回
    if (!enableSelectModel) {
      _itemLongClick?.call(index, data);
      return;
    }
    if (selectModelIsRun) {
      return;
    }
    selectModelIsRun = true;
    if (data is ISelectBox) {
      onItemSelect(index, data, !data.isBoxChecked());
    } else {
      LogUtil.e("data is not ISelectBox");
    }
    _itemLongClick?.call(index, data);
  }

  void onItemSelect(int index, T data, bool? isSelect) {
    if (this is! IListDataVmSub) {
      return;
    }
    if (data is ISelectBox) {
      data.boxChecked = isSelect;
      updateShouldSetVersion();
    }
  }

  void onSelectAll(bool isSelect) {
    if (this is! IListDataVmSub) {
      return;
    }
    //全选/全不选
    IListDataVmSub listDataVmSub = this as IListDataVmSub;
    for (var element in listDataVmSub.dataList) {
      if (element is ISelectBox) {
        element.boxChecked = isSelect;
        updateShouldSetVersion();
      }
    }
  }

  @protected
  void updateShouldSetVersion() {
    if (this is! IListDataVmSub) {
      return;
    }
    //通知
    IListDataVmSub listDataVmSub = this as IListDataVmSub;
    listDataVmSub.shouldSetState.updateVersion();
    listDataVmSub.notifyListeners();
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
    return DataWrapper(code: code ?? CODE_DEF_ERROR_CODE, msg: msg ?? "Failed to get data");
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

  @override
  void onCleared() {
    CancelTokenAssist.cancelAllIf(this, "VmBox cleared");
    super.onCleared();
  }
}
