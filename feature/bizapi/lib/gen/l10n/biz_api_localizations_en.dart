import 'biz_api_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class BizApiLocalizationsEn extends BizApiLocalizations {
  BizApiLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get user_label_logging_in => '正在登录';

  @override
  String get user_toast_login_login_successful => '登录成功';

  @override
  String get user_toast_login_login_failed => '登录失败';
}
