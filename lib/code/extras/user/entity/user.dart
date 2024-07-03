import 'dept.dart';
import 'role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  dynamic searchValue;
  String? createBy;
  String? createTime;
  dynamic updateBy;
  dynamic updateTime;
  dynamic remark;
  int? userId;
  int? deptId;
  String? userName;
  String? nickName;
  String? email;
  String? phonenumber;
  String? sex;
  String? avatar;
  String? password;
  String? status;
  String? delFlag;
  String? loginIp;
  String? loginDate;
  Dept? dept;
  List<Role>? roles;
  dynamic roleIds;
  dynamic postIds;
  dynamic roleId;
  bool? admin;

  User(
      {this.searchValue,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.userId,
      this.deptId,
      this.userName,
      this.nickName,
      this.email,
      this.phonenumber,
      this.sex,
      this.avatar,
      this.password,
      this.status,
      this.delFlag,
      this.loginIp,
      this.loginDate,
      this.dept,
      this.roles,
      this.roleIds,
      this.postIds,
      this.roleId,
      this.admin});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
