import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'api_config.dart';

part 'result_entity.g.dart';

///@author sunlunchang
abstract class IResultEntity {
  int? get code;

  String? get msg;

  dynamic get data;

  bool isSuccess() {
    return code == 0 || code == ApiConfig.VALUE_CODE_SUCCEED;
  }
}

///后端返回的实体类基础结构
@JsonSerializable()
class ResultEntity extends IResultEntity {
  @override
  int? code;

  @override
  String? msg;

  @override
  dynamic data;

  ResultEntity({this.code, this.msg, this.data});

  factory ResultEntity.fromJson(Map<String, dynamic> json) =>
      _$ResultEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ResultEntityToJson(this);

  IntensifyEntity<T> toIntensify<T>(
      {bool succeedEntity = false,
      T? data,
      T? Function(ResultEntity)? createData,
      bool createNull = false}) {
    return IntensifyEntity(
        resultEntity: this,
        createSucceed: succeedEntity ? () => createSucceedEntity() : null,
        data: data,
        createData: createData != null
            ? (resultEntity) => createData.call(resultEntity as ResultEntity)
            : null,
        createNull: createNull);
  }

  ///创建成功的ResultEntity
  static ResultEntity createSucceedEntity() {
    return ResultEntity(code: ApiConfig.VALUE_CODE_SUCCEED);
  }

  ///创建失败的的ResultEntity
  static ResultEntity createSucceedFail(String msg,
      {int code = ApiConfig.VALUE_CODE_SERVER_ERROR}) {
    return ResultEntity(code: code, msg: msg);
  }

}

///后端返回的实体类基础结构
///根据后端返回的数据结构定义，可更改toPageModel、resultToPageModel方法实现转换
@JsonSerializable()
class ResultPageModel extends IResultEntity {
  @override
  int? code;

  @override
  String? msg;

  dynamic rows;

  int total;

  @override
  dynamic get data => rows;

  ResultPageModel({this.code, this.msg, this.rows, this.total = 0});

  factory ResultPageModel.fromJson(Map<String, dynamic> json) =>
      _$ResultPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResultPageModelToJson(this);

  ///转车呢个PageModel IntensifyEntity
  IntensifyEntity<PageModel<T>> toIntensify<T>(
      {bool succeedEntity = false,
      PageModel<T>? data,
      PageModel<T>? Function(ResultPageModel)? createData,
      bool createNull = false}) {
    return IntensifyEntity<PageModel<T>>(
        resultEntity: this,
        createSucceed: succeedEntity ? () => createSucceedEntity() : null,
        data: data,
        createData: createData != null
            ? (resultEntity) => createData.call(resultEntity as ResultPageModel)
            : null,
        createNull: createNull);
  }

  ///只获取list
  IntensifyEntity<List<T>> toListIntensify<T>(
      {bool succeedEntity = false,
      List<T>? data,
      List<T>? Function(ResultPageModel)? createData,
      bool createNull = false}) {
    return IntensifyEntity<List<T>>(
        resultEntity: this,
        createSucceed: succeedEntity ? () => createSucceedEntity() : null,
        data: data,
        createData: createData != null
            ? (resultEntity) => createData.call(resultEntity as ResultPageModel)
            : null,
        createNull: createNull);
  }

  ///转成PageModel
  PageModel<T> toPageModel<T>(int current, int size,
      {List<T>? Function(dynamic)? createRecords}) {
    return ResultPageModel.resultToPageModel(current, size, this,
        createRecords: createRecords);
  }

  ///创建成功的ResultPageModel
  static ResultPageModel createSucceedEntity() {
    return ResultPageModel(code: ApiConfig.VALUE_CODE_SUCCEED);
  }

  ///创建成功的ResultPageModel
  static ResultPageModel createSucceedFail(String msg,
      {int code = ApiConfig.VALUE_CODE_SERVER_ERROR}) {
    return ResultPageModel(code: code, msg: msg);
  }

  ///结果转PageModel
  static PageModel<T> resultToPageModel<T>(
      int current, int size, ResultPageModel resultPageModel,
      {List<T>? Function(dynamic)? createRecords}) {
    PageModel<T> pageModel = PageModel(
        current: current,
        size: size,
        pages: PageUtils.totalPage(resultPageModel.total, size),
        total: resultPageModel.total,
        records: createRecords?.call(resultPageModel.data));
    return pageModel;
  }
}

///动态类型转为具体的泛型类型
class IntensifyEntity<T> {
  late IResultEntity _resultEntity;
  T? _data;

  ///
  /// @createNull true 表示当this._resultEntity.data为空时也调用createData
  IntensifyEntity(
      {IResultEntity? resultEntity,
      IResultEntity Function()? createSucceed,
      T? data,
      T? Function(IResultEntity)? createData,
      bool createNull = false}) {
    if (resultEntity == null && createSucceed != null) {
      resultEntity = createSucceed.call();
    }
    this._resultEntity = resultEntity!;
    this._data = data;
    if (this._resultEntity.isSuccess() &&
        this._data == null &&
        createData != null &&
        (this._resultEntity.data != null || createNull)) {
      this._data = createData.call(this._resultEntity);
    }
  }

  T? get data => this._data;

  bool isSuccess() {
    return _resultEntity.isSuccess();
  }

  get resultEntity => _resultEntity;

  int? getCode() {
    return _resultEntity.code;
  }

  String getMsg() {
    return _resultEntity.msg ?? "";
  }

  Map<String, dynamic> getSrcData() {
    return _resultEntity.data;
  }
}
