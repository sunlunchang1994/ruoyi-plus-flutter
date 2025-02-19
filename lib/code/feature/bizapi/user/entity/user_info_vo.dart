import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/role.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/user.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user_info_vo.g.dart';

@JsonSerializable()
class UserInfoVo {
  User user;
  List<int>? roleIds;
  List<Role>? roles;

  UserInfoVo(this.user, {this.roleIds,this.roles});

  factory UserInfoVo.fromJson(Map<String, dynamic> json) => _$UserInfoVoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoVoToJson(this);

  static UserInfoVo copyUser(UserInfoVo user) {
    return UserInfoVo.fromJson(user.toJson());
  }
}
