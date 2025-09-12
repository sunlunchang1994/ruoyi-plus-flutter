import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'auth_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AuthLocalizations
/// returned by `AuthLocalizations.of(context)`.
///
/// Applications need to include `AuthLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/auth_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AuthLocalizations.localizationsDelegates,
///   supportedLocales: AuthLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AuthLocalizations.supportedLocales
/// property.
abstract class AuthLocalizations {
  AuthLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AuthLocalizations? of(BuildContext context) {
    return Localizations.of<AuthLocalizations>(context, AuthLocalizations);
  }

  static const LocalizationsDelegate<AuthLocalizations> delegate = _AuthLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @auth_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get auth_divide_text;

  /// No description provided for @auth_label_login.
  ///
  /// In en, this message translates to:
  /// **'登录'**
  String get auth_label_login;

  /// No description provided for @auth_label_tenant.
  ///
  /// In en, this message translates to:
  /// **'租户'**
  String get auth_label_tenant;

  /// No description provided for @auth_label_select_tenant.
  ///
  /// In en, this message translates to:
  /// **'请选择租户'**
  String get auth_label_select_tenant;

  /// No description provided for @auth_label_tenant_get_info_error.
  ///
  /// In en, this message translates to:
  /// **'获取租户信息失败'**
  String get auth_label_tenant_get_info_error;

  /// No description provided for @auth_label_account.
  ///
  /// In en, this message translates to:
  /// **'账号'**
  String get auth_label_account;

  /// No description provided for @auth_label_input_account.
  ///
  /// In en, this message translates to:
  /// **'请输入账号'**
  String get auth_label_input_account;

  /// No description provided for @auth_label_password.
  ///
  /// In en, this message translates to:
  /// **'密码'**
  String get auth_label_password;

  /// No description provided for @auth_label_input_password.
  ///
  /// In en, this message translates to:
  /// **'请输入密码'**
  String get auth_label_input_password;

  /// No description provided for @auth_label_captcha_code.
  ///
  /// In en, this message translates to:
  /// **'验证码'**
  String get auth_label_captcha_code;

  /// No description provided for @auth_label_input_captcha_code.
  ///
  /// In en, this message translates to:
  /// **'请输入验证码'**
  String get auth_label_input_captcha_code;

  /// No description provided for @auth_label_save_password.
  ///
  /// In en, this message translates to:
  /// **'保存密码'**
  String get auth_label_save_password;

  /// No description provided for @auth_label_auto_login.
  ///
  /// In en, this message translates to:
  /// **'自动登录'**
  String get auth_label_auto_login;

  /// No description provided for @auth_label_sign_out.
  ///
  /// In en, this message translates to:
  /// **'退出登录'**
  String get auth_label_sign_out;

  /// No description provided for @auth_label_logging_in.
  ///
  /// In en, this message translates to:
  /// **'正在登录'**
  String get auth_label_logging_in;

  /// No description provided for @auth_toast_login_login_successful.
  ///
  /// In en, this message translates to:
  /// **'登录成功'**
  String get auth_toast_login_login_successful;

  /// No description provided for @auth_toast_login_login_failed.
  ///
  /// In en, this message translates to:
  /// **'登录失败'**
  String get auth_toast_login_login_failed;

  /// No description provided for @auth_label_tenant_not_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'机构不能为空'**
  String get auth_label_tenant_not_empty_hint;

  /// No description provided for @auth_label_account_not_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'账号不能为空'**
  String get auth_label_account_not_empty_hint;

  /// No description provided for @auth_label_password_bot_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'密码不能为空'**
  String get auth_label_password_bot_empty_hint;

  /// No description provided for @auth_label_captcha_code_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'验证码不能为空'**
  String get auth_label_captcha_code_empty_hint;
}

class _AuthLocalizationsDelegate extends LocalizationsDelegate<AuthLocalizations> {
  const _AuthLocalizationsDelegate();

  @override
  Future<AuthLocalizations> load(Locale locale) {
    return SynchronousFuture<AuthLocalizations>(lookupAuthLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AuthLocalizationsDelegate old) => false;
}

AuthLocalizations lookupAuthLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AuthLocalizationsEn();
  }

  throw FlutterError(
    'AuthLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
