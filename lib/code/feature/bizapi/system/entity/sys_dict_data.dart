import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';

import 'package:json_annotation/json_annotation.dart';

import '../../../../base/api/json_converter.dart';

part 'sys_dict_data.g.dart';

///@Author sunlunchang
///字典类型
@JsonSerializable()
class SysDictData extends TenantEntity {
  ///字典编码
  @IntConverter()
  int? dictCode;

  ///字典排序
  @IntConverter()
  int? dictSort;

  ///字典标签
  String? dictLabel;

  ///字典键值
  String? dictValue;

  ///字典类型
  String? dictType;

  ///样式属性（其他样式扩展）
  String? cssClass;

  ///表格回显样式
  String? listClass;

  ///是否默认（Y是 N否）
  String? isDefault;

  ///备注
  String? remark;

  SysDictData(
      {this.dictCode,
      this.dictSort,
      this.dictLabel,
      this.dictValue,
      this.dictType,
      this.cssClass,
      this.listClass,
      this.isDefault,
      this.remark});

  factory SysDictData.fromJson(Map<String, dynamic> json) =>
      _$SysDictDataFromJson(json);

  Map<String, dynamic> toJson() => _$SysDictDataToJson(this);

  static List<SysDictData> fromJsonList(List<dynamic>? json) {
    return json?.map((item) {
          return SysDictData.fromJson(item);
        }).toList(growable: true) ??
        List.empty(growable: true);
  }
}
