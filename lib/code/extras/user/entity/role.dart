import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable()
class Role {
  dynamic searchValue;
  dynamic createBy;
  dynamic createTime;
  dynamic updateBy;
  dynamic updateTime;
  dynamic remark;
  int? roleId;
  String? roleName;
  String? roleKey;
  String? roleSort;
  String? dataScope;
  bool? menuCheckStrictly;
  bool? deptCheckStrictly;
  String? status;
  dynamic delFlag;
  bool? flag;
  dynamic menuIds;
  dynamic deptIds;
  bool? admin;

  Role(
      {this.searchValue,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.roleId,
      this.roleName,
      this.roleKey,
      this.roleSort,
      this.dataScope,
      this.menuCheckStrictly,
      this.deptCheckStrictly,
      this.status,
      this.delFlag,
      this.flag,
      this.menuIds,
      this.deptIds,
      this.admin});

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
