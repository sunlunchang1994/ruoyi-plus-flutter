import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/post.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/role.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/user.dart';

import 'package:json_annotation/json_annotation.dart';

import '../../../../base/api/json_converter.dart';

part 'user_info_vo.g.dart';

@JsonSerializable()
class UserInfoVo {
  User? user;
  @IntListConverter()
  List<int>? roleIds;
  List<Role>? roles;
  @IntListConverter()
  List<int>? postIds;
  List<Post>? posts;

  UserInfoVo(this.user, {this.roleIds,this.roles,this.postIds,this.posts});

  factory UserInfoVo.fromJson(Map<String, dynamic> json) => _$UserInfoVoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoVoToJson(this);

  static UserInfoVo copyUser(UserInfoVo user) {
    return UserInfoVo.fromJson(user.toJson());
  }
}
