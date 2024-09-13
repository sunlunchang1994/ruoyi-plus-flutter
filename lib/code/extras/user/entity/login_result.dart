import '../../../extras/user/entity/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_result.g.dart';

@JsonSerializable()
class LoginResult {
  User user;
  List<String>? roles;
  List<String>? permissions;
  String token;

  LoginResult(this.user, this.roles, this.permissions, this.token);

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}
