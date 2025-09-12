import 'auth_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AuthLocalizationsEn extends AuthLocalizations {
  AuthLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get auth_divide_text => '-----------------------------';

  @override
  String get auth_label_login => '登录';

  @override
  String get auth_label_tenant => '租户';

  @override
  String get auth_label_select_tenant => '请选择租户';

  @override
  String get auth_label_tenant_get_info_error => '获取租户信息失败';

  @override
  String get auth_label_account => '账号';

  @override
  String get auth_label_input_account => '请输入账号';

  @override
  String get auth_label_password => '密码';

  @override
  String get auth_label_input_password => '请输入密码';

  @override
  String get auth_label_captcha_code => '验证码';

  @override
  String get auth_label_input_captcha_code => '请输入验证码';

  @override
  String get auth_label_save_password => '保存密码';

  @override
  String get auth_label_auto_login => '自动登录';

  @override
  String get auth_label_sign_out => '退出登录';

  @override
  String get auth_label_logging_in => '正在登录';

  @override
  String get auth_toast_login_login_successful => '登录成功';

  @override
  String get auth_toast_login_login_failed => '登录失败';

  @override
  String get auth_label_tenant_not_empty_hint => '机构不能为空';

  @override
  String get auth_label_account_not_empty_hint => '账号不能为空';

  @override
  String get auth_label_password_bot_empty_hint => '密码不能为空';

  @override
  String get auth_label_captcha_code_empty_hint => '验证码不能为空';
}
