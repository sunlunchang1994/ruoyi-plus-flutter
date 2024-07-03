// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResult _$LoginResultFromJson(Map<String, dynamic> json) => LoginResult(
      User.fromJson(json['user'] as Map<String, dynamic>),
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['permissions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['token'] as String,
    );

Map<String, dynamic> _$LoginResultToJson(LoginResult instance) =>
    <String, dynamic>{
      'user': instance.user,
      'roles': instance.roles,
      'permissions': instance.permissions,
      'token': instance.token,
    };
