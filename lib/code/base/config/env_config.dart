import '../../extras/component/attachment/utils/attachment_config.dart';
import 'package:flutter_slc_boxes/flutter/slc/network/api_constant.dart';

///@Author sunlunchang
///环境配置
abstract class EnvConfig {
  final bool _release = true;

  bool get isRelease => _release;

  String get apiUrl;

  String get clientId;

  bool get tenantEnable;

  static const String _active = "devXb";
  static final Map<String, EnvConfig> _envConfigMap = {
    "dev": _DevEnvConfig(),
    "devXb": _DevXbEnvConfig(),
    "prod": _ProdEnvConfig(),
  };

  static EnvConfig getEnvConfig() {
    return _envConfigMap[_active] ?? _DevEnvConfig();
  }
}

class _DevEnvConfig extends EnvConfig {
  _DevEnvConfig._privateConstructor() {}

  static final _DevEnvConfig _instance = _DevEnvConfig._privateConstructor();

  factory _DevEnvConfig() {
    return _instance;
  }

  @override
  String get apiUrl => "http://192.168.166.66:8080";

  @override
  String get clientId => "428a8310cd442757ae699df5d894f051";

  @override
  bool get tenantEnable => true;
}

class _DevXbEnvConfig extends EnvConfig {
  _DevXbEnvConfig._privateConstructor() {}

  static final _DevXbEnvConfig _instance = _DevXbEnvConfig._privateConstructor();

  factory _DevXbEnvConfig() {
    return _instance;
  }

  @override
  String get apiUrl => "http://192.168.31.174:8080";

  @override
  String get clientId => "428a8310cd442757ae699df5d894f051";

  @override
  bool get tenantEnable => true;
}

class _ProdEnvConfig extends EnvConfig {
  _ProdEnvConfig._privateConstructor() {}

  static final _ProdEnvConfig _instance = _ProdEnvConfig._privateConstructor();

  factory _ProdEnvConfig() {
    return _instance;
  }

  @override
  String get apiUrl => "http://192.168.31.174:8080";

  @override
  String get clientId => "428a8310cd442757ae699df5d894f051";

  @override
  bool get tenantEnable => true;
}
