// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResult _$LoginResultFromJson(Map<String, dynamic> json) => LoginResult(
      json['access_token'] as String?,
      json['refresh_token'] as String?,
      (json['expire_in'] as num?)?.toInt(),
      (json['refresh_expire_in'] as num?)?.toInt(),
      json['client_id'] as String?,
      json['scope'] as String?,
      json['openid'] as String?,
    );

Map<String, dynamic> _$LoginResultToJson(LoginResult instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'refresh_token': instance.refresh_token,
      'expire_in': instance.expire_in,
      'refresh_expire_in': instance.refresh_expire_in,
      'client_id': instance.client_id,
      'scope': instance.scope,
      'openid': instance.openid,
    };
