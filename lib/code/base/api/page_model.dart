import 'package:json_annotation/json_annotation.dart';

part 'page_model.g.dart';

///加载更多
@JsonSerializable()
class PageModel {
  int? current;
  int? pages;
  bool? isLastPage;
  List<Map<String, dynamic>>? records;

  bool? searchCount;
  int? size;
  int? total;

  PageModel(
      {this.current = 0,
      this.pages = 0,
      this.isLastPage = true,
      this.records,
      this.searchCount = false,
      this.size = 0,
      this.total = 0});

  bool getIsLastPage() {
    if (isLastPage == null) {
      return (current??0) >= (pages??1);
    }
    return isLastPage!;
  }

  factory PageModel.fromJson(Map<String, dynamic> json) =>
      _$PageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageModelToJson(this);
}

class IntensifyPageModel<T> {
  late PageModel _pageModel;
  List<T>? _dataList;

  IntensifyPageModel(
      {PageModel? pageModel,
      List<T>? dataList,
      List<T> Function(PageModel)? createData}) {
    pageModel ??= PageModel(current: 1, pages: 1, total: 0);
    /*if (pageModel == null) {
      pageModel = PageModel(current: 1, pages: 1, total: 0);
    }*/
    this._pageModel = pageModel;
    this._dataList = dataList;
    if (this._pageModel.records != null &&
        this._dataList == null &&
        createData != null) {
      this._dataList = createData.call(this._pageModel);
    }
  }

  bool isLastPage() {
    return _pageModel.getIsLastPage();
  }

  PageModel getPageModel() {
    return _pageModel;
  }

  List<T> getListNoNull() {
    if (this._dataList == null) {
      this._dataList = List.empty(growable: true);
    }
    return _dataList!;
  }
}