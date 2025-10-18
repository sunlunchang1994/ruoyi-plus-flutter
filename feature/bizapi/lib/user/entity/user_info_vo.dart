import 'package:base/base/api/json_converter.dart';
import 'package:bizapi/user/entity/post.dart';
import 'package:bizapi/user/entity/role.dart';
import 'package:bizapi/user/entity/user.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user_info_vo.g.dart';

/// @author sunlunchang
/// 用户信息
@JsonSerializable()
class UserInfoVo {
  User? user;
  @BigIntListConverter()
  List<BigInt>? roleIds;
  List<Role>? roles;
  @BigIntListConverter()
  List<BigInt>? postIds;
  List<Post>? posts;

  UserInfoVo(this.user, {this.roleIds,this.roles,this.postIds,this.posts});

  factory UserInfoVo.fromJson(Map<String, dynamic> json) => _$UserInfoVoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoVoToJson(this);

  static UserInfoVo copyUser(UserInfoVo user) {
    return UserInfoVo.fromJson(user.toJson());
  }
}
