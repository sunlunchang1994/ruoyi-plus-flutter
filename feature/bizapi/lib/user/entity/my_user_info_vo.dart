import 'package:bizapi/user/entity/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_user_info_vo.g.dart';

/// @author sunlunchang
/// 登录用户信息
@JsonSerializable()
class MyUserInfoVo {
  User user;
  List<String>? permissions;
  List<String>? roles;

  MyUserInfoVo(this.user, {this.permissions, this.roles});

  factory MyUserInfoVo.fromJson(Map<String, dynamic> json) => _$MyUserInfoVoFromJson(json);

  Map<String, dynamic> toJson() => _$MyUserInfoVoToJson(this);

  //所有权限标示符号
  static const String _allPermission = "*:*:*";

  bool hasPermiAny(List<String> permis) {
    assert(permis.isNotEmpty);
    final hasAll = permissions?.contains(_allPermission) ?? false;
    return hasAll || permis.any((item) => permissions?.contains(item) ?? false);
  }

  bool hasPermiEvery(List<String> permis) {
    assert(permis.isNotEmpty);
    final hasAll = permissions?.contains(_allPermission) ?? false;
    return hasAll || permis.every((item) => permissions?.contains(item) ?? false);
  }

  static MyUserInfoVo copyUser(MyUserInfoVo user) {
    return MyUserInfoVo.fromJson(user.toJson());
  }
}
