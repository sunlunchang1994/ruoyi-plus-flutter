import 'package:ruoyi_plus_flutter/code/base/config/env_config.dart';

import '../../feature/component/attachment/utils/attachment_config.dart';
import 'package:flutter_slc_boxes/flutter/slc/network/api_constant.dart';

///@Author sunlunchang
///Api配置类、配置url、token等，可根据需要再此拓展
class ApiConfig extends ApiConstant {
  static const String KEY_TOKEN = "authorization"; //token key
  static const String KEY_CLIENT_ID = "clientid"; //客户端id
  static const String KEY_ENCRYPT_KEY = "encrypt-key"; //加密标记
  static const String KEY_APPLY_ENCRYPT = "applyEncrypt"; //应用加密
  static const int CODE_UNKNOWN_MISTAKE = 500;
  static const String STR_UNKNOWN_MISTAKE = "Unknown mistake";

  ApiConfig._privateConstructor() {
    _apiUrl = EnvConfig.getEnvConfig().apiUrl;
    _clientid = EnvConfig.getEnvConfig().clientId;
    _syncAttachment();
  }

  static final ApiConfig _instance = ApiConfig._privateConstructor();

  factory ApiConfig() {
    return _instance;
  }

  //ruoyi-vue-plus
  String _apiUrl = "";

  String _clientid = "";

  String rsaPublicKey =
      "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKoR8mX0rGKLqzcWmOzbfj64K8ZIgOdHnzkXSOVOZbFu/TJhZ7rFAN+eaGkl3C4buccQd/EjEsj9ir7ijT7h96MCAwEAAQ==";

  String? token;

  String get apiUrl => _apiUrl;

  String get clientid => _clientid;

  void setApiUrl(String apiUrl) {
    _apiUrl = apiUrl;
    _syncAttachment();
  }

  void _syncAttachment() {
    AttachmentConfig().setDownloadIpPort(apiUrl);
    AttachmentConfig().setDownloadApiPart("");
  }
}

abstract class OnSuccess<T> {}

abstract class OnError<int, String> {
  OnError._() {
    throw new UnsupportedError("OnSuccess can't be instantiated");
  }
}
