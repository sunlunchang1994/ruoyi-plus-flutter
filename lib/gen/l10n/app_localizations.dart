import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'ruoyi-plus-flutter'**
  String get app_name;

  /// No description provided for @label_params.
  ///
  /// In en, this message translates to:
  /// **'Label{name}'**
  String label_params(Object name);

  /// No description provided for @app_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get app_divide_text;

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

  /// No description provided for @app_label_open_url_in_sys_browser.
  ///
  /// In en, this message translates to:
  /// **'在系统浏览器打开'**
  String get app_label_open_url_in_sys_browser;

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

  /// No description provided for @sys_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get sys_divide_text;

  /// No description provided for @sys_label_menu.
  ///
  /// In en, this message translates to:
  /// **'菜单'**
  String get sys_label_menu;

  /// No description provided for @sys_label_menu_add.
  ///
  /// In en, this message translates to:
  /// **'新增菜单'**
  String get sys_label_menu_add;

  /// No description provided for @sys_label_menu_edit.
  ///
  /// In en, this message translates to:
  /// **'修改菜单信息'**
  String get sys_label_menu_edit;

  /// No description provided for @sys_label_menu_father_son_linkage.
  ///
  /// In en, this message translates to:
  /// **'父子联动'**
  String get sys_label_menu_father_son_linkage;

  /// No description provided for @sys_label_menu_down_donot.
  ///
  /// In en, this message translates to:
  /// **'没有子菜单了'**
  String get sys_label_menu_down_donot;

  /// No description provided for @sys_label_menu_parent_name.
  ///
  /// In en, this message translates to:
  /// **'上级菜单'**
  String get sys_label_menu_parent_name;

  /// No description provided for @sys_label_menu_parent_name_select.
  ///
  /// In en, this message translates to:
  /// **'选择上级菜单'**
  String get sys_label_menu_parent_name_select;

  /// No description provided for @sys_label_menu_type.
  ///
  /// In en, this message translates to:
  /// **'菜单类型'**
  String get sys_label_menu_type;

  /// No description provided for @sys_label_menu_name.
  ///
  /// In en, this message translates to:
  /// **'菜单名称'**
  String get sys_label_menu_name;

  /// No description provided for @sys_label_menu_is_frame.
  ///
  /// In en, this message translates to:
  /// **'是否外链'**
  String get sys_label_menu_is_frame;

  /// No description provided for @sys_label_menu_path.
  ///
  /// In en, this message translates to:
  /// **'路由地址'**
  String get sys_label_menu_path;

  /// No description provided for @sys_label_menu_component_path.
  ///
  /// In en, this message translates to:
  /// **'组件路径'**
  String get sys_label_menu_component_path;

  /// No description provided for @sys_label_menu_permission_characters.
  ///
  /// In en, this message translates to:
  /// **'权限字符'**
  String get sys_label_menu_permission_characters;

  /// No description provided for @sys_label_menu_route_parameters.
  ///
  /// In en, this message translates to:
  /// **'路由参数'**
  String get sys_label_menu_route_parameters;

  /// No description provided for @sys_label_menu_cache_status.
  ///
  /// In en, this message translates to:
  /// **'是否缓存'**
  String get sys_label_menu_cache_status;

  /// No description provided for @sys_label_menu_display_status.
  ///
  /// In en, this message translates to:
  /// **'显示状态'**
  String get sys_label_menu_display_status;

  /// No description provided for @sys_label_menu_menu_status.
  ///
  /// In en, this message translates to:
  /// **'菜单状态'**
  String get sys_label_menu_menu_status;

  /// No description provided for @sys_label_menu_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除名称为%s的菜单吗？'**
  String get sys_label_menu_del_prompt;

  /// No description provided for @sys_label_menu_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的菜单'**
  String get sys_label_menu_del_select_empty;

  /// No description provided for @sys_label_dict_type_search_title.
  ///
  /// In en, this message translates to:
  /// **'搜索字典类型'**
  String get sys_label_dict_type_search_title;

  /// No description provided for @sys_label_dict_type.
  ///
  /// In en, this message translates to:
  /// **'字典类型'**
  String get sys_label_dict_type;

  /// No description provided for @sys_label_dict_name.
  ///
  /// In en, this message translates to:
  /// **'字典名称'**
  String get sys_label_dict_name;

  /// No description provided for @sys_label_dict_child_node.
  ///
  /// In en, this message translates to:
  /// **'子节点'**
  String get sys_label_dict_child_node;

  /// No description provided for @sys_label_dict_details.
  ///
  /// In en, this message translates to:
  /// **'字典详情'**
  String get sys_label_dict_details;

  /// No description provided for @sys_label_system_dict_edit_hint.
  ///
  /// In en, this message translates to:
  /// **'系统字典不允许修改'**
  String get sys_label_system_dict_edit_hint;

  /// No description provided for @sys_label_system_dict_remove_hint.
  ///
  /// In en, this message translates to:
  /// **'系统字典不允许删除'**
  String get sys_label_system_dict_remove_hint;

  /// No description provided for @sys_label_dict_type_add.
  ///
  /// In en, this message translates to:
  /// **'新增字典类型'**
  String get sys_label_dict_type_add;

  /// No description provided for @sys_label_dict_type_edit.
  ///
  /// In en, this message translates to:
  /// **'修改字典类型'**
  String get sys_label_dict_type_edit;

  /// No description provided for @sys_label_dict_data_search_title.
  ///
  /// In en, this message translates to:
  /// **'搜索字典数据'**
  String get sys_label_dict_data_search_title;

  /// No description provided for @sys_label_dict_data_list.
  ///
  /// In en, this message translates to:
  /// **'数据列表'**
  String get sys_label_dict_data_list;

  /// No description provided for @sys_label_dict_data_label.
  ///
  /// In en, this message translates to:
  /// **'数据标签'**
  String get sys_label_dict_data_label;

  /// No description provided for @sys_label_dict_data_value.
  ///
  /// In en, this message translates to:
  /// **'数据键值'**
  String get sys_label_dict_data_value;

  /// No description provided for @sys_label_dict_data_css_class.
  ///
  /// In en, this message translates to:
  /// **'样式属性'**
  String get sys_label_dict_data_css_class;

  /// No description provided for @sys_label_dict_data_list_style.
  ///
  /// In en, this message translates to:
  /// **'回显样式'**
  String get sys_label_dict_data_list_style;

  /// No description provided for @sys_label_dict_data_order_num.
  ///
  /// In en, this message translates to:
  /// **'显示顺序'**
  String get sys_label_dict_data_order_num;

  /// No description provided for @sys_label_dict_data_add.
  ///
  /// In en, this message translates to:
  /// **'新增字典数据'**
  String get sys_label_dict_data_add;

  /// No description provided for @sys_label_dict_data_edit.
  ///
  /// In en, this message translates to:
  /// **'修改字典数据'**
  String get sys_label_dict_data_edit;

  /// No description provided for @sys_label_dict_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除名称为%s的字典信息吗？'**
  String get sys_label_dict_del_prompt;

  /// No description provided for @sys_label_dict_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的字典'**
  String get sys_label_dict_del_select_empty;

  /// No description provided for @sys_label_config_search_title.
  ///
  /// In en, this message translates to:
  /// **'搜索配置参数'**
  String get sys_label_config_search_title;

  /// No description provided for @sys_label_config_list.
  ///
  /// In en, this message translates to:
  /// **'参数列表'**
  String get sys_label_config_list;

  /// No description provided for @sys_label_config_name.
  ///
  /// In en, this message translates to:
  /// **'参数名称'**
  String get sys_label_config_name;

  /// No description provided for @sys_label_config_key.
  ///
  /// In en, this message translates to:
  /// **'参数键名'**
  String get sys_label_config_key;

  /// No description provided for @sys_label_config_value.
  ///
  /// In en, this message translates to:
  /// **'参数键值'**
  String get sys_label_config_value;

  /// No description provided for @sys_label_config_type.
  ///
  /// In en, this message translates to:
  /// **'系统内置'**
  String get sys_label_config_type;

  /// No description provided for @sys_label_config_type_select.
  ///
  /// In en, this message translates to:
  /// **'请选择是否系统内置'**
  String get sys_label_config_type_select;

  /// No description provided for @sys_label_config_add.
  ///
  /// In en, this message translates to:
  /// **'新增参数配置'**
  String get sys_label_config_add;

  /// No description provided for @sys_label_config_edit.
  ///
  /// In en, this message translates to:
  /// **'修改参数配置'**
  String get sys_label_config_edit;

  /// No description provided for @sys_label_config_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除名称为%s的参数配置信息吗？'**
  String get sys_label_config_del_prompt;

  /// No description provided for @sys_label_config_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的参数配置'**
  String get sys_label_config_del_select_empty;

  /// No description provided for @sys_label_notice_search_title.
  ///
  /// In en, this message translates to:
  /// **'搜索配置参数'**
  String get sys_label_notice_search_title;

  /// No description provided for @sys_label_notice_type_select.
  ///
  /// In en, this message translates to:
  /// **'请选择公告类型'**
  String get sys_label_notice_type_select;

  /// No description provided for @sys_label_notice_title.
  ///
  /// In en, this message translates to:
  /// **'公告标题'**
  String get sys_label_notice_title;

  /// No description provided for @sys_label_notice_context.
  ///
  /// In en, this message translates to:
  /// **'公告内容'**
  String get sys_label_notice_context;

  /// No description provided for @sys_label_notice_type.
  ///
  /// In en, this message translates to:
  /// **'公告类型'**
  String get sys_label_notice_type;

  /// No description provided for @sys_label_notice_status.
  ///
  /// In en, this message translates to:
  /// **'公告状态'**
  String get sys_label_notice_status;

  /// No description provided for @sys_label_notice_add.
  ///
  /// In en, this message translates to:
  /// **'新增公告'**
  String get sys_label_notice_add;

  /// No description provided for @sys_label_notice_edit.
  ///
  /// In en, this message translates to:
  /// **'修改公告'**
  String get sys_label_notice_edit;

  /// No description provided for @sys_label_notice_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除标题为%s的通知公告吗？'**
  String get sys_label_notice_del_prompt;

  /// No description provided for @sys_label_notice_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的通知公告'**
  String get sys_label_notice_del_select_empty;

  /// No description provided for @sys_label_log_details.
  ///
  /// In en, this message translates to:
  /// **'日志详情'**
  String get sys_label_log_details;

  /// No description provided for @sys_label_oper_search.
  ///
  /// In en, this message translates to:
  /// **'搜索操作日志'**
  String get sys_label_oper_search;

  /// No description provided for @sys_label_oper_id.
  ///
  /// In en, this message translates to:
  /// **'日志编号'**
  String get sys_label_oper_id;

  /// No description provided for @sys_label_oper_ip.
  ///
  /// In en, this message translates to:
  /// **'操作地址'**
  String get sys_label_oper_ip;

  /// No description provided for @sys_label_oper_title.
  ///
  /// In en, this message translates to:
  /// **'系统模块'**
  String get sys_label_oper_title;

  /// No description provided for @sys_label_oper_name.
  ///
  /// In en, this message translates to:
  /// **'操作人员'**
  String get sys_label_oper_name;

  /// No description provided for @sys_label_oper_business_type.
  ///
  /// In en, this message translates to:
  /// **'类型'**
  String get sys_label_oper_business_type;

  /// No description provided for @sys_label_oper_status.
  ///
  /// In en, this message translates to:
  /// **'操作状态'**
  String get sys_label_oper_status;

  /// No description provided for @sys_label_oper_login_info.
  ///
  /// In en, this message translates to:
  /// **'登录信息'**
  String get sys_label_oper_login_info;

  /// No description provided for @sys_label_oper_request_params.
  ///
  /// In en, this message translates to:
  /// **'请求参数'**
  String get sys_label_oper_request_params;

  /// No description provided for @sys_label_oper_module.
  ///
  /// In en, this message translates to:
  /// **'操作模块'**
  String get sys_label_oper_module;

  /// No description provided for @sys_label_oper_method.
  ///
  /// In en, this message translates to:
  /// **'操作方法'**
  String get sys_label_oper_method;

  /// No description provided for @sys_label_oper_request_info.
  ///
  /// In en, this message translates to:
  /// **'请求信息'**
  String get sys_label_oper_request_info;

  /// No description provided for @sys_label_oper_result.
  ///
  /// In en, this message translates to:
  /// **'返回参数'**
  String get sys_label_oper_result;

  /// No description provided for @sys_label_oper_cost_time.
  ///
  /// In en, this message translates to:
  /// **'消耗时间'**
  String get sys_label_oper_cost_time;

  /// No description provided for @sys_label_oper_time.
  ///
  /// In en, this message translates to:
  /// **'操作时间'**
  String get sys_label_oper_time;

  /// No description provided for @sys_label_logininfor_search.
  ///
  /// In en, this message translates to:
  /// **'搜索登录日志'**
  String get sys_label_logininfor_search;

  /// No description provided for @sys_label_logininfor_id.
  ///
  /// In en, this message translates to:
  /// **'访问编号'**
  String get sys_label_logininfor_id;

  /// No description provided for @sys_label_logininfor_ip.
  ///
  /// In en, this message translates to:
  /// **'登录地址'**
  String get sys_label_logininfor_ip;

  /// No description provided for @sys_label_logininfor_location.
  ///
  /// In en, this message translates to:
  /// **'登录地点'**
  String get sys_label_logininfor_location;

  /// No description provided for @sys_label_logininfor_os.
  ///
  /// In en, this message translates to:
  /// **'操作系统'**
  String get sys_label_logininfor_os;

  /// No description provided for @sys_label_logininfor_status.
  ///
  /// In en, this message translates to:
  /// **'状态'**
  String get sys_label_logininfor_status;

  /// No description provided for @sys_label_logininfor_unlock.
  ///
  /// In en, this message translates to:
  /// **'解锁'**
  String get sys_label_logininfor_unlock;

  /// No description provided for @sys_label_logininfor_unlock_confirm.
  ///
  /// In en, this message translates to:
  /// **'确定要解锁该用户吗？'**
  String get sys_label_logininfor_unlock_confirm;

  /// No description provided for @sys_label_logininfor_unlock_ing.
  ///
  /// In en, this message translates to:
  /// **'正在解锁...'**
  String get sys_label_logininfor_unlock_ing;

  /// No description provided for @sys_label_logininfor_unlock_success.
  ///
  /// In en, this message translates to:
  /// **'解锁成功'**
  String get sys_label_logininfor_unlock_success;

  /// No description provided for @sys_label_logininfor_unlock_fail.
  ///
  /// In en, this message translates to:
  /// **'解锁失败'**
  String get sys_label_logininfor_unlock_fail;

  /// No description provided for @sys_label_log_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除Id为%s的日志信息吗？'**
  String get sys_label_log_del_prompt;

  /// No description provided for @sys_label_log_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的日志'**
  String get sys_label_log_del_select_empty;

  /// No description provided for @sys_label_oss_search.
  ///
  /// In en, this message translates to:
  /// **'搜索文件'**
  String get sys_label_oss_search;

  /// No description provided for @sys_label_oss_view_file.
  ///
  /// In en, this message translates to:
  /// **'查看文件'**
  String get sys_label_oss_view_file;

  /// No description provided for @sys_label_oss_file_name.
  ///
  /// In en, this message translates to:
  /// **'文件名'**
  String get sys_label_oss_file_name;

  /// No description provided for @sys_label_oss_original_name.
  ///
  /// In en, this message translates to:
  /// **'原名'**
  String get sys_label_oss_original_name;

  /// No description provided for @sys_label_oss_file_suffix.
  ///
  /// In en, this message translates to:
  /// **'文件后缀'**
  String get sys_label_oss_file_suffix;

  /// No description provided for @sys_label_oss_create_by.
  ///
  /// In en, this message translates to:
  /// **'上传人'**
  String get sys_label_oss_create_by;

  /// No description provided for @sys_label_oss_service.
  ///
  /// In en, this message translates to:
  /// **'服务商'**
  String get sys_label_oss_service;

  /// No description provided for @sys_label_oss_create_tile.
  ///
  /// In en, this message translates to:
  /// **'创建时间'**
  String get sys_label_oss_create_tile;

  /// No description provided for @sys_label_oss_details.
  ///
  /// In en, this message translates to:
  /// **'文件详情'**
  String get sys_label_oss_details;

  /// No description provided for @sys_label_permission_file_download_hint.
  ///
  /// In en, this message translates to:
  /// **'下载并保存文件需要文件管理权限，请授予！'**
  String get sys_label_permission_file_download_hint;

  /// No description provided for @sys_label_get_file_download_hint.
  ///
  /// In en, this message translates to:
  /// **'获取下载路径失败，请检查相关权限！'**
  String get sys_label_get_file_download_hint;

  /// No description provided for @sys_label_oss_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除名称为%s的文件吗？'**
  String get sys_label_oss_del_prompt;

  /// No description provided for @sys_label_oss_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的文件'**
  String get sys_label_oss_del_select_empty;

  /// No description provided for @sys_label_oss_config_name.
  ///
  /// In en, this message translates to:
  /// **'配置管理'**
  String get sys_label_oss_config_name;

  /// No description provided for @sys_label_oss_config_key.
  ///
  /// In en, this message translates to:
  /// **'配置key'**
  String get sys_label_oss_config_key;

  /// No description provided for @sys_label_oss_config_visit_site.
  ///
  /// In en, this message translates to:
  /// **'访问站点'**
  String get sys_label_oss_config_visit_site;

  /// No description provided for @sys_label_oss_config_custom_domain.
  ///
  /// In en, this message translates to:
  /// **'自定义域名'**
  String get sys_label_oss_config_custom_domain;

  /// No description provided for @sys_label_oss_config_access_key.
  ///
  /// In en, this message translates to:
  /// **'accessKey'**
  String get sys_label_oss_config_access_key;

  /// No description provided for @sys_label_oss_config_secret_key.
  ///
  /// In en, this message translates to:
  /// **'secretKey'**
  String get sys_label_oss_config_secret_key;

  /// No description provided for @sys_label_oss_config_bucket_name.
  ///
  /// In en, this message translates to:
  /// **'桶名称'**
  String get sys_label_oss_config_bucket_name;

  /// No description provided for @sys_label_oss_config_prefix.
  ///
  /// In en, this message translates to:
  /// **'前缀'**
  String get sys_label_oss_config_prefix;

  /// No description provided for @sys_label_oss_config_is_https.
  ///
  /// In en, this message translates to:
  /// **'是否HTTPS'**
  String get sys_label_oss_config_is_https;

  /// No description provided for @sys_label_oss_config_bucket_permissions_name.
  ///
  /// In en, this message translates to:
  /// **'桶权限类型'**
  String get sys_label_oss_config_bucket_permissions_name;

  /// No description provided for @sys_label_oss_config_region.
  ///
  /// In en, this message translates to:
  /// **'域'**
  String get sys_label_oss_config_region;

  /// No description provided for @sys_label_oss_config_remark.
  ///
  /// In en, this message translates to:
  /// **'备注'**
  String get sys_label_oss_config_remark;

  /// No description provided for @sys_label_oss_config_add.
  ///
  /// In en, this message translates to:
  /// **'新增Oss配置'**
  String get sys_label_oss_config_add;

  /// No description provided for @sys_label_oss_config_edit.
  ///
  /// In en, this message translates to:
  /// **'修改Oss配置'**
  String get sys_label_oss_config_edit;

  /// No description provided for @sys_label_oss_config_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除Key为%s的配置信息吗？'**
  String get sys_label_oss_config_del_prompt;

  /// No description provided for @sys_label_oss_config_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的配置'**
  String get sys_label_oss_config_del_select_empty;

  /// No description provided for @sys_label_sys_client_add.
  ///
  /// In en, this message translates to:
  /// **'新增客户端配置'**
  String get sys_label_sys_client_add;

  /// No description provided for @sys_label_sys_client_edit.
  ///
  /// In en, this message translates to:
  /// **'修改客户端配置'**
  String get sys_label_sys_client_edit;

  /// No description provided for @sys_label_sys_client_name.
  ///
  /// In en, this message translates to:
  /// **'配置管理'**
  String get sys_label_sys_client_name;

  /// No description provided for @sys_label_sys_client_client_Id.
  ///
  /// In en, this message translates to:
  /// **'客户端Id'**
  String get sys_label_sys_client_client_Id;

  /// No description provided for @sys_label_sys_client_client_key.
  ///
  /// In en, this message translates to:
  /// **'客户端key'**
  String get sys_label_sys_client_client_key;

  /// No description provided for @sys_label_sys_client_client_secret.
  ///
  /// In en, this message translates to:
  /// **'客户端秘钥'**
  String get sys_label_sys_client_client_secret;

  /// No description provided for @sys_label_sys_client_grant_type.
  ///
  /// In en, this message translates to:
  /// **'授权类型'**
  String get sys_label_sys_client_grant_type;

  /// No description provided for @sys_label_sys_client_grant_type_select.
  ///
  /// In en, this message translates to:
  /// **'选择授权类型'**
  String get sys_label_sys_client_grant_type_select;

  /// No description provided for @sys_label_sys_client_device_type.
  ///
  /// In en, this message translates to:
  /// **'设备类型'**
  String get sys_label_sys_client_device_type;

  /// No description provided for @sys_label_sys_client_device_type_select.
  ///
  /// In en, this message translates to:
  /// **'选择设备类型'**
  String get sys_label_sys_client_device_type_select;

  /// No description provided for @sys_label_sys_client_active_timeout.
  ///
  /// In en, this message translates to:
  /// **'token活跃超时时间'**
  String get sys_label_sys_client_active_timeout;

  /// No description provided for @sys_label_sys_client_timeout.
  ///
  /// In en, this message translates to:
  /// **'token固定超时时间'**
  String get sys_label_sys_client_timeout;

  /// No description provided for @sys_label_sys_client_status.
  ///
  /// In en, this message translates to:
  /// **'状态'**
  String get sys_label_sys_client_status;

  /// No description provided for @sys_label_sys_client_del_flag.
  ///
  /// In en, this message translates to:
  /// **'删除标志'**
  String get sys_label_sys_client_del_flag;

  /// No description provided for @sys_label_sys_client_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除客户端Id为%s的客户端信息吗？'**
  String get sys_label_sys_client_del_prompt;

  /// No description provided for @sys_label_sys_client_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的客户端'**
  String get sys_label_sys_client_del_select_empty;

  /// No description provided for @sys_label_sys_tenant_package_search.
  ///
  /// In en, this message translates to:
  /// **'搜索租户套餐'**
  String get sys_label_sys_tenant_package_search;

  /// No description provided for @sys_label_sys_tenant_package_name.
  ///
  /// In en, this message translates to:
  /// **'套餐名称'**
  String get sys_label_sys_tenant_package_name;

  /// No description provided for @sys_label_sys_tenant_package_context_menu.
  ///
  /// In en, this message translates to:
  /// **'关联菜单'**
  String get sys_label_sys_tenant_package_context_menu;

  /// No description provided for @sys_label_sys_tenant_package_remark.
  ///
  /// In en, this message translates to:
  /// **'备注'**
  String get sys_label_sys_tenant_package_remark;

  /// No description provided for @sys_label_sys_tenant_package_add.
  ///
  /// In en, this message translates to:
  /// **'新增租户套餐'**
  String get sys_label_sys_tenant_package_add;

  /// No description provided for @sys_label_sys_tenant_package_edit.
  ///
  /// In en, this message translates to:
  /// **'编辑租户套餐'**
  String get sys_label_sys_tenant_package_edit;

  /// No description provided for @sys_label_sys_tenant_package_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除名称为%s的租户套餐吗？'**
  String get sys_label_sys_tenant_package_del_prompt;

  /// No description provided for @sys_label_sys_tenant_package_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的租户套餐'**
  String get sys_label_sys_tenant_package_del_select_empty;

  /// No description provided for @sys_label_sys_tenant_x_expire_time.
  ///
  /// In en, this message translates to:
  /// **'到期'**
  String get sys_label_sys_tenant_x_expire_time;

  /// No description provided for @sys_label_sys_tenant_search.
  ///
  /// In en, this message translates to:
  /// **'搜索租户'**
  String get sys_label_sys_tenant_search;

  /// No description provided for @sys_label_sys_tenant_id.
  ///
  /// In en, this message translates to:
  /// **'租户编号'**
  String get sys_label_sys_tenant_id;

  /// No description provided for @sys_label_sys_tenant_company_name.
  ///
  /// In en, this message translates to:
  /// **'企业名称'**
  String get sys_label_sys_tenant_company_name;

  /// No description provided for @sys_label_sys_tenant_contact_user_name.
  ///
  /// In en, this message translates to:
  /// **'联系人'**
  String get sys_label_sys_tenant_contact_user_name;

  /// No description provided for @sys_label_sys_tenant_contact_phone.
  ///
  /// In en, this message translates to:
  /// **'联系电话'**
  String get sys_label_sys_tenant_contact_phone;

  /// No description provided for @sys_label_sys_tenant_user_name.
  ///
  /// In en, this message translates to:
  /// **'用户名'**
  String get sys_label_sys_tenant_user_name;

  /// No description provided for @sys_label_sys_tenant_user_pw.
  ///
  /// In en, this message translates to:
  /// **'用户密码'**
  String get sys_label_sys_tenant_user_pw;

  /// No description provided for @sys_label_sys_tenant_package_id.
  ///
  /// In en, this message translates to:
  /// **'租户套餐'**
  String get sys_label_sys_tenant_package_id;

  /// No description provided for @sys_label_sys_tenant_package_select.
  ///
  /// In en, this message translates to:
  /// **'选择租户套餐'**
  String get sys_label_sys_tenant_package_select;

  /// No description provided for @sys_label_sys_tenant_expire_time.
  ///
  /// In en, this message translates to:
  /// **'过期时间'**
  String get sys_label_sys_tenant_expire_time;

  /// No description provided for @sys_label_sys_tenant_account_count.
  ///
  /// In en, this message translates to:
  /// **'账户数量'**
  String get sys_label_sys_tenant_account_count;

  /// No description provided for @sys_label_sys_tenant_domain.
  ///
  /// In en, this message translates to:
  /// **'绑定域名'**
  String get sys_label_sys_tenant_domain;

  /// No description provided for @sys_label_sys_tenant_address.
  ///
  /// In en, this message translates to:
  /// **'企业地址'**
  String get sys_label_sys_tenant_address;

  /// No description provided for @sys_label_sys_tenant_license_number.
  ///
  /// In en, this message translates to:
  /// **'企业代码'**
  String get sys_label_sys_tenant_license_number;

  /// No description provided for @sys_label_sys_tenant_intro.
  ///
  /// In en, this message translates to:
  /// **'企业简介'**
  String get sys_label_sys_tenant_intro;

  /// No description provided for @sys_label_sys_tenant_del_prompt.
  ///
  /// In en, this message translates to:
  /// **'确定要删除名称为%s的租户吗？'**
  String get sys_label_sys_tenant_del_prompt;

  /// No description provided for @sys_label_sys_tenant_del_select_empty.
  ///
  /// In en, this message translates to:
  /// **'请选择需要删除的租户'**
  String get sys_label_sys_tenant_del_select_empty;

  /// No description provided for @sys_label_sys_tenant_remark.
  ///
  /// In en, this message translates to:
  /// **'备注'**
  String get sys_label_sys_tenant_remark;

  /// No description provided for @sys_label_sys_tenant_status.
  ///
  /// In en, this message translates to:
  /// **'状态'**
  String get sys_label_sys_tenant_status;

  /// No description provided for @sys_label_sys_tenant_add.
  ///
  /// In en, this message translates to:
  /// **'新增租户'**
  String get sys_label_sys_tenant_add;

  /// No description provided for @sys_label_sys_tenant_edit.
  ///
  /// In en, this message translates to:
  /// **'编辑租户'**
  String get sys_label_sys_tenant_edit;

  /// No description provided for @sys_label_sys_tenant_sync_package.
  ///
  /// In en, this message translates to:
  /// **'同步套餐'**
  String get sys_label_sys_tenant_sync_package;

  /// No description provided for @sys_label_sys_tenant_sync_package_ing.
  ///
  /// In en, this message translates to:
  /// **'正在同步...'**
  String get sys_label_sys_tenant_sync_package_ing;

  /// No description provided for @sys_label_sys_tenant_sync_package_succeed.
  ///
  /// In en, this message translates to:
  /// **'同步成功'**
  String get sys_label_sys_tenant_sync_package_succeed;

  /// No description provided for @sys_label_sys_tenant_sync_package_failed.
  ///
  /// In en, this message translates to:
  /// **'同步失败'**
  String get sys_label_sys_tenant_sync_package_failed;

  /// No description provided for @sys_label_sys_tenant_sync_dict.
  ///
  /// In en, this message translates to:
  /// **'同步租户字典'**
  String get sys_label_sys_tenant_sync_dict;

  /// No description provided for @sys_label_sys_tenant_sync_dict_confirm.
  ///
  /// In en, this message translates to:
  /// **'确认要同步所有租户字典吗？'**
  String get sys_label_sys_tenant_sync_dict_confirm;

  /// No description provided for @sys_label_sys_tenant_sync_dict_ing.
  ///
  /// In en, this message translates to:
  /// **'正在同步...'**
  String get sys_label_sys_tenant_sync_dict_ing;

  /// No description provided for @sys_label_sys_tenant_sync_dict_succeed.
  ///
  /// In en, this message translates to:
  /// **'同步租户字典成功'**
  String get sys_label_sys_tenant_sync_dict_succeed;

  /// No description provided for @sys_label_sys_tenant_sync_dict_failed.
  ///
  /// In en, this message translates to:
  /// **'同步租户字典失败'**
  String get sys_label_sys_tenant_sync_dict_failed;

  /// No description provided for @sys_label_online_login_address.
  ///
  /// In en, this message translates to:
  /// **'登录地址'**
  String get sys_label_online_login_address;

  /// No description provided for @sys_label_online_login_user_name.
  ///
  /// In en, this message translates to:
  /// **'用户名称'**
  String get sys_label_online_login_user_name;

  /// No description provided for @sys_label_cache_monitor_redis_info.
  ///
  /// In en, this message translates to:
  /// **'redis信息'**
  String get sys_label_cache_monitor_redis_info;

  /// No description provided for @sys_label_cache_monitor_command_statistics.
  ///
  /// In en, this message translates to:
  /// **'命令统计'**
  String get sys_label_cache_monitor_command_statistics;

  /// No description provided for @sys_label_cache_monitor_memory_information.
  ///
  /// In en, this message translates to:
  /// **'内存信息'**
  String get sys_label_cache_monitor_memory_information;

  /// No description provided for @sys_label_setting_item_theme_mode.
  ///
  /// In en, this message translates to:
  /// **'主题模式'**
  String get sys_label_setting_item_theme_mode;

  /// No description provided for @sys_label_setting_item_check_updates.
  ///
  /// In en, this message translates to:
  /// **'检查更新'**
  String get sys_label_setting_item_check_updates;

  /// No description provided for @sys_label_setting_item_about.
  ///
  /// In en, this message translates to:
  /// **'关于项目'**
  String get sys_label_setting_item_about;

  /// No description provided for @sys_label_setting_follow_system.
  ///
  /// In en, this message translates to:
  /// **'跟随系统'**
  String get sys_label_setting_follow_system;

  /// No description provided for @sys_label_setting_light_mode.
  ///
  /// In en, this message translates to:
  /// **'高亮模式'**
  String get sys_label_setting_light_mode;

  /// No description provided for @sys_label_setting_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'暗黑模式'**
  String get sys_label_setting_dark_mode;

  /// No description provided for @main_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get main_divide_text;

  /// No description provided for @main_label_analyse.
  ///
  /// In en, this message translates to:
  /// **'分析'**
  String get main_label_analyse;

  /// No description provided for @main_label_workbench.
  ///
  /// In en, this message translates to:
  /// **'工作台'**
  String get main_label_workbench;

  /// No description provided for @main_label_mine.
  ///
  /// In en, this message translates to:
  /// **'我的'**
  String get main_label_mine;

  /// No description provided for @analyse_label_week_online.
  ///
  /// In en, this message translates to:
  /// **'在线统计'**
  String get analyse_label_week_online;

  /// No description provided for @analyse_label_traffic_trends.
  ///
  /// In en, this message translates to:
  /// **'流量趋势'**
  String get analyse_label_traffic_trends;

  /// No description provided for @analyse_label_month_visits.
  ///
  /// In en, this message translates to:
  /// **'月访问量'**
  String get analyse_label_month_visits;

  /// No description provided for @analyse_label_access_source.
  ///
  /// In en, this message translates to:
  /// **'访问来源'**
  String get analyse_label_access_source;

  /// No description provided for @analyse_label_access_trends.
  ///
  /// In en, this message translates to:
  /// **'访问趋势'**
  String get analyse_label_access_trends;

  /// No description provided for @menu_label_root.
  ///
  /// In en, this message translates to:
  /// **'根目录'**
  String get menu_label_root;

  /// No description provided for @menu_label_menu_tree.
  ///
  /// In en, this message translates to:
  /// **'菜单树'**
  String get menu_label_menu_tree;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
