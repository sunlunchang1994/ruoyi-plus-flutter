import 'package:flutter_slc_boxes/flutter/slc/common/object_util.dart';

import 'role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? userId;
  String? tenantId;
  int? deptId;
  String? userName;
  String? nickName;
  String? userType;
  String? email;
  String? phonenumber;
  String? sex;
  String? avatar;
  String? password;
  String? status;
  String? loginIp;
  String? loginDate;
  String? remark;
  String? createTime;
  String? deptName;
  List<Role>? roles;
  List<int>? roleIds;
  List<int>? postIds;
  List<int>? roleId;
  //本地
  String? sexName;

  User({this.userId,
    this.deptId,
    this.userName,
    this.nickName,
    this.email,
    this.phonenumber,
    this.sex,
    this.avatar,
    this.password,
    this.status,
    this.loginIp,
    this.loginDate,
    this.createTime,
    this.remark,
    this.roles,
    this.roleIds,
    this.postIds,
    this.roleId});

  String? getRoleName() {
    if (ObjectUtil.isEmptyList(roles)) {
      return null;
    }
    return roles!.map((item) {
      return item.roleName;
    }).join(',');
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = _$UserToJson(this);
    jsonMap['roles'] = roles?.map((role) => role.toJson()).toList();
    return jsonMap;
  }

  static List<User> formJsonList(List<dynamic>? data) {
    return data?.map((json) => User.fromJson(json)).toList() ?? List.empty();
  }

  static User copyUser(User user) {
    return User.fromJson(user.toJson());
  }
}
