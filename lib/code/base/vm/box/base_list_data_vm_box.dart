import '../../api/result_entity.dart';
import '../../api/page_model.dart';
import 'load_more_format.dart';

typedef Refresh = Future Function();
typedef LoadMore<T> = Future Function(LoadMoreFormat<T> loadMoreFormat);
typedef ItemClick<T> = void Function(int index, T data);
typedef ItemLongClick<T> = void Function(int index, T data);

///基础数据列表
abstract class BaseListDataCommonVmBox<T> {
  final List<T> _dataList = List.empty(growable: true);

  List<T> getDataList() {
    return _dataList;
  }

  void refreshAsync();

  Future<List<T>> refresh();

  void itemClick(int index, T data) {}

  void itemLongClick(int index, T data) {}

  void onFailed(ResultEntity resultEntity) {}
}

///基础数据列表
abstract class BaseListDataVmBox<T> extends BaseListDataCommonVmBox<T> {
  void onSucceed(List<T> dataList) {
    _dataList.clear();
    _dataList.addAll(dataList);
  }
}

///基础分页数据列表
abstract class BaseListDataPageVmBox<T> extends BaseListDataCommonVmBox<T> {
  final LoadMoreFormat<T> _loadMoreFormat = LoadMoreFormat<T>();

  LoadMoreFormat<T> getLoadMoreFormat() => _loadMoreFormat;

  @override
  void refreshAsync({bool notificationUi = true}) {
    _loadMoreFormat.refresh(notificationUi: notificationUi);
    loadMoreAsync();
  }

  @override
  Future<List<T>> refresh({bool notificationUi = false}) async {
    _loadMoreFormat.refresh(notificationUi: notificationUi);
    return loadMore();
  }

  void loadMoreAsync();

  Future<List<T>> loadMore();

  void onSucceed(IntensifyPageModel<T> pageModel) {
    _loadMoreFormat.formatByPageModel(_dataList, pageModel);
  }

  @override
  void onFailed(ResultEntity resultEntity) {
    super.onFailed(resultEntity);
    _loadMoreFormat.loadMoreFail();
  }
}

mixin class ListenerItemClick<T> {
  ItemClick<T>? _itemClick;
  ItemLongClick<T>? _itemLongClick;

  void setItemClick(ItemClick<T> itemClick) {
    this._itemClick = itemClick;
  }

  void setItemLongClick(ItemLongClick<T> itemLongClick) {
    this._itemLongClick = itemLongClick;
  }
}

class FastBaseListDataVmBox<T> extends BaseListDataVmBox<T>
    with ListenerItemClick<T> {
  Refresh? _refresh;

  void setRefresh(Refresh refresh) {
    this._refresh = refresh;
  }

  @override
  void refreshAsync() {
    _refresh?.call();
  }

  @override
  Future<List<T>> refresh() async {
    await _refresh?.call();
    return _dataList;
  }

  @override
  void itemClick(int index, T data) {
    super.itemClick(index, data);
    super._itemClick?.call(index, data);
  }

  @override
  void itemLongClick(int index, T data) {
    super.itemLongClick(index, data);
    super._itemLongClick?.call(index, data);
  }
}

class FastBaseListDataPageVmBox<T> extends BaseListDataPageVmBox<T>
    with ListenerItemClick<T> {
  LoadMore? _loadMore;

  void setLoadData(LoadMore loadMore) {
    this._loadMore = loadMore;
  }

  @override
  void loadMoreAsync() {
    _loadMore?.call(_loadMoreFormat);
  }

  @override
  Future<List<T>> loadMore() async {
    await _loadMore?.call(_loadMoreFormat);
    return _dataList;
  }

  @override
  void itemClick(int index, T data) {
    super.itemClick(index, data);
    super._itemClick?.call(index, data);
  }

  @override
  void itemLongClick(int index, T data) {
    super.itemLongClick(index, data);
    super._itemLongClick?.call(index, data);
  }
}
