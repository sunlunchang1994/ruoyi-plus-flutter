// 自定义日期转换器类，用于将 DateTime 对象与字符串之间进行 JSON 转换。
import 'package:flutter_slc_boxes/flutter/slc/common/date_util.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

///@Author sunlunchang
///Json格式化工具，在实体类字段加加上相关类名注解，即可在序列化和反序列化是转换格式

///@DateTimeConverter
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    return DateFormat(DateFormats.full).parse(json);
  }

  @override
  String toJson(DateTime object) {
    return DateFormat(DateFormats.full).format(object);
  }
}

///日期格式化
///@DateConverter()
class DateConverter implements JsonConverter<DateTime, String> {
  const DateConverter();

  @override
  DateTime fromJson(String json) {
    return DateFormat(DateFormats.y_mo_d).parse(json);
  }

  @override
  String toJson(DateTime object) {
    return DateFormat(DateFormats.y_mo_d).format(object);
  }
}

///双精度
///@DoubleConverter()
class DoubleConverter implements JsonConverter<double, String> {
  const DoubleConverter();

  @override
  double fromJson(String json) {
    return double.parse(json);
  }

  @override
  String toJson(double object) {
    return object.toString();
  }
}

///整数
///@IntConverter()
class IntConverter implements JsonConverter<int?, dynamic> {
  const IntConverter();

  @override
  int? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is int) {
      return json;
    }
    return int.parse(json);
  }

  @override
  String? toJson(int? object) {
    return object?.toString();
  }
}

///整数列表
///@IntConverter()
class IntListConverter implements JsonConverter<List<int>?, dynamic> {
  const IntListConverter();

  @override
  List<int>? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    IntConverter intConverter = IntConverter();
    if (json is List) {
      return json.map((itemData){
        return intConverter.fromJson(itemData)!;
      }).toList();
    }
    List<String> jsonStrList = json;
    return  jsonStrList.map((itemData){
      return int.parse(json);
    }).toList();
  }

  @override
  List<int>? toJson(List<int>? object) {
    return object;
  }
}
