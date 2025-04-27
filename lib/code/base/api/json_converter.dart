// 自定义日期转换器类，用于将 DateTime 对象与字符串之间进行 JSON 转换。
import 'package:flutter_slc_boxes/flutter/slc/common/date_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/slc_num_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/timeline_util.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

///@author sunlunchang
///Json格式化工具，在实体类字段加上相关类名注解，即可在序列化和反序列化时转换格式

///字符串
///@StringConverter()
class StringConverter implements JsonConverter<String?, dynamic> {
  const StringConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is String) {
      return json;
    }
    return json?.toString();
  }

  @override
  dynamic toJson(String? object) {
    return object;
  }
}

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

///时间戳格式化
///@DateConverter()
class MillisecondConverter implements JsonConverter<String, dynamic> {
  const MillisecondConverter();

  @override
  String fromJson(dynamic json) {
    int? millisecond;
    if (json is String) {
      millisecond = SlcNumUtil.getIntByValueStr(json);
    }
    millisecond ??= json;
    return millisecond != null ? DateUtil.formatDateMs(millisecond) : "";
  }

  @override
  dynamic toJson(String object) {
    return object;
  }
}

///双精度
///@DoubleConverter()
class DoubleConverter implements JsonConverter<double?, dynamic> {
  const DoubleConverter();

  @override
  double? fromJson(dynamic json) {
    if(json is double){
      return json;
    }
    if(json is String){
      return SlcNumUtil.getDoubleByValueStr(json);
    }
    return null;
  }

  @override
  String? toJson(double? object) {
    return object?.toString();
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
      return json.map((itemData) {
        return intConverter.fromJson(itemData)!;
      }).toList();
    }
    List<String> jsonStrList = json;
    return jsonStrList.map((itemData) {
      return int.parse(json);
    }).toList();
  }

  @override
  List<int>? toJson(List<int>? object) {
    return object;
  }
}

class Split2IntListConverter implements JsonConverter<List<int>?, dynamic> {
  const Split2IntListConverter();

  @override
  List<int>? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is List<int>) {
      return json;
    }
    String jsonStr = json;
    List<int>? result = TextUtil.split(jsonStr, TextUtil.COMMA)
        .map((e) => SlcNumUtil.getIntByValueStr(e.trim()))
        .nonNulls
        .toList();
    return result;
  }

  @override
  List<int>? toJson(List<int>? object) {
    return object;
  }
}
