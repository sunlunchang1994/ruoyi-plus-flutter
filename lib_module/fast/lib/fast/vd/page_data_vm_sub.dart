import 'package:flutter/cupertino.dart';

import 'list_data_component.dart';
import 'package:boxes_flutter/flutter/slc/adapter/load_more_format.dart';
import 'package:boxes_flutter/flutter/slc/adapter/page_model.dart';

/// @author sunlunchang
/// mvvm接口数据拓展
/// 对基础列表分页数据管理进一步拓展、用户快速构建列表分页数据管理

///基础分页列表
abstract class IBasePageDataCommonVmSub<T> extends IListDataVmSub<T> {
  DataWrapper<PageModel<T>>? _dataWrapper;

  DataWrapper<PageModel<T>>? get dataWrapper => _dataWrapper;

  Future<DataWrapper<PageModel<T>>> refresh();

  @protected
  void onFailed(DataWrapper<PageModel<T>> dataWrapper) {}
}

///基础分页列表拓展，实现异步加载更多数据、填充数据等
///解决部分第三方库需要等待数据响应的场景
abstract class BasePageDataVmSub<T> extends IBasePageDataCommonVmSub<T> {
  late LoadMoreFormat<T> _loadMoreFormat;

  LoadMoreFormat<T> getLoadMoreFormat() => _loadMoreFormat;

  BasePageDataVmSub({LoadMoreFormat<T>? loadMoreFormat}) {
    this._loadMoreFormat = loadMoreFormat ?? LoadMoreFormat<T>();
  }

  @override
  void refreshAsync({bool notificationUi = true}) {
    _loadMoreFormat.refresh(notificationUi: notificationUi);
    loadMoreAsync();
  }

  @override
  Future<DataWrapper<PageModel<T>>> refresh({bool notificationUi = false}) async {
    _loadMoreFormat.refresh(notificationUi: notificationUi);
    return loadMore();
  }

  void loadMoreAsync() {
    onLoadMore(_loadMoreFormat).then((dataWrapper) {
      handlerDateWrapper(dataWrapper);
    }, onError: (error) {
      //不应该让错误在这处理
      handlerDateWrapper(DataWrapper.createFailed());
    });
  }

  Future<DataWrapper<PageModel<T>>> loadMore() async {
    DataWrapper<PageModel<T>> dataWrapper = await onLoadMore(_loadMoreFormat);
    handlerDateWrapper(dataWrapper);
    return dataWrapper;
  }

  @protected
  Future<DataWrapper<PageModel<T>>> onLoadMore(LoadMoreFormat<T> _loadMoreFormat);

  @protected
  void handlerDateWrapper(DataWrapper<PageModel<T>> dataWrapper) {
    if (dataWrapper.isSuccess()) {
      onSucceed(dataWrapper.data ?? PageModel());
    } else {
      onFailed(dataWrapper);
    }
  }

  @protected
  void onSucceed(PageModel<T> pageModel) {
    shouldSetState.updateVersion();
    _loadMoreFormat.formatByPageModel(dataList, pageModel);
  }

  @override
  void onFailed(DataWrapper<PageModel<T>> dataWrapper) {
    super.onFailed(dataWrapper);
    _loadMoreFormat.loadMoreFail();
  }
}

///对基础分页列表进一步拓展、快速外部设置加载更多数据
class FastBasePageDataVmSub<T> extends BasePageDataVmSub<T> with ListenerItemSelect<T> {
  LoadMore<T>? _loadMore;

  FastBasePageDataVmSub({super.loadMoreFormat});

  void setLoadData(LoadMore<T> loadMore) {
    this._loadMore = loadMore;
  }

  @override
  Future<DataWrapper<PageModel<T>>> onLoadMore(LoadMoreFormat<T> loadMoreFormat) {
    return _loadMore!.call(loadMoreFormat);
  }
}
