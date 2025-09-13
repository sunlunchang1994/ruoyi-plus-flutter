import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'user_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of UserLocalizations
/// returned by `UserLocalizations.of(context)`.
///
/// Applications need to include `UserLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/user_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: UserLocalizations.localizationsDelegates,
///   supportedLocales: UserLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the UserLocalizations.supportedLocales
/// property.
abstract class UserLocalizations {
  UserLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static UserLocalizations? of(BuildContext context) {
    return Localizations.of<UserLocalizations>(context, UserLocalizations);
  }

  static const LocalizationsDelegate<UserLocalizations> delegate = _UserLocalizationsDelegate();

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

  /// No description provided for @user_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get user_divide_text;

  /// No description provided for @user_label_setting.
  ///
  /// In en, this message translates to:
  /// **'设置'**
  String get user_label_setting;

  /// No description provided for @user_label_login.
  ///
  /// In en, this message translates to:
  /// **'登录'**
  String get user_label_login;

  /// No description provided for @user_label_tenant.
  ///
  /// In en, this message translates to:
  /// **'租户'**
  String get user_label_tenant;

  /// No description provided for @user_label_select_tenant.
  ///
  /// In en, this message translates to:
  /// **'请选择租户'**
  String get user_label_select_tenant;

  /// No description provided for @user_label_tenant_get_info_error.
  ///
  /// In en, this message translates to:
  /// **'获取租户信息失败'**
  String get user_label_tenant_get_info_error;

  /// No description provided for @user_label_account.
  ///
  /// In en, this message translates to:
  /// **'账号'**
  String get user_label_account;

  /// No description provided for @user_label_input_account.
  ///
  /// In en, this message translates to:
  /// **'请输入账号'**
  String get user_label_input_account;

  /// No description provided for @user_label_password.
  ///
  /// In en, this message translates to:
  /// **'密码'**
  String get user_label_password;

  /// No description provided for @user_label_input_password.
  ///
  /// In en, this message translates to:
  /// **'请输入密码'**
  String get user_label_input_password;

  /// No description provided for @user_label_captcha_code.
  ///
  /// In en, this message translates to:
  /// **'验证码'**
  String get user_label_captcha_code;

  /// No description provided for @user_label_input_captcha_code.
  ///
  /// In en, this message translates to:
  /// **'请输入验证码'**
  String get user_label_input_captcha_code;

  /// No description provided for @user_label_save_password.
  ///
  /// In en, this message translates to:
  /// **'保存密码'**
  String get user_label_save_password;

  /// No description provided for @user_label_auto_login.
  ///
  /// In en, this message translates to:
  /// **'自动登录'**
  String get user_label_auto_login;

  /// No description provided for @user_label_sign_out.
  ///
  /// In en, this message translates to:
  /// **'退出登录'**
  String get user_label_sign_out;

  /// No description provided for @user_label_logging_in.
  ///
  /// In en, this message translates to:
  /// **'正在登录'**
  String get user_label_logging_in;

  /// No description provided for @user_toast_login_login_successful.
  ///
  /// In en, this message translates to:
  /// **'登录成功'**
  String get user_toast_login_login_successful;

  /// No description provided for @user_toast_login_login_failed.
  ///
  /// In en, this message translates to:
  /// **'登录失败'**
  String get user_toast_login_login_failed;

  /// No description provided for @user_label_pet_name.
  ///
  /// In en, this message translates to:
  /// **'昵称'**
  String get user_label_pet_name;

  /// No description provided for @user_label_avatar.
  ///
  /// In en, this message translates to:
  /// **'头像'**
  String get user_label_avatar;

  /// No description provided for @user_label_edit_pass_word.
  ///
  /// In en, this message translates to:
  /// **'修改密码'**
  String get user_label_edit_pass_word;

  /// No description provided for @user_label_old_password.
  ///
  /// In en, this message translates to:
  /// **'原密码'**
  String get user_label_old_password;

  /// No description provided for @user_label_new_password.
  ///
  /// In en, this message translates to:
  /// **'新密码'**
  String get user_label_new_password;

  /// No description provided for @user_label_new_password_input.
  ///
  /// In en, this message translates to:
  /// **'请输入新密码'**
  String get user_label_new_password_input;

  /// No description provided for @user_label_verify_new_password.
  ///
  /// In en, this message translates to:
  /// **'确认新密码'**
  String get user_label_verify_new_password;

  /// No description provided for @user_label_verify_new_password_error.
  ///
  /// In en, this message translates to:
  /// **'两次新密码不一致，请重新出入'**
  String get user_label_verify_new_password_error;

  /// No description provided for @user_label_cell_phone.
  ///
  /// In en, this message translates to:
  /// **'手机'**
  String get user_label_cell_phone;

