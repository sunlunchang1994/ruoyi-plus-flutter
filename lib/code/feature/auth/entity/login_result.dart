import 'package:json_annotation/json_annotation.dart';

part 'login_result.g.dart';

@JsonSerializable()
class LoginResult {
  //授权令牌
  String? access_token;

  //刷新令牌
  String? refresh_token;

  //授权令牌 access_token 的有效期
  int? expire_in;

  //刷新令牌 refresh_token 的有效期
  int? refresh_expire_in;

  //应用id
  String? client_id;

  //令牌权限
  String? scope;

  //用户 openid
  String? openid;

  LoginResult(
    this.access_token,
    this.refresh_token,
    this.expire_in,
    this.refresh_expire_in,
    this.client_id,
    this.scope,
    this.openid,
  );

  factory LoginResult.fromJson(Map<String, dynamic> json) => _$LoginResultFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}
