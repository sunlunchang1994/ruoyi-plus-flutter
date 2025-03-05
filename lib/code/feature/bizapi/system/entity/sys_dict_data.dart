import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';

import 'package:json_annotation/json_annotation.dart';

import '../../../../base/api/json_converter.dart';
import '../../../component/dict/entity/tree_dict.dart';

part 'sys_dict_data.g.dart';

///@author sunlunchang
///字典类型
@JsonSerializable()
class SysDictData extends TenantEntity implements ITreeDict<SysDictData> {
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

  @override
  List<SysDictData>? get tdChildren => null;

  @override
  String? get tdCode => dictType;

  @override
  String? get tdDictLabel => dictLabel;

  @override
  String? get tdDictValue => dictValue;

  @override
  // TODO: implement tdId
  String? get tdId => dictCode?.toString();

  @override
  bool get tdIsDefault => isDefault == "Y";

  @override
  int? get tdIsDeleted => null;

  @override
  int? get tdIsSealed => null;

  @override
  String? get tdParentId => null;

  @override
  String? get tdParentName => null;

  @override
  String? get tdRemark => remark;

  @override
  int? get tdSort => dictSort;
}
