import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../repository/remote/page_transform_utils.dart';
import 'app_page_model.dart';

part 'result_entity.g.dart';

///@Author sunlunchang
abstract class IResultEntity {
  static const CODE_SUCCESS = 200;

  int? get code;

  String? get msg;

  dynamic get data;

  bool isSuccess() {
    return code == 0 || code == IResultEntity.CODE_SUCCESS;
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

  factory ResultEntity.fromJson(Map<String, dynamic> json) => _$ResultEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ResultEntityToJson(this);

  static ResultEntity createSucceedEntity() {
    return ResultEntity(code: IResultEntity.CODE_SUCCESS);
  }

  IntensifyEntity<T> toIntensify<T>(
      {bool succeedEntity = false,
      T? data,
      T? Function(IResultEntity)? createData,
      bool createNull = false}) {
    return IntensifyEntity(
        resultEntity: this,
        createSucceed: succeedEntity ? () => ResultEntity(code: IResultEntity.CODE_SUCCESS) : null,
        data: data,
        createData: createData,
        createNull: createNull);
  }
}

///后端返回的实体类基础结构
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

  factory ResultPageModel.fromJson(Map<String, dynamic> json) => _$ResultPageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResultPageModelToJson(this);

  static ResultPageModel createSucceedEntity() {
    return ResultPageModel(code: IResultEntity.CODE_SUCCESS);
  }

  IntensifyEntity<PageModel<T>> toIntensify<T>(
      {bool succeedEntity = false,
      PageModel<T>? data,
      PageModel<T>? Function(IResultEntity)? createData,
      bool createNull = false}) {
    return IntensifyEntity<PageModel<T>>(
        resultEntity: this,
        createSucceed: succeedEntity ? () => ResultPageModel(code: IResultEntity.CODE_SUCCESS) : null,
        data: data,
        createData: createData,
        createNull: createNull);
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
