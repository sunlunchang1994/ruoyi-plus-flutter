import 'list_data_component.dart';

/// @Author sunlunchang
/// mvvm接口数据拓展
/// 对基础列表页数据管理进一步拓展、用户快速构建列表页数据管理

///基础列表
abstract class IBaseListDataCommonVmSub<T> extends IListDataVmSub<T> {
  DateWrapper<List<T>>? _dateWrapper;

  DateWrapper<List<T>>? get dateWrapper => _dateWrapper;

  Future<DateWrapper<List<T>>> refresh();

  void onFailed(DateWrapper<List<T>> dateWrapper) {}
}

///基础列表进一步拓展、实现异步刷新、更新数据
abstract class BaseListDataVmSub<T> extends IBaseListDataCommonVmSub<T> {
  @override
  void refreshAsync() {
    refresh().then((dateWrapper) {
      handlerDateWrapper(dateWrapper);
    }, onError: (error) {
      //不应该让错误在这处理
      handlerDateWrapper(DateWrapper.createFailed());
    });
  }

  void handlerDateWrapper(DateWrapper<List<T>> dataWrapper) {
    if (dataWrapper.isSuccess()) {
      onSucceed(dataWrapper.data ?? List.empty());
    } else {
      onFailed(dataWrapper);
    }
  }

  void onSucceed(List<T> dataList) {
    this.dataList.clear();
    this.dataList.addAll(dataList);
  }
}

///对基础列表进一步拓展、快速实现同步刷新、解决部分第三方库需要等待数据响应的场景
class FastBaseListDataVmSub<T> extends BaseListDataVmSub<T>
    with ListenerItemClick<T> {
  Refresh<T>? _refresh;

  void setRefresh(Refresh<T> refresh) {
    this._refresh = refresh;
  }

  @override
  Future<DateWrapper<List<T>>> refresh() async {
    DateWrapper<List<T>> dateWrapper = await _refresh!.call();
    handlerDateWrapper(dateWrapper);
    return dateWrapper;
  }
}
