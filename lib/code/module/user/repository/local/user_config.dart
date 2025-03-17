import 'package:ruoyi_plus_flutter/code/lib/db_base/dp_manager.dart';

class UserConfig extends DpManager {
  UserConfig._privateConstructor() : super("user_config");

  static final UserConfig _instance = UserConfig._privateConstructor();

  factory UserConfig() {
    return _instance;
  }

  /// 保存是否保存密码
  void saveIsSavePassword(bool value) {
    getDp().putValue("savePassword", value);
  }

  /// 是否保存密码
  bool isSavePassword() {
    return getDp().getBool("savePassword", defValue: true) ?? false;
  }

  /// 保存是否自动登录
  void saveIsAutoLogin(bool value) {
    getDp().putValue("autoLogin", value);
  }

  ///是否自动登录
  bool isAutoLogin() {
    return getDp().getBool("autoLogin", defValue: false) ?? false;
  }

  ///设置租户
  void saveTenantId(String? tenantId) {
    getDp().putValue("tenantId", tenantId ?? "");
  }

  /// 获取保存的租户
  String? getTenantId() {
    return getDp().getString("tenantId");
  }

  ///设置租户Name
  void saveTenantName(String? tenantName) {
    getDp().putValue("tenantName", tenantName ?? "");
  }

  /// 获取保存的租户Name
  String? getTenantName() {
    return getDp().getString("tenantName");
  }

  ///设置账号
  void saveAccount(String? account) {
    getDp().putValue("account", account ?? "");
  }

  /// 获取保存的账户
  String? getAccount() {
    return getDp().getString("account");
  }

  ///设置密码
  void savePassword(String? password) {
    getDp().putValue("password", password ?? "");
  }

  /// 获取保存的密码
  String? getPassword() {
    return getDp().getString("password");
  }
}
