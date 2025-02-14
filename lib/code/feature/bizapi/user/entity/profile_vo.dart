import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/user.dart';

import 'package:json_annotation/json_annotation.dart';

part 'profile_vo.g.dart';

@JsonSerializable()
class ProfileVo {
  User? user;
  String? roleGroup;
  String? postGroup;

  ProfileVo({this.user,
    this.roleGroup,
    this.postGroup});

  factory ProfileVo.fromJson(Map<String, dynamic> json) => _$ProfileVoFromJson(json);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = _$ProfileVoToJson(this);
    return jsonMap;
  }

}
