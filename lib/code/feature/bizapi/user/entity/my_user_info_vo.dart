import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/user.dart';

import 'package:json_annotation/json_annotation.dart';

part 'my_user_info_vo.g.dart';

@JsonSerializable()
class MyUserInfoVo {
  User user;
  List<String>? permissions;
  List<String>? roles;

  MyUserInfoVo(this.user, {this.permissions, this.roles});

  factory MyUserInfoVo.fromJson(Map<String, dynamic> json) => _$MyUserInfoVoFromJson(json);

  Map<String, dynamic> toJson() => _$MyUserInfoVoToJson(this);

  static MyUserInfoVo copyUser(MyUserInfoVo user) {
    return MyUserInfoVo.fromJson(user.toJson());
  }
}
