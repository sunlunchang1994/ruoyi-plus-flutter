// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageModel _$PageModelFromJson(Map<String, dynamic> json) => PageModel(
      current: (json['current'] as num?)?.toInt() ?? 0,
      pages: (json['pages'] as num?)?.toInt() ?? 0,
      isLastPage: json['isLastPage'] as bool? ?? true,
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      searchCount: json['searchCount'] as bool? ?? false,
      size: (json['size'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PageModelToJson(PageModel instance) => <String, dynamic>{
      'current': instance.current,
      'pages': instance.pages,
      'isLastPage': instance.isLastPage,
      'records': instance.records,
      'searchCount': instance.searchCount,
      'size': instance.size,
      'total': instance.total,
    };
