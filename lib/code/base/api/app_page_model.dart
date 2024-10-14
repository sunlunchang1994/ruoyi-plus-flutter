import 'package:json_annotation/json_annotation.dart';

part 'app_page_model.g.dart';

///@Author sunlunchang
///分页数据模型，根据后端返回的数据结构进行更改
@JsonSerializable()
class AppPageModel {
  int current;
  int? pages;
  bool? isLastPage;
  List<dynamic>? rows;

  bool searchCount;
  int size;
  int total;

  AppPageModel(
      {this.current = 0,
      this.pages,
      this.isLastPage,
      this.rows,
      this.searchCount = false,
      this.size = 0,
      this.total = 0}) {
    pages ??= (total / size).toInt() + 1;
  }

  bool getIsLastPage() {
    if (isLastPage == null) {
      return (current ?? 0) >= (pages ?? 1);
    }
    return isLastPage!;
  }

  factory AppPageModel.fromJson(Map<String, dynamic> json) => _$AppPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppPageModelToJson(this);
}

///将AppPageModel解析成具体的实体类
class IntensifyPageModel<T> {
  late AppPageModel _pageModel;
  List<T>? _dataList;

  IntensifyPageModel(
      {AppPageModel? pageModel, List<T>? dataList, List<T> Function(AppPageModel)? createData}) {
    pageModel ??= AppPageModel(current: 1, pages: 1, total: 0);
    /*if (pageModel == null) {
      pageModel = PageModel(current: 1, pages: 1, total: 0);
    }*/
    this._pageModel = pageModel;
    this._dataList = dataList;
    if (this._pageModel.rows != null && this._dataList == null && createData != null) {
      this._dataList = createData.call(this._pageModel);
    }
  }

  bool isLastPage() {
    return _pageModel.getIsLastPage();
  }

  AppPageModel getPageModel() {
    return _pageModel;
  }

  List<T> getListNoNull() {
    if (this._dataList == null) {
      this._dataList = List.empty(growable: true);
    }
    return _dataList!;
  }
}