  /// No description provided for @user_toast_base_permission.
  ///
  /// In en, this message translates to:
  /// **'未开启基本权限,请授予该权限！'**
  String get user_toast_base_permission;

  /// No description provided for @user_toast_base_permission_go_setting.
  ///
  /// In en, this message translates to:
  /// **'未开启基本权限,请手动到设置去开启权限'**
  String get user_toast_base_permission_go_setting;

  /// No description provided for @user_toast_click_again_to_return_to_the_desktop.
  ///
  /// In en, this message translates to:
  /// **'再次点击回到桌面'**
  String get user_toast_click_again_to_return_to_the_desktop;

  /// No description provided for @user_toast_data_init_error.
  ///
  /// In en, this message translates to:
  /// **'数据初始化失败，请卸载重装此APP'**
  String get user_toast_data_init_error;

  /// No description provided for @user_label_stay_tuned.
  ///
  /// In en, this message translates to:
  /// **'敬请期待'**
  String get user_label_stay_tuned;

  /// No description provided for @user_label_my_qr_code.
  ///
  /// In en, this message translates to:
  /// **'我的二维码'**
  String get user_label_my_qr_code;

  /// No description provided for @user_label_check_for_updates.
  ///
  /// In en, this message translates to:
  /// **'检查更新'**
  String get user_label_check_for_updates;

  /// No description provided for @user_label_check_for_updates_ing.
  ///
  /// In en, this message translates to:
  /// **'正在获取更新信息'**
  String get user_label_check_for_updates_ing;

  /// No description provided for @user_label_check_for_updates_error.
  ///
  /// In en, this message translates to:
  /// **'获取更新信息失败'**
  String get user_label_check_for_updates_error;

  /// No description provided for @user_label_dept_list.
  ///
  /// In en, this message translates to:
  /// **'部门列表'**
  String get user_label_dept_list;

  /// No description provided for @user_label_user_info_list.
  ///
  /// In en, this message translates to:
  /// **'用户列表'**
  String get user_label_user_info_list;

  /// No description provided for @user_label_x_people.
  ///
  /// In en, this message translates to:
  /// **'%s人'**
  String get user_label_x_people;

  /// No description provided for @user_label_dept_not_found.
  ///
  /// In en, this message translates to:
  /// **'没有获取到部门信息'**
  String get user_label_dept_not_found;

  /// No description provided for @user_label_user_info_not_found.
  ///
  /// In en, this message translates to:
  /// **'没有获取到用户信息'**
  String get user_label_user_info_not_found;

  /// No description provided for @user_label_mine.
  ///
  /// In en, this message translates to:
  /// **'我的'**
  String get user_label_mine;

  /// No description provided for @user_label_avatar_crop.
  ///
  /// In en, this message translates to:
  /// **'正在裁剪头像...'**
  String get user_label_avatar_crop;

  /// No description provided for @user_label_avatar_are_uploading.
  ///
  /// In en, this message translates to:
  /// **'正在上传头像'**
  String get user_label_avatar_are_uploading;

  /// No description provided for @user_label_avatar_upload_failed.
  ///
  /// In en, this message translates to:
  /// **'上传头像失败'**
  String get user_label_avatar_upload_failed;

  /// No description provided for @user_label_avatar_uploaded_success.
  ///
  /// In en, this message translates to:
  /// **'上传头像成功'**
  String get user_label_avatar_uploaded_success;

  /// No description provided for @user_label_all_dept.
  ///
  /// In en, this message translates to:
  /// **'所有部门'**
  String get user_label_all_dept;

  /// No description provided for @user_label_top_dept.
  ///
  /// In en, this message translates to:
  /// **'顶级部门'**
  String get user_label_top_dept;

  /// No description provided for @user_label_dept_add.
  ///
  /// In en, this message translates to:
  /// **'新增部门'**
  String get user_label_dept_add;

  /// No description provided for @user_label_dept_edit.
  ///
  /// In en, this message translates to:
  /// **'修改部门信息'**
  String get user_label_dept_edit;

  /// No description provided for @user_label_dept_parent_name.
  ///
  /// In en, this message translates to:
  /// **'上级部门'**
  String get user_label_dept_parent_name;

  /// No description provided for @user_label_dept_parent_name_select.
  ///
  /// In en, this message translates to:
  /// **'选择上级部门'**
  String get user_label_dept_parent_name_select;

  /// No description provided for @user_label_dept_name.
  ///
  /// In en, this message translates to:
  /// **'部门名称'**
  String get user_label_dept_name;

  /// No description provided for @user_label_dept_category.
  ///
  /// In en, this message translates to:
  /// **'类别编码'**
  String get user_label_dept_category;

  /// No description provided for @user_label_dept_leader.
  ///
  /// In en, this message translates to:
  /// **'负责人'**
  String get user_label_dept_leader;

