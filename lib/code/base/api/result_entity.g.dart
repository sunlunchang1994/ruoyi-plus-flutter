// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultEntity _$ResultEntityFromJson(Map<String, dynamic> json) => ResultEntity(
      code: json['code'] as int?,
      msg: json['msg'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$ResultEntityToJson(ResultEntity instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };
