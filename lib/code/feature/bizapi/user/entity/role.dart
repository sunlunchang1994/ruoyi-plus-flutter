import 'package:json_annotation/json_annotation.dart';

import '../../../../base/api/json_converter.dart';

part 'role.g.dart';

@JsonSerializable()
class Role {
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
  String? createTime;
  bool flag;

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
      this.createTime,
      this.flag = false});

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
