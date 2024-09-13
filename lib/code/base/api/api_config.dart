import '../../extras/component/attachment/utils/attachment_config.dart';
import 'package:flutter_slc_boxes/flutter/slc/network/api_constant.dart';

class ApiConfig extends ApiConstant {
  static const String KEY_TOKEN = "Authorization";
  static const int CODE_UNKNOWN_MISTAKE = 500;
  static const String STR_UNKNOWN_MISTAKE = "Unknown mistake";

  ApiConfig._privateConstructor() {
    _syncAttachment();
  }

  static final ApiConfig _instance = ApiConfig._privateConstructor();

  factory ApiConfig() {
    return _instance;
  }

  //基于原版ruoyi-vue  不是ruoyi-vue-plus
  String _apiUrl = "http://175.178.17.134:11021";

  String? token;

  String getApiUrl() {
    return _apiUrl;
  }

  void setApiUrl(String apiUrl) {
    _apiUrl = apiUrl;
    _syncAttachment();
  }

  void _syncAttachment() {
    AttachmentConfig().setDownloadIpPort(getApiUrl());
    AttachmentConfig().setDownloadApiPart("");
  }
}

abstract class OnSuccess<T> {}

abstract class OnError<int, String> {
  OnError._() {
    throw new UnsupportedError("OnSuccess can't be instantiated");
  }
}
