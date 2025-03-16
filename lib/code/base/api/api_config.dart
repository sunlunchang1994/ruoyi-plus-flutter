import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:ruoyi_plus_flutter/code/env_config.dart';

import '../../feature/component/attachment/utils/attachment_config.dart';

import '../../lib/fast/db/dp_manager.dart';

///@author sunlunchang
///Api配置类、配置url、token等，可根据需要再此拓展
class ApiConfig extends DpManager {
  //config
  static const String SP_NAME = "api_config";
  static const String CONFIG_K_APPLY_CACHE_API = "applyCacheApi";
  static const String CONFIG_K_SERVICE_MODE = "serviceMode";
  static const String CONFIG_K_SERVICE_API_ADDRESS = "serviceApiAddress";
  static const String CONFIG_K_TOKEN = "token";

  //手动
  static const int CONFIG_V_MODE_HM = 0;

  //自动
  static const int CONFIG_V_MODE_AUTO_CURRENT = 1;
  static const int CONFIG_V_MODE_AUTO_LOCAL = 2;

  //key
  static const String KEY_TOKEN = "authorization"; //token key
  static const String KEY_CLIENT_ID = "clientid"; //客户端id
  static const String KEY_ENCRYPT_KEY = "encrypt-key"; //加密标记
  static const String KEY_APPLY_ENCRYPT = "applyEncrypt"; //应用加密

  //value
  static const int VALUE_CODE_CANCEL = -10; //客户端取消
  //客户端定义
  static const int VALUE_CODE_RESULT_UPLOAD_FAILURE = -50; //上传文件失败
  //常规
  static const int VALUE_CODE_SUCCEED = 200; //成功
  static const int VALUE_CODE_ERROR_REQUEST = 400; //错误请求
  static const int VALUE_CODE_NORMAL_UNAUTHORIZED = 401; //请求未授权
  static const int VALUE_CODE_SERVER_ERROR = 500; //服务器内部错误
  static const int VALUE_CODE_NOT_IMPLEMENTED = 501; //尚未实施
  static const String VALUE_STR_UNKNOWN_MISTAKE = "Unknown mistake";

  static const String VALUE_RSA_PUBLIC_KEY =
      "MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKoR8mX0rGKLqzcWmOzbfj64K8ZIgOdHnzkXSOVOZbFu/TJhZ7rFAN+eaGkl3C4buccQd/EjEsj9ir7ijT7h96MCAwEAAQ==";

  ApiConfig._privateConstructor() : super(SP_NAME) {
    _serviceApiAddress = EnvConfig.getEnvConfig().apiUrl;
    _clientid = EnvConfig.getEnvConfig().clientId;

    _syncAttachment();
  }

  static final ApiConfig _instance = ApiConfig._privateConstructor();

  factory ApiConfig() {
    return _instance;
  }

  String _serviceApiAddress = "";

  String _clientid = "";

  String get clientid => _clientid;

  String getServiceApiAddress() {
    if (isApplyCacheApi()) {
      return getServiceApiAddressByDp(defValue: _serviceApiAddress);
    }
    return _serviceApiAddress;
  }

  void setServiceApiAddress(String value) {
    setServiceApiAddressByDp(value, forceSave: false);
    _serviceApiAddress = value;
    _syncAttachment();
  }

  void _syncAttachment() {
    AttachmentConfig().setDownloadIpPort(_serviceApiAddress);
    AttachmentConfig().setDownloadApiPart("");
  }

  String? getToken() {
    return getDp().getString(CONFIG_K_TOKEN);
  }

  void setToken(String? token) {
    getDp().putValue(CONFIG_K_TOKEN, token);
  }

  //apply
  bool isApplyCacheApi() {
    return getDp().getBool(CONFIG_K_APPLY_CACHE_API, defValue: false)!;
  }

  void setApplyCacheApi(bool applyCacheApi) {
    getDp().putValue(CONFIG_K_APPLY_CACHE_API, applyCacheApi);
  }

  //service

  int getServiceMode({int defValue = CONFIG_V_MODE_HM}) {
    return getDp().getInt(CONFIG_K_SERVICE_MODE, defValue: defValue)!;
  }

  void setServiceMode(int value) {
    getDp().putValue(CONFIG_K_SERVICE_MODE, value);
  }

  String getServiceApiAddressByDp({String defValue = ""}) {
    return getDp().getString(CONFIG_K_SERVICE_API_ADDRESS, defValue: defValue)!;
  }

  void setServiceApiAddressByDp(String value, {bool forceSave = true}) {
    if (forceSave || TextUtil.isEmpty(getServiceApiAddressByDp())) {
      getDp().putValue(CONFIG_K_SERVICE_API_ADDRESS, value);
    }
  }
}

abstract class OnSuccess<T> {}

abstract class OnError<int, String> {
  OnError._() {
    throw new UnsupportedError("OnSuccess can't be instantiated");
  }
}
