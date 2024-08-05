import 'list_data_component.dart';

///基础数据列表
abstract class IBaseListDataCommonVmBox<T> extends IListDataVmBox<T> {
  DateWrapper<List<T>>? _dateWrapper;

  DateWrapper<List<T>>? get dateWrapper => _dateWrapper;

  Future<DateWrapper<List<T>>> refresh();

  void onFailed(DateWrapper<List<T>> dateWrapper) {}
}

///基础数据列表
abstract class BaseListDataVmBox<T> extends IBaseListDataCommonVmBox<T> {
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
    dataList.clear();
    dataList.addAll(dataList);
  }
}

class FastBaseListDataVmBox<T> extends BaseListDataVmBox<T>
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
