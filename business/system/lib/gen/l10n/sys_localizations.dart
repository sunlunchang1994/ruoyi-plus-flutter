import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'sys_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SysLocalizations
/// returned by `SysLocalizations.of(context)`.
///
/// Applications need to include `SysLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/sys_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SysLocalizations.localizationsDelegates,
///   supportedLocales: SysLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the SysLocalizations.supportedLocales
/// property.
abstract class SysLocalizations {
  SysLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SysLocalizations? of(BuildContext context) {
    return Localizations.of<SysLocalizations>(context, SysLocalizations);
  }

  static const LocalizationsDelegate<SysLocalizations> delegate = _SysLocalizationsDelegate();

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

  /// No description provided for @sys_label_menu_permission.
  ///
  /// In en, this message translates to:
  /// **'菜单权限'**
  String get sys_label_menu_permission;

  /// No description provided for @sys_label_menu_permission_select.
  ///
  /// In en, this message translates to:
  /// **'配置菜单权限'**
  String get sys_label_menu_permission_select;

  /// No description provided for @sys_label_menu_permission_select_result.
  ///
  /// In en, this message translates to:
  /// **'已配置%s项菜单，点击查看'**
  String get sys_label_menu_permission_select_result;

  /// No description provided for @sys_label_menu_permission_select_result2.
  ///
  /// In en, this message translates to:
  /// **'已配置多个菜单项，点击查看'**
  String get sys_label_menu_permission_select_result2;

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

  /// No description provided for @sys_label_dept_status.
  ///
  /// In en, this message translates to:
  /// **'部门状态'**
  String get sys_label_dept_status;

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

  /// No description provided for @sys_label_setting.
  ///
  /// In en, this message translates to:
  /// **'设置'**
  String get sys_label_setting;

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

  /// No description provided for @sys_label_sign_out.
  ///
  /// In en, this message translates to:
  /// **'退出登录'**
  String get sys_label_sign_out;

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

class _SysLocalizationsDelegate extends LocalizationsDelegate<SysLocalizations> {
  const _SysLocalizationsDelegate();

  @override
  Future<SysLocalizations> load(Locale locale) {
    return SynchronousFuture<SysLocalizations>(lookupSysLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SysLocalizationsDelegate old) => false;
}

SysLocalizations lookupSysLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SysLocalizationsEn();
  }

  throw FlutterError(
    'SysLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