  /// No description provided for @user_label_dept_leader_select.
  ///
  /// In en, this message translates to:
  /// **'选择负责人'**
  String get user_label_dept_leader_select;

  /// No description provided for @user_label_dept_contact_number.
  ///
  /// In en, this message translates to:
  /// **'联系电话'**
  String get user_label_dept_contact_number;

  /// No description provided for @user_label_dept_contact_email.
  ///
  /// In en, this message translates to:
  /// **'邮箱'**
  String get user_label_dept_contact_email;

  /// No description provided for @user_label_dept_status.
  ///
  /// In en, this message translates to:
  /// **'部门状态'**
  String get user_label_dept_status;

  /// No description provided for @user_label_dept_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除名称为%s的部门信息吗？'**
  String get user_label_dept_del_prompt;

  /// No description provided for @user_label_dept_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的部门'**
  String get user_label_dept_del_select_empty;

  /// No description provided for @user_label_select_x.
  ///
  /// In en, this message translates to:
  /// **'选择%s'**
  String get user_label_select_x;

  /// No description provided for @user_label_tenant_not_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'机构不能为空'**
  String get user_label_tenant_not_empty_hint;

  /// No description provided for @user_label_account_not_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'账号不能为空'**
  String get user_label_account_not_empty_hint;

  /// No description provided for @user_label_password_bot_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'密码不能为空'**
  String get user_label_password_bot_empty_hint;

  /// No description provided for @user_label_captcha_code_empty_hint.
  ///
  /// In en, this message translates to:
  /// **'验证码不能为空'**
  String get user_label_captcha_code_empty_hint;

  /// No description provided for @user_label_dept_select.
  ///
  /// In en, this message translates to:
  /// **'选择部门'**
  String get user_label_dept_select;

  /// No description provided for @user_label_user_owner_dept.
  ///
  /// In en, this message translates to:
  /// **'所属部门'**
  String get user_label_user_owner_dept;

  /// No description provided for @user_label_user_owner_dept_select.
  ///
  /// In en, this message translates to:
  /// **'选择所属部门'**
  String get user_label_user_owner_dept_select;

  /// No description provided for @user_label_user.
  ///
  /// In en, this message translates to:
  /// **'用户'**
  String get user_label_user;

  /// No description provided for @user_label_user_name.
  ///
  /// In en, this message translates to:
  /// **'用户名称'**
  String get user_label_user_name;

  /// No description provided for @user_label_nike_name.
  ///
  /// In en, this message translates to:
  /// **'用户昵称'**
  String get user_label_nike_name;

  /// No description provided for @user_label_phone_number.
  ///
  /// In en, this message translates to:
  /// **'手机号码'**
  String get user_label_phone_number;

  /// No description provided for @user_label_mailbox.
  ///
  /// In en, this message translates to:
  /// **'邮箱'**
  String get user_label_mailbox;

  /// No description provided for @user_label_sex.
  ///
  /// In en, this message translates to:
  /// **'性别'**
  String get user_label_sex;

  /// No description provided for @user_label_sex_select_prompt.
  ///
  /// In en, this message translates to:
  /// **'请选择性别'**
  String get user_label_sex_select_prompt;

  /// No description provided for @user_label_status.
  ///
  /// In en, this message translates to:
  /// **'状态'**
  String get user_label_status;

  /// No description provided for @user_label_user_add.
  ///
  /// In en, this message translates to:
  /// **'新增用户'**
  String get user_label_user_add;

  /// No description provided for @user_label_user_edit.
  ///
  /// In en, this message translates to:
  /// **'修改用户信息'**
  String get user_label_user_edit;

  /// No description provided for @user_label_role_name_select.
  ///
  /// In en, this message translates to:
  /// **'选择角色'**
  String get user_label_role_name_select;

  /// No description provided for @user_label_post_name_select.
  ///
  /// In en, this message translates to:
  /// **'选择岗位'**
  String get user_label_post_name_select;

  /// No description provided for @user_label_search_user.
  ///
  /// In en, this message translates to:
  /// **'搜索用户'**
  String get user_label_search_user;

  /// No description provided for @user_toast_user_super_edit_refuse.
  ///
  /// In en, this message translates to:
  /// **'该用户不允许修改'**
  String get user_toast_user_super_edit_refuse;

  /// No description provided for @user_label_data_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除姓名为%s的用户信息吗？'**
  String get user_label_data_del_prompt;

  /// No description provided for @user_label_data_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的用户'**
  String get user_label_data_del_select_empty;

  /// No description provided for @user_label_reset_password.
  ///
  /// In en, this message translates to:
  /// **'重置密码'**
  String get user_label_reset_password;

