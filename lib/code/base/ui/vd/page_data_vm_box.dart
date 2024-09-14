import 'list_data_component.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/load_more_format.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';

/// @Author sunlunchang
/// mvvm接口数据拓展
/// 对基础列表分页数据管理进一步拓展、用户快速构建列表分页数据管理

///基础分页列表
abstract class IBasePageDataCommonVmBox<T> extends IListDataVmBox<T> {
  DateWrapper<PageModel<T>>? _dateWrapper;

  DateWrapper<PageModel<T>>? get dateWrapper => _dateWrapper;

  Future<DateWrapper<PageModel<T>>> refresh();

  void onFailed(DateWrapper<PageModel<T>> dateWrapper) {}
}

///基础分页列表拓展，实现异步加载更多数据、填充数据等
abstract class BasePageDataVmBox<T> extends IBasePageDataCommonVmBox<T> {
  final LoadMoreFormat<T> _loadMoreFormat = LoadMoreFormat<T>();

  LoadMoreFormat<T> getLoadMoreFormat() => _loadMoreFormat;

  @override
  void refreshAsync({bool notificationUi = true}) {
    _loadMoreFormat.refresh(notificationUi: notificationUi);
    loadMoreAsync();
  }

  @override
  Future<DateWrapper<PageModel<T>>> refresh(
      {bool notificationUi = false}) async {
    _loadMoreFormat.refresh(notificationUi: notificationUi);
    return loadMore();
  }

  void loadMoreAsync() {
    refresh().then((dateWrapper) {
      handlerDateWrapper(dateWrapper);
    }, onError: (error) {
      //不应该让错误在这处理
      handlerDateWrapper(DateWrapper.createFailed());
    });
  }

  Future<DateWrapper<PageModel<T>>> loadMore();

  void handlerDateWrapper(DateWrapper<PageModel<T>> dataWrapper) {
    if (dataWrapper.isSuccess()) {
      onSucceed(dataWrapper.data ?? PageModel());
    } else {
      onFailed(dataWrapper);
    }
  }

  void onSucceed(PageModel<T> pageModel) {
    _loadMoreFormat.formatByPageModel(dataList, pageModel);
  }

  @override
  void onFailed(DateWrapper<PageModel<T>> dateWrapper) {
    super.onFailed(dateWrapper);
    _loadMoreFormat.loadMoreFail();
  }
}

///对基础分页列表进一步拓展、快速实现同步刷新、解决部分第三方库需要等待数据响应的场景
class FastBaseListDataPageVmBox<T> extends BasePageDataVmBox<T>
    with ListenerItemClick<T> {

  LoadMore<T>? _loadMore;

  void setLoadData(LoadMore<T> loadMore) {
    this._loadMore = loadMore;
  }

  @override
  void loadMoreAsync() {
    _loadMore?.call(_loadMoreFormat);
  }

  @override
  Future<DateWrapper<PageModel<T>>> loadMore() async {
    DateWrapper<PageModel<T>> dateWrapper =
        await _loadMore!.call(_loadMoreFormat);
    handlerDateWrapper(dateWrapper);
    return dateWrapper;
  }
}
