import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';

import 'list_data_component.dart';

/// @author sunlunchang
/// mvvm接口数据拓展
/// 对基础列表页数据管理进一步拓展、用户快速构建列表页数据管理

///基础列表
abstract class IBaseListDataCommonVmSub<T> extends IListDataVmSub<T> {
  DataWrapper<List<T>>? _dataWrapper;

  DataWrapper<List<T>>? get dataWrapper => _dataWrapper;

  Future<DataWrapper<List<T>>> refresh();

  void onFailed(DataWrapper<List<T>> dataWrapper) {}
}

///基础列表进一步拓展、实现异步刷新、更新数据
abstract class BaseListDataVmSub<T> extends IBaseListDataCommonVmSub<T> {
  @override
  void refreshAsync() {
    refresh().then((dataWrapper) {
      handlerDataWrapper(dataWrapper);
    }, onError: (error) {
      //不应该让错误在这处理
      handlerDataWrapper(DataWrapper.createFailed());
    });
  }

  void handlerDataWrapper(DataWrapper<List<T>> dataWrapper) {
    if (dataWrapper.isSuccess()) {
      onSucceed(dataWrapper.data ?? List.empty());
    } else {
      onFailed(dataWrapper);
    }
  }

  void onSucceed(List<T> dataList) {
    shouldSetState.updateVersion();
    this.dataList.clear();
    this.dataList.addAll(dataList);
  }
}

///对基础列表进一步拓展、快速实现同步刷新、解决部分第三方库需要等待数据响应的场景
class FastBaseListDataVmSub<T> extends BaseListDataVmSub<T>
    with ListenerItemSelect<T> {
  Refresh<T>? _refresh;

  void setRefresh(Refresh<T> refresh) {
    this._refresh = refresh;
  }

  @override
  Future<DataWrapper<List<T>>> refresh() async {
    DataWrapper<List<T>> dataWrapper = await _refresh!.call();
    handlerDataWrapper(dataWrapper);
    return dataWrapper;
  }

}
