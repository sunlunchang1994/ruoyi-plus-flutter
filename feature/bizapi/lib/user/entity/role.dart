import 'package:base/base/api/json_converter.dart';
import 'package:base/base/entity/tenant_entity.dart';
import 'package:boxes_flutter/flutter/slc/adapter/select_box.dart';
import 'package:component/component/adapter/app_select_box.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

/// @author sunlunchang
/// 角色实体类
@JsonSerializable()
class Role extends TenantEntity with AppSelectBoxMixin<Role> {
  @BigIntConverter()
  BigInt? roleId;
  String? roleName;
  String? roleKey;
  int? roleSort;
  String? dataScope;
  bool? menuCheckStrictly;
  bool? deptCheckStrictly;
  String? status;
  String? remark;
  bool flag;
  @BigIntListConverter()
  List<BigInt>? menuIds;

  String? statusName;
  String? dataScopeName;

  Role({this.roleId,
    this.roleName,
    this.roleKey,
    this.roleSort,
    this.dataScope,
    this.menuCheckStrictly,
    this.deptCheckStrictly,
    this.status,
    this.remark,
    this.flag = false,
    this.menuIds,
    this.statusName,
    super.tenantId,
    super.searchValue,
    super.createDept,
    super.createBy,
    super.createTime,
    super.updateBy,
    super.updateTime,
    super.params});

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);

  static List<Role> formJsonList(List<dynamic>? data) {
    return data?.map((json) => Role.fromJson(json)).toList() ?? List.empty();
  }


  static List<BigInt>? toRoleIdList(List<Role>? values) {
    return values?.map((value) {
      return value.roleId!;
    }).toList();
  }
}
