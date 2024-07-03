import 'package:flustars_flutter3/flustars_flutter3.dart';

class SpUserConfig {

  /// 保存是否保存密码
  static void saveIsSavePassword(bool value) {
    SpUtil.putBool("savePassword", value);
  }

  /// 是否保存密码
  static bool isSavePassword() {
    return SpUtil.getBool("savePassword", defValue: true)??false;
  }

  /// 保存是否自动登录
  static void saveIsAutoLogin(bool value) {
    SpUtil.putBool("autoLogin", value);
  }

  ///是否自动登录
  static bool isAutoLogin() {
    return SpUtil.getBool("autoLogin", defValue: false)??false;
  }

  ///设置账号
  static void saveAccount(String? account) {
    SpUtil.putString("account", account??"");
  }

  /// 获取保存的账户
  static String? getAccount() {
    return SpUtil.getString("account");
  }

  ///设置密码
  static void savePassword(String? password) {
    SpUtil.putString("password", password??"");
  }

  /// 获取保存的密码
  static String? getPassword() {
    return SpUtil.getString("password");
  }

}
