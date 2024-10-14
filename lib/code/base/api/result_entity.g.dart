// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultEntity _$ResultEntityFromJson(Map<String, dynamic> json) => ResultEntity(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$ResultEntityToJson(ResultEntity instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };

ResultPageModel _$ResultPageModelFromJson(Map<String, dynamic> json) =>
    ResultPageModel(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      rows: json['rows'],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ResultPageModelToJson(ResultPageModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'rows': instance.rows,
      'total': instance.total,
    };
