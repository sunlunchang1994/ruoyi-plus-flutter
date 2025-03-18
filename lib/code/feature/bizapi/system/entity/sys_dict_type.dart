import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/adapter/app_select_box.dart';

import '../../../../base/api/json_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sys_dict_type.g.dart';

///@author sunlunchang
///字典类型
@JsonSerializable()
class SysDictType extends TenantEntity with AppSelectBoxMixin<SysDictType> {
  ///字典主键
  ///
  @IntConverter()
  int? dictId;

  ///字典名称
  String? dictName;

  ///字典类型
  String? dictType;

  ///备注
  String? remark;

  SysDictType({this.dictId, this.dictName, this.dictType, this.remark});

  factory SysDictType.fromJson(Map<String, dynamic> json) => _$SysDictTypeFromJson(json);

  Map<String, dynamic> toJson() => _$SysDictTypeToJson(this);

  static List<SysDictType> fromJsonList(List<dynamic>? json) {
    return json?.map((item) {
          return SysDictType.fromJson(item);
        }).toList(growable: true) ??
        List.empty(growable: true);
  }
}
