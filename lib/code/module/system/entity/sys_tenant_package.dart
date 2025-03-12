import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/base_entity.dart';

import '../../../base/api/json_converter.dart';

part 'sys_tenant_package.g.dart';

@JsonSerializable()
class SysTenantPackage extends BaseEntity {
  @IntConverter()
  int? packageId;

  String? packageName;

  //提交时是List<int>，获取时是String，此处使用自定义转换器转换
  @Split2IntListConverter()
  List<int>? menuIds;

  String? remark;

  //菜单树选择项是否关联显示（ 0：父子不互相关联显示 1：父子互相关联显示）
  bool? menuCheckStrictly;

  String? status;

  String? delFlag;

  SysTenantPackage({
    this.packageId,
    this.packageName,
    this.menuIds,
    this.remark,
    this.menuCheckStrictly,
    this.status,
    this.delFlag,
  });

  factory SysTenantPackage.fromJson(Map<String, dynamic> json) => _$SysTenantPackageFromJson(json);

  Map<String, dynamic> toJson() => _$SysTenantPackageToJson(this);

  static List<SysTenantPackage> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => SysTenantPackage.fromJson(json)).toList() ?? List.empty();
  }
}
