import 'package:flutter_slc_boxes/flutter/slc/network/api_constant.dart';

class ApiConfig extends ApiConstant {
  static const String KEY_TOKEN = "Authorization";
  static const int CODE_UNKNOWN_MISTAKE = 500;
  static const String STR_UNKNOWN_MISTAKE = "Unknown mistake";

  //基于原版ruoyi-vue  不是ruoyi-vue-plus
  static const String API_URL = "http://175.178.17.134:11021";

  ApiConfig._privateConstructor();

  static final ApiConfig _instance = ApiConfig._privateConstructor();

  factory ApiConfig() {
    return _instance;
  }

  String? token;
}

abstract class OnSuccess<T> {}

abstract class OnError<int, String> {
  OnError._() {
    throw new UnsupportedError("OnSuccess can't be instantiated");
  }
}
