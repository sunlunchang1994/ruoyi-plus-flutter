import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'base_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of BaseLocalizations
/// returned by `BaseLocalizations.of(context)`.
///
/// Applications need to include `BaseLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/base_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: BaseLocalizations.localizationsDelegates,
///   supportedLocales: BaseLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the BaseLocalizations.supportedLocales
/// property.
abstract class BaseLocalizations {
  BaseLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static BaseLocalizations? of(BuildContext context) {
    return Localizations.of<BaseLocalizations>(context, BaseLocalizations);
  }

  static const LocalizationsDelegate<BaseLocalizations> delegate = _BaseLocalizationsDelegate();

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

  /// No description provided for @app_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get app_divide_text;

  /// No description provided for @app_label_location_permission_hint.
  ///
  /// In en, this message translates to:
  /// **'我们需要获取位置权限才能进定位！'**
  String get app_label_location_permission_hint;

  /// No description provided for @app_label_location_permission_request_hint.
  ///
  /// In en, this message translates to:
  /// **'使用该功能需要位置权限，请授予允许！'**
  String get app_label_location_permission_request_hint;

  /// No description provided for @app_label_location_permission_request_hint_denied.
  ///
  /// In en, this message translates to:
  /// **'您没有授予位置权限，此功能将无法使用！'**
  String get app_label_location_permission_request_hint_denied;

  /// No description provided for @app_label_start_time_less_than_end_time.
  ///
  /// In en, this message translates to:
  /// **'开始时间必须小于结束时间'**
  String get app_label_start_time_less_than_end_time;

  /// No description provided for @app_label_end_time_more_than_the_start_time.
  ///
  /// In en, this message translates to:
  /// **'结束时间必须大于开始时间'**
  String get app_label_end_time_more_than_the_start_time;

  /// No description provided for @app_label_please_choose.
  ///
  /// In en, this message translates to:
  /// **'请选择'**
  String get app_label_please_choose;

  /// No description provided for @app_label_please_input.
  ///
  /// In en, this message translates to:
  /// **'请输入'**
  String get app_label_please_input;

  /// No description provided for @app_label_not_completed.
  ///
  /// In en, this message translates to:
  /// **'待完善'**
  String get app_label_not_completed;

  /// No description provided for @app_label_unfilled.
  ///
  /// In en, this message translates to:
  /// **'未填写'**
  String get app_label_unfilled;

  /// No description provided for @app_label_required_information_cannot_be_empty.
  ///
  /// In en, this message translates to:
  /// **'必要参数不能为空'**
  String get app_label_required_information_cannot_be_empty;

  /// No description provided for @app_label_form_check_hint.
  ///
  /// In en, this message translates to:
  /// **'请检查表单'**
  String get app_label_form_check_hint;

  /// No description provided for @app_label_data_save_prompt.
  ///
  /// In en, this message translates to:
  /// **'您的修改未保存，确认要退出吗？'**
  String get app_label_data_save_prompt;

  /// No description provided for @app_label_data_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除该%s信息吗？'**
  String get app_label_data_del_prompt;

  /// No description provided for @app_label_404.
  ///
  /// In en, this message translates to:
  /// **'404'**
  String get app_label_404;

  /// No description provided for @app_label_404_msg.
  ///
  /// In en, this message translates to:
  /// **'抱歉，页面未找到！'**
  String get app_label_404_msg;

  /// No description provided for @app_label_agree.
  ///
  /// In en, this message translates to:
  /// **'同意'**
  String get app_label_agree;

  /// No description provided for @app_label_select_all.
  ///
  /// In en, this message translates to:
  /// **'全选'**
  String get app_label_select_all;

  /// No description provided for @app_label_unselect_all.
  ///
  /// In en, this message translates to:
  /// **'全不选'**
  String get app_label_unselect_all;

  /// No description provided for @app_label_pass.
  ///
  /// In en, this message translates to:
  /// **'通过'**
  String get app_label_pass;

  /// No description provided for @app_label_refuse.
  ///
  /// In en, this message translates to:
  /// **'拒绝'**
  String get app_label_refuse;

  /// No description provided for @app_label_remark.
  ///
  /// In en, this message translates to:
  /// **'备注'**
  String get app_label_remark;

  /// No description provided for @app_label_department_x.
  ///
  /// In en, this message translates to:
  /// **'部门：%s'**
  String get app_label_department_x;

