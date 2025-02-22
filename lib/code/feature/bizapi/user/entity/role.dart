import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../base/api/json_converter.dart';
import '../../../../base/entity/tenant_entity.dart';

part 'role.g.dart';

@JsonSerializable()
class Role extends TenantEntity with SelectBoxMixin<Role> {
  @IntConverter()
  int? roleId;
  String? roleName;
  String? roleKey;
  int? roleSort;
  String? dataScope;
  bool? menuCheckStrictly;
  bool? deptCheckStrictly;
  String? status;
  String? remark;
  bool flag;

  String? statusName;

  Role(
      {this.roleId,
      this.roleName,
      this.roleKey,
      this.roleSort,
      this.dataScope,
      this.menuCheckStrictly,
      this.deptCheckStrictly,
      this.status,
      this.remark,
      this.flag = false,
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
}
