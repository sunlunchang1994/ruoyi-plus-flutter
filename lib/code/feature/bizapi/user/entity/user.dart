import 'package:flutter_slc_boxes/flutter/slc/common/object_util.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/post.dart';

import '../../../../base/api/json_converter.dart';
import 'role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends TenantEntity {
  @IntConverter()
  int? userId;
  @IntConverter()
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
  String? deptName;
  List<Role>? roles;
  @IntListConverter()
  List<int>? roleIds;
  @IntListConverter()
  List<int>? postIds;
  int? roleId;

  //本地
  String? sexName;
  String? statusName;
  List<Post>? posts;

  User(
      {this.userId,
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
      this.remark,
      this.roles,
      this.roleIds,
      this.postIds,
      this.roleId,
      super.tenantId,
      super.searchValue,
      super.createDept,
      super.createBy,
      super.createTime,
      super.updateBy,
      super.updateTime,
      super.params});

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