  /// No description provided for @app_label_department.
  ///
  /// In en, this message translates to:
  /// **'部门'**
  String get app_label_department;

  /// No description provided for @app_label_post_x.
  ///
  /// In en, this message translates to:
  /// **'岗位：%s'**
  String get app_label_post_x;

  /// No description provided for @app_label_post.
  ///
  /// In en, this message translates to:
  /// **'岗位'**
  String get app_label_post;

  /// No description provided for @app_label_am.
  ///
  /// In en, this message translates to:
  /// **'上午'**
  String get app_label_am;

  /// No description provided for @app_label_pm.
  ///
  /// In en, this message translates to:
  /// **'下午'**
  String get app_label_pm;

  /// No description provided for @app_label_am_pm_full.
  ///
  /// In en, this message translates to:
  /// **'全天'**
  String get app_label_am_pm_full;

  /// No description provided for @app_label_am_pm_error.
  ///
  /// In en, this message translates to:
  /// **'错误'**
  String get app_label_am_pm_error;

  /// No description provided for @app_label_no_location_information.
  ///
  /// In en, this message translates to:
  /// **'未获取到位置信息'**
  String get app_label_no_location_information;

  /// No description provided for @app_label_please_add_attachments.
  ///
  /// In en, this message translates to:
  /// **'请添加附件'**
  String get app_label_please_add_attachments;

  /// No description provided for @app_label_un_submitted.
  ///
  /// In en, this message translates to:
  /// **'未提交'**
  String get app_label_un_submitted;

  /// No description provided for @app_label_starting_time.
  ///
  /// In en, this message translates to:
  /// **'开始时间'**
  String get app_label_starting_time;

  /// No description provided for @app_label_end_time.
  ///
  /// In en, this message translates to:
  /// **'结束时间'**
  String get app_label_end_time;

  /// No description provided for @app_label_personal_information.
  ///
  /// In en, this message translates to:
  /// **'个人信息'**
  String get app_label_personal_information;

  /// No description provided for @app_label_logging_in.
  ///
  /// In en, this message translates to:
  /// **'正在登录'**
  String get app_label_logging_in;

  /// No description provided for @app_toast_login_login_successful.
  ///
  /// In en, this message translates to:
  /// **'登录成功'**
  String get app_toast_login_login_successful;

  /// No description provided for @app_toast_login_login_failed.
  ///
  /// In en, this message translates to:
  /// **'登录失败'**
  String get app_toast_login_login_failed;

  /// No description provided for @app_label_login_normal_unauthorized.
  ///
  /// In en, this message translates to:
  /// **'登录失效，请重新登录！'**
  String get app_label_login_normal_unauthorized;

  /// No description provided for @app_label_show_sort.
  ///
  /// In en, this message translates to:
  /// **'显示排序'**
  String get app_label_show_sort;

  /// No description provided for @app_label_status.
  ///
  /// In en, this message translates to:
  /// **'状态'**
  String get app_label_status;

  /// No description provided for @app_label_photograph.
  ///
  /// In en, this message translates to:
  /// **'拍照'**
  String get app_label_photograph;

  /// No description provided for @app_label_photo_album.
  ///
  /// In en, this message translates to:
  /// **'相册'**
  String get app_label_photo_album;

  /// No description provided for @app_label_image_crop.
  ///
  /// In en, this message translates to:
  /// **'裁剪'**
  String get app_label_image_crop;

  /// No description provided for @app_label_select_file.
  ///
  /// In en, this message translates to:
  /// **'选择文件'**
  String get app_label_select_file;

  /// No description provided for @app_label_crop_ing.
  ///
  /// In en, this message translates to:
  /// **'正在裁剪...'**
  String get app_label_crop_ing;

  /// No description provided for @app_label_open_url_in_sys_browser.
  ///
  /// In en, this message translates to:
  /// **'在系统浏览器打开'**
  String get app_label_open_url_in_sys_browser;
}

class _BaseLocalizationsDelegate extends LocalizationsDelegate<BaseLocalizations> {
  const _BaseLocalizationsDelegate();

  @override
  Future<BaseLocalizations> load(Locale locale) {
    return SynchronousFuture<BaseLocalizations>(lookupBaseLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_BaseLocalizationsDelegate old) => false;
}

BaseLocalizations lookupBaseLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return BaseLocalizationsEn();
  }

  throw FlutterError(
    'BaseLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
