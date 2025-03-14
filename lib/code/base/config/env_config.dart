///@author sunlunchang
///环境配置
abstract class EnvConfig {
  final bool _release = false;

  bool get isRelease => _release;

  String get apiUrl;

  String get clientId;

  bool get tenantEnable;

  String get defTenantId => "000000";

  static const String _active = "dev";
  static final Map<String, EnvConfig> _envConfigMap = {
    "dev": _DevEnvConfig(),
    "devJia": _DevJiaEnvConfig(),
    "devXb": _DevXbEnvConfig(),
    "devJie": _DevJieEnvConfig(),
    "demo": _DemoEnvConfig(),
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
  String get apiUrl => "http://172.18.0.29:8080";

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
  String get apiUrl => "http://192.168.31.217:8080";

  @override
  String get clientId => "428a8310cd442757ae699df5d894f051";

  @override
  bool get tenantEnable => true;
}

class _DevJiaEnvConfig extends EnvConfig {
  _DevJiaEnvConfig._privateConstructor() {}

  static final _DevJiaEnvConfig _instance = _DevJiaEnvConfig._privateConstructor();

  factory _DevJiaEnvConfig() {
    return _instance;
  }

  @override
  String get apiUrl => "http://192.168.1.11:8080";

  @override
  String get clientId => "428a8310cd442757ae699df5d894f051";

  @override
  bool get tenantEnable => true;
}

class _DevJieEnvConfig extends EnvConfig {
  _DevJieEnvConfig._privateConstructor() {}

  static final _DevJieEnvConfig _instance = _DevJieEnvConfig._privateConstructor();

  factory _DevJieEnvConfig() {
    return _instance;
  }

  @override
  String get apiUrl => "http://192.168.10.79:8080";

  @override
  String get clientId => "428a8310cd442757ae699df5d894f051";

  @override
  bool get tenantEnable => true;
}

class _DemoEnvConfig extends EnvConfig {
  _DemoEnvConfig._privateConstructor() {}

  static final _DemoEnvConfig _instance = _DemoEnvConfig._privateConstructor();

  factory _DemoEnvConfig() {
    return _instance;
  }

  @override
  String get apiUrl => "http://106.119.167.29:90/prod-api";

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
