import 'package:flutter/cupertino.dart';

import 'list_data_component.dart';

/// @author sunlunchang
/// mvvm接口数据拓展
/// 对基础列表页数据管理进一步拓展、用户快速构建列表页数据管理

///基础列表
abstract class IBaseListDataCommonVmSub<T> extends IListDataVmSub<T> {
  DataWrapper<List<T>>? _dataWrapper;

  DataWrapper<List<T>>? get dataWrapper => _dataWrapper;

  Future<DataWrapper<List<T>>> refresh();

  @protected
  Future<DataWrapper<List<T>>> onRefresh();

  @protected
  void onFailed(DataWrapper<List<T>> dataWrapper) {}
}

///基础列表进一步拓展、实现异步刷新、更新数据
///解决部分第三方库需要等待数据响应的场景
abstract class BaseListDataVmSub<T> extends IBaseListDataCommonVmSub<T> {

  @override
  Future<DataWrapper<List<T>>> refresh() async {
    DataWrapper<List<T>> dataWrapper = await onRefresh();
    handlerDataWrapper(dataWrapper);
    return dataWrapper;
  }

  @override
  void refreshAsync() {
    onRefresh().then((dataWrapper) {
      handlerDataWrapper(dataWrapper);
    }, onError: (error) {
      //不应该让错误在这处理
      handlerDataWrapper(DataWrapper.createFailed());
    });
  }

  @protected
  void handlerDataWrapper(DataWrapper<List<T>> dataWrapper) {
    if (dataWrapper.isSuccess()) {
      onSucceed(dataWrapper.data ?? List.empty());
    } else {
      onFailed(dataWrapper);
    }
  }

  @protected
  void onSucceed(List<T> dataList) {
    shouldSetState.updateVersion();
    this.dataList.clear();
    this.dataList.addAll(dataList);
  }
}

///对基础列表进一步拓展、快速实现外部加载更多数据
class FastBaseListDataVmSub<T> extends BaseListDataVmSub<T>
    with ListenerItemSelect<T> {
  Refresh<T>? _refresh;

  void setRefresh(Refresh<T> refresh) {
    this._refresh = refresh;
  }

  @override
  Future<DataWrapper<List<T>>> onRefresh() {
    final refresh = _refresh;
    if (refresh == null) {
      throw StateError('FastBaseListDataVmSub.setRefresh must be called before refresh.');
    }
    return refresh.call();
  }

}
