import 'package:ruoyi_plus_flutter/code/extras/user/entity/user.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user_info_vo.g.dart';

@JsonSerializable()
class UserInfoVo {
  User? user;
  List<String>? permissions;
  List<String>? roles;

  UserInfoVo(
      {this.user,
      this.permissions,
      this.roles});

  factory UserInfoVo.fromJson(Map<String, dynamic> json) => _$UserInfoVoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoVoToJson(this);
}
