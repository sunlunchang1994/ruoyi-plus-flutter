import 'package:json_annotation/json_annotation.dart';

part 'result_entity.g.dart';

///@Author sunlunchang
///后端返回的实体类基础结构
@JsonSerializable()
class ResultEntity {
  int? code;
  String? msg;
  dynamic data;

  ResultEntity(
      {this.code, this.msg, this.data});

  bool isSuccess() {
    return code == 0 || code == 200;
  }

  factory ResultEntity.fromJson(Map<String, dynamic> json) =>
      _$ResultEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ResultEntityToJson(this);
}

///动态类型转为具体的泛型类型
class IntensifyEntity<T> {
  late ResultEntity _resultEntity;
  T? _data;

  IntensifyEntity({ResultEntity? resultEntity,
    bool succeedEntity = false,
    T? data,
    T Function(ResultEntity)? createData}) {
    if (resultEntity == null && succeedEntity) {
      resultEntity = ResultEntity(code: 200);
    }
    this._resultEntity = resultEntity!;
    this._data = data;
    if (this._resultEntity.isSuccess() && this._data == null &&
        createData != null) {
      this._data = createData.call(this._resultEntity);
    }
  }

  get data => this._data;

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