  /// No description provided for @user_label_reset_password_success.
  ///
  /// In en, this message translates to:
  /// **'重置成功'**
  String get user_label_reset_password_success;

  /// No description provided for @user_label_reset_password_fail.
  ///
  /// In en, this message translates to:
  /// **'重置失败'**
  String get user_label_reset_password_fail;

  /// No description provided for @user_label_post.
  ///
  /// In en, this message translates to:
  /// **'岗位'**
  String get user_label_post;

  /// No description provided for @user_label_post_owner_dept.
  ///
  /// In en, this message translates to:
  /// **'所属部门'**
  String get user_label_post_owner_dept;

  /// No description provided for @user_label_post_owner_dept_select.
  ///
  /// In en, this message translates to:
  /// **'选择所属部门'**
  String get user_label_post_owner_dept_select;

  /// No description provided for @user_label_post_info_not_found.
  ///
  /// In en, this message translates to:
  /// **'没有获取到岗位信息'**
  String get user_label_post_info_not_found;

  /// No description provided for @user_label_post_add.
  ///
  /// In en, this message translates to:
  /// **'新增岗位'**
  String get user_label_post_add;

  /// No description provided for @user_label_post_edit.
  ///
  /// In en, this message translates to:
  /// **'修改岗位信息'**
  String get user_label_post_edit;

  /// No description provided for @user_label_post_name.
  ///
  /// In en, this message translates to:
  /// **'岗位名称'**
  String get user_label_post_name;

  /// No description provided for @user_label_post_code.
  ///
  /// In en, this message translates to:
  /// **'岗位编码'**
  String get user_label_post_code;

  /// No description provided for @user_label_post_category.
  ///
  /// In en, this message translates to:
  /// **'类别编码'**
  String get user_label_post_category;

  /// No description provided for @user_label_post_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除名称为%s的岗位信息吗？'**
  String get user_label_post_del_prompt;

  /// No description provided for @user_label_post_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的岗位'**
  String get user_label_post_del_select_empty;

  /// No description provided for @user_label_role.
  ///
  /// In en, this message translates to:
  /// **'角色'**
  String get user_label_role;

  /// No description provided for @user_label_search_role.
  ///
  /// In en, this message translates to:
  /// **'搜索角色'**
  String get user_label_search_role;

  /// No description provided for @user_label_role_name.
  ///
  /// In en, this message translates to:
  /// **'角色名称'**
  String get user_label_role_name;

  /// No description provided for @user_label_role_key.
  ///
  /// In en, this message translates to:
  /// **'权限字符'**
  String get user_label_role_key;

  /// No description provided for @user_label_menu_permission.
  ///
  /// In en, this message translates to:
  /// **'菜单权限'**
  String get user_label_menu_permission;

  /// No description provided for @user_label_data_permission.
  ///
  /// In en, this message translates to:
  /// **'数据权限'**
  String get user_label_data_permission;

  /// No description provided for @user_label_data_permission_select.
  ///
  /// In en, this message translates to:
  /// **'请选择数据权限'**
  String get user_label_data_permission_select;

  /// No description provided for @user_label_role_add.
  ///
  /// In en, this message translates to:
  /// **'新增角色'**
  String get user_label_role_add;

  /// No description provided for @user_label_role_edit.
  ///
  /// In en, this message translates to:
  /// **'修改角色信息'**
  String get user_label_role_edit;

  /// No description provided for @user_toast_role_super_edit_refuse.
  ///
  /// In en, this message translates to:
  /// **'该角色不允许修改'**
  String get user_toast_role_super_edit_refuse;

  /// No description provided for @user_label_menu_permission_select.
  ///
  /// In en, this message translates to:
  /// **'配置菜单权限'**
  String get user_label_menu_permission_select;

  /// No description provided for @user_label_menu_permission_select_result.
  ///
  /// In en, this message translates to:
  /// **'已配置%s项菜单，点击查看'**
  String get user_label_menu_permission_select_result;

  /// No description provided for @user_label_menu_permission_select_result2.
  ///
  /// In en, this message translates to:
  /// **'已配置多个菜单项，点击查看'**
  String get user_label_menu_permission_select_result2;

  /// No description provided for @user_label_role_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除名称为%s的角色信息吗？'**
  String get user_label_role_del_prompt;

  /// No description provided for @user_label_role_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的角色'**
  String get user_label_role_del_select_empty;
}

class _UserLocalizationsDelegate extends LocalizationsDelegate<UserLocalizations> {
  const _UserLocalizationsDelegate();

  @override
  Future<UserLocalizations> load(Locale locale) {
    return SynchronousFuture<UserLocalizations>(lookupUserLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_UserLocalizationsDelegate old) => false;
}

UserLocalizations lookupUserLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return UserLocalizationsEn();
  }

  throw FlutterError(
    'UserLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
