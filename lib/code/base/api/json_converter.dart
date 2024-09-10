// 自定义日期转换器类，用于将 DateTime 对象与字符串之间进行 JSON 转换。
import 'package:flutter_slc_boxes/flutter/slc/common/date_util.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

///日期时间格式化
///@DateTimeConverter()
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