import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'fast_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of FastLocalizations
/// returned by `FastLocalizations.of(context)`.
///
/// Applications need to include `FastLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/fast_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FastLocalizations.localizationsDelegates,
///   supportedLocales: FastLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the FastLocalizations.supportedLocales
/// property.
abstract class FastLocalizations {
  FastLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FastLocalizations? of(BuildContext context) {
    return Localizations.of<FastLocalizations>(context, FastLocalizations);
  }

  static const LocalizationsDelegate<FastLocalizations> delegate = _FastLocalizationsDelegate();

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

  /// No description provided for @action_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get action_divide_text;

  /// No description provided for @action_save.
  ///
  /// In en, this message translates to:
  /// **'保存'**
  String get action_save;

  /// No description provided for @action_edit.
  ///
  /// In en, this message translates to:
  /// **'编辑'**
  String get action_edit;

  /// No description provided for @action_add.
  ///
  /// In en, this message translates to:
  /// **'添加'**
  String get action_add;

  /// No description provided for @action_next_step.
  ///
  /// In en, this message translates to:
  /// **'下一步'**
  String get action_next_step;

  /// No description provided for @action_pre_step.
  ///
  /// In en, this message translates to:
  /// **'上一步'**
  String get action_pre_step;

  /// No description provided for @action_delete.
  ///
  /// In en, this message translates to:
  /// **'删除'**
  String get action_delete;

  /// No description provided for @action_remove.
  ///
  /// In en, this message translates to:
  /// **'移除'**
  String get action_remove;

  /// No description provided for @action_reset.
  ///
  /// In en, this message translates to:
  /// **'重置'**
  String get action_reset;

  /// No description provided for @action_search.
  ///
  /// In en, this message translates to:
  /// **'搜索'**
  String get action_search;

  /// No description provided for @action_ok.
  ///
  /// In en, this message translates to:
  /// **'确定'**
  String get action_ok;

  /// No description provided for @action_confirm.
  ///
  /// In en, this message translates to:
  /// **'确认'**
  String get action_confirm;

  /// No description provided for @action_close.
  ///
  /// In en, this message translates to:
  /// **'关闭'**
  String get action_close;

  /// No description provided for @action_exit.
  ///
  /// In en, this message translates to:
  /// **'退出'**
  String get action_exit;

  /// No description provided for @action_exit_without_save.
  ///
  /// In en, this message translates to:
  /// **'不保存退出'**
  String get action_exit_without_save;

  /// No description provided for @action_send.
  ///
  /// In en, this message translates to:
  /// **'发送'**
  String get action_send;

  /// No description provided for @action_setting.
  ///
  /// In en, this message translates to:
  /// **'设置'**
  String get action_setting;

  /// No description provided for @action_cancel.
  ///
  /// In en, this message translates to:
  /// **'取消'**
  String get action_cancel;

  /// No description provided for @action_do_not_remind_again.
  ///
  /// In en, this message translates to:
  /// **'不再提示'**
  String get action_do_not_remind_again;

  /// No description provided for @action_complete.
  ///
  /// In en, this message translates to:
  /// **'完成'**
  String get action_complete;

  /// No description provided for @action_submit.
  ///
  /// In en, this message translates to:
  /// **'提交'**
  String get action_submit;

  /// No description provided for @action_i_know.
  ///
  /// In en, this message translates to:
  /// **'我知道了'**
  String get action_i_know;

  /// No description provided for @action_continue.
  ///
  /// In en, this message translates to:
  /// **'继续'**
  String get action_continue;

  /// No description provided for @action_look.
  ///
  /// In en, this message translates to:
  /// **'查看'**
  String get action_look;

  /// No description provided for @action_deny.
  ///
  /// In en, this message translates to:
  /// **'拒绝'**
  String get action_deny;

  /// No description provided for @action_filter.
  ///
  /// In en, this message translates to:
  /// **'筛选'**
  String get action_filter;

  /// No description provided for @action_entire.
  ///
  /// In en, this message translates to:
  /// **'全部'**
  String get action_entire;

  /// No description provided for @action_import.
  ///
  /// In en, this message translates to:
  /// **'导入'**
  String get action_import;

  /// No description provided for @action_export.
  ///
  /// In en, this message translates to:
  /// **'导出'**
  String get action_export;

  /// No description provided for @action_refresh.
  ///
  /// In en, this message translates to:
  /// **'刷新'**
  String get action_refresh;

  /// No description provided for @label_common_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get label_common_divide_text;

  /// No description provided for @label_prompt.
  ///
  /// In en, this message translates to:
  /// **'提示'**
  String get label_prompt;

  /// No description provided for @label_def.
  ///
  /// In en, this message translates to:
  /// **'默认'**
  String get label_def;

  /// No description provided for @label_running.
  ///
  /// In en, this message translates to:
  /// **'正在运行'**
  String get label_running;

  /// No description provided for @label_permission_file_picker_hint.
  ///
  /// In en, this message translates to:
  /// **'我们需要获取读写存储器权限才能进行文件选择操作！'**
  String get label_permission_file_picker_hint;

  /// No description provided for @label_permission_base_hint.
  ///
  /// In en, this message translates to:
  /// **'这是我们需要的最基本的权限，请授予允许！'**
  String get label_permission_base_hint;

  /// No description provided for @label_permission_base_setting_hint.
  ///
  /// In en, this message translates to:
  /// **'这是我们需要的最基本的权限，请在设置界面中授予允许！'**
  String get label_permission_base_setting_hint;

  /// No description provided for @label_permission_base_hint_denied.
  ///
  /// In en, this message translates to:
  /// **'您没有授予最基本的权限，部分功能将无法使用！'**
  String get label_permission_base_hint_denied;

  /// No description provided for @label_content_cannot_be_empty_blank.
  ///
  /// In en, this message translates to:
  /// **'内容不能为空或空格'**
  String get label_content_cannot_be_empty_blank;

  /// No description provided for @label_select_parameter_is_missing.
  ///
  /// In en, this message translates to:
  /// **'参数丢失'**
  String get label_select_parameter_is_missing;

  /// No description provided for @label_token_failure_prompt.
  ///
  /// In en, this message translates to:
  /// **'登录超时，请重新登录！'**
  String get label_token_failure_prompt;

  /// No description provided for @label_error_connection_error.
  ///
  /// In en, this message translates to:
  /// **'连接服务器失败！'**
  String get label_error_connection_error;

  /// No description provided for @label_error_connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'连接服务器超时，请检查网络！'**
  String get label_error_connection_timeout;

  /// No description provided for @label_error_send_timeout.
  ///
  /// In en, this message translates to:
  /// **'服务器读取超时，请检查网络！'**
  String get label_error_send_timeout;

  /// No description provided for @label_error_receive_timeout.
  ///
  /// In en, this message translates to:
  /// **'接收服务器数据超时，请检查网络！'**
  String get label_error_receive_timeout;

  /// No description provided for @label_loading.
  ///
  /// In en, this message translates to:
  /// **'正在加载...'**
  String get label_loading;

  /// No description provided for @label_loading_success.
  ///
  /// In en, this message translates to:
  /// **'加载成功'**
  String get label_loading_success;

  /// No description provided for @label_loading_failure.
  ///
  /// In en, this message translates to:
  /// **'加载失败'**
  String get label_loading_failure;

  /// No description provided for @label_delete_ing.
  ///
  /// In en, this message translates to:
  /// **'正在删除...'**
  String get label_delete_ing;

  /// No description provided for @label_delete_really.
  ///
  /// In en, this message translates to:
  /// **'确认删除？'**
  String get label_delete_really;

  /// No description provided for @label_delete_success.
  ///
  /// In en, this message translates to:
  /// **'删除成功'**
  String get label_delete_success;

  /// No description provided for @label_delete_failed.
  ///
  /// In en, this message translates to:
  /// **'删除失败'**
  String get label_delete_failed;

  /// No description provided for @label_file_upload_by_file_failed.
  ///
  /// In en, this message translates to:
  /// **'上传文件失败'**
  String get label_file_upload_by_file_failed;

  /// No description provided for @label_file_download_failed.
  ///
  /// In en, this message translates to:
  /// **'下载文件失败'**
  String get label_file_download_failed;

  /// No description provided for @label_file_download_failed_download_file_failed.
  ///
  /// In en, this message translates to:
  /// **'下载文件失败 请重试'**
  String get label_file_download_failed_download_file_failed;

  /// No description provided for @label_file_are_uploading.
  ///
  /// In en, this message translates to:
  /// **'正在上传'**
  String get label_file_are_uploading;

  /// No description provided for @label_file_upload_failed.
  ///
  /// In en, this message translates to:
  /// **'上传失败'**
  String get label_file_upload_failed;

  /// No description provided for @label_file_uploaded_success.
  ///
  /// In en, this message translates to:
  /// **'上传成功'**
  String get label_file_uploaded_success;

  /// No description provided for @label_submit_ing.
  ///
  /// In en, this message translates to:
  /// **'正在提交...'**
  String get label_submit_ing;

  /// No description provided for @label_submitted_success.
  ///
  /// In en, this message translates to:
  /// **'提交成功'**
  String get label_submitted_success;

  /// No description provided for @label_submitted_failure.
  ///
  /// In en, this message translates to:
  /// **'提交失败'**
  String get label_submitted_failure;

  /// No description provided for @toast_edit_success.
  ///
  /// In en, this message translates to:
  /// **'修改成功'**
  String get toast_edit_success;

  /// No description provided for @toast_edit_failure.
  ///
  /// In en, this message translates to:
  /// **'修改失败'**
  String get toast_edit_failure;

  /// No description provided for @label_operation_failed.
  ///
  /// In en, this message translates to:
  /// **'操作失败'**
  String get label_operation_failed;

  /// No description provided for @label_save_ing.
  ///
  /// In en, this message translates to:
  /// **'正在保存...'**
  String get label_save_ing;

  /// No description provided for @label_save_failed.
  ///
  /// In en, this message translates to:
  /// **'保存失败'**
  String get label_save_failed;

  /// No description provided for @label_success_saved.
  ///
  /// In en, this message translates to:
  /// **'保存成功'**
  String get label_success_saved;

  /// No description provided for @label_exiting.
  ///
  /// In en, this message translates to:
  /// **'正在退出...'**
  String get label_exiting;

  /// No description provided for @label_restarting.
  ///
  /// In en, this message translates to:
  /// **'正在重启'**
  String get label_restarting;

  /// No description provided for @label_update_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get label_update_divide_text;

  /// No description provided for @action_temporarily_not_update.
  ///
  /// In en, this message translates to:
  /// **'暂不更新'**
  String get action_temporarily_not_update;

  /// No description provided for @action_update_now.
  ///
  /// In en, this message translates to:
  /// **'立即更新'**
  String get action_update_now;

  /// No description provided for @action_get_the_installation_package.
  ///
  /// In en, this message translates to:
  /// **'正在获取安装包'**
  String get action_get_the_installation_package;

  /// No description provided for @title_the_latest_version.
  ///
  /// In en, this message translates to:
  /// **'有最新版本'**
  String get title_the_latest_version;

  /// No description provided for @title_already_the_latest_version.
  ///
  /// In en, this message translates to:
  /// **'已是最新版本'**
  String get title_already_the_latest_version;

  /// No description provided for @title_be_updating.
  ///
  /// In en, this message translates to:
  /// **'正在更新'**
  String get title_be_updating;

  /// No description provided for @label_completed_size.
  ///
  /// In en, this message translates to:
  /// **'已下载%s'**
  String get label_completed_size;

  /// No description provided for @action_download_on_success.
  ///
  /// In en, this message translates to:
  /// **'下载完成'**
  String get action_download_on_success;

  /// No description provided for @action_install_now.
  ///
  /// In en, this message translates to:
  /// **'立即安装'**
  String get action_install_now;

  /// No description provided for @action_download_on_error.
  ///
  /// In en, this message translates to:
  /// **'下载出错'**
  String get action_download_on_error;

  /// No description provided for @label_list_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get label_list_divide_text;

  /// No description provided for @label_there_is_no_data_at_present.
  ///
  /// In en, this message translates to:
  /// **'暂时没有数据'**
  String get label_there_is_no_data_at_present;

  /// No description provided for @action_download_on_error_click_retry.
  ///
  /// In en, this message translates to:
  /// **'下载出错，点击重试'**
  String get action_download_on_error_click_retry;

  /// No description provided for @label_data_acquisition_failed.
  ///
  /// In en, this message translates to:
  /// **'获取数据失败'**
  String get label_data_acquisition_failed;

  /// No description provided for @label_invalid_data.
  ///
  /// In en, this message translates to:
  /// **'无效的数据'**
  String get label_invalid_data;

  /// No description provided for @label_data_is_null.
  ///
  /// In en, this message translates to:
  /// **'数据为空'**
  String get label_data_is_null;

  /// No description provided for @label_unknown_exception.
  ///
  /// In en, this message translates to:
  /// **'未知异常'**
  String get label_unknown_exception;

  /// No description provided for @label_select_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get label_select_divide_text;

  /// No description provided for @label_state_complete.
  ///
  /// In en, this message translates to:
  /// **'全部'**
  String get label_state_complete;

  /// No description provided for @label_state_completed.
  ///
  /// In en, this message translates to:
  /// **'已完成'**
  String get label_state_completed;

  /// No description provided for @label_state_undone.
  ///
  /// In en, this message translates to:
  /// **'未完成'**
  String get label_state_undone;

  /// No description provided for @label_state_selected.
  ///
  /// In en, this message translates to:
  /// **'已选择'**
  String get label_state_selected;

  /// No description provided for @label_state_not_selected.
  ///
  /// In en, this message translates to:
  /// **'未选择'**
  String get label_state_not_selected;

  /// No description provided for @label_select_undone_prompt.
  ///
  /// In en, this message translates to:
  /// **'您的选择未进行确认，是否确认完成？'**
  String get label_select_undone_prompt;

  /// No description provided for @label_unit_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get label_unit_divide_text;

  /// No description provided for @label_unit_entries.
  ///
  /// In en, this message translates to:
  /// **'个'**
  String get label_unit_entries;

  /// No description provided for @label_unit_entries_x.
  ///
  /// In en, this message translates to:
  /// **'%s个'**
  String get label_unit_entries_x;

  /// No description provided for @label_unit_person.
  ///
  /// In en, this message translates to:
  /// **'人'**
  String get label_unit_person;

  /// No description provided for @label_unit_person_x.
  ///
  /// In en, this message translates to:
  /// **'%s人'**
  String get label_unit_person_x;

  /// No description provided for @label_unit_strip.
  ///
  /// In en, this message translates to:
  /// **'条'**
  String get label_unit_strip;

  /// No description provided for @label_unit_strip_x.
  ///
  /// In en, this message translates to:
  /// **'%s条'**
  String get label_unit_strip_x;

  /// No description provided for @label_unit_car.
  ///
  /// In en, this message translates to:
  /// **'辆'**
  String get label_unit_car;

  /// No description provided for @label_unit_car_x.
  ///
  /// In en, this message translates to:
  /// **'%s辆'**
  String get label_unit_car_x;

  /// No description provided for @label_unit_merely.
  ///
  /// In en, this message translates to:
  /// **'只'**
  String get label_unit_merely;

  /// No description provided for @label_unit_merely_x.
  ///
  /// In en, this message translates to:
  /// **'%s只'**
  String get label_unit_merely_x;

  /// No description provided for @label_unit_element.
  ///
  /// In en, this message translates to:
  /// **'元'**
  String get label_unit_element;

  /// No description provided for @label_unit_element_x.
  ///
  /// In en, this message translates to:
  /// **'%s元'**
  String get label_unit_element_x;

  /// No description provided for @label_unit_meter.
  ///
  /// In en, this message translates to:
  /// **'米'**
  String get label_unit_meter;

  /// No description provided for @label_unit_meter_x.
  ///
  /// In en, this message translates to:
  /// **'%s米'**
  String get label_unit_meter_x;

  /// No description provided for @label_unit_Kilometer.
  ///
  /// In en, this message translates to:
  /// **'千米'**
  String get label_unit_Kilometer;

  /// No description provided for @label_unit_Kilometer_x.
  ///
  /// In en, this message translates to:
  /// **'%s千米'**
  String get label_unit_Kilometer_x;

  /// No description provided for @label_unit_year.
  ///
  /// In en, this message translates to:
  /// **'年'**
  String get label_unit_year;

  /// No description provided for @label_unit_year_x.
  ///
  /// In en, this message translates to:
  /// **'%s年'**
  String get label_unit_year_x;

  /// No description provided for @label_unit_month.
  ///
  /// In en, this message translates to:
  /// **'月'**
  String get label_unit_month;

  /// No description provided for @label_unit_month_x.
  ///
  /// In en, this message translates to:
  /// **'%s月'**
  String get label_unit_month_x;

  /// No description provided for @label_unit_day.
  ///
  /// In en, this message translates to:
  /// **'日'**
  String get label_unit_day;

  /// No description provided for @label_unit_day_x.
  ///
  /// In en, this message translates to:
  /// **'%s日'**
  String get label_unit_day_x;

  /// No description provided for @label_unit_year_x_month_x.
  ///
  /// In en, this message translates to:
  /// **'%s年%s月'**
  String get label_unit_year_x_month_x;

  /// No description provided for @label_unit_year_x_month_x_day_x.
  ///
  /// In en, this message translates to:
  /// **'%s年%s月%s日'**
  String get label_unit_year_x_month_x_day_x;

  /// No description provided for @label_unit_hour.
  ///
  /// In en, this message translates to:
  /// **'小时'**
  String get label_unit_hour;

  /// No description provided for @label_unit_hour_x.
  ///
  /// In en, this message translates to:
  /// **'%s小时'**
  String get label_unit_hour_x;

  /// No description provided for @label_unit_minute.
  ///
  /// In en, this message translates to:
  /// **'分'**
  String get label_unit_minute;

  /// No description provided for @label_unit_minute_x.
  ///
  /// In en, this message translates to:
  /// **'%s分'**
  String get label_unit_minute_x;

  /// No description provided for @label_unit_minute2.
  ///
  /// In en, this message translates to:
  /// **'分种'**
  String get label_unit_minute2;

  /// No description provided for @label_unit_minute2_x.
  ///
  /// In en, this message translates to:
  /// **'%s分种'**
  String get label_unit_minute2_x;

  /// No description provided for @label_unit_second.
  ///
  /// In en, this message translates to:
  /// **'秒'**
  String get label_unit_second;

  /// No description provided for @label_unit_second_x.
  ///
  /// In en, this message translates to:
  /// **'%s秒'**
  String get label_unit_second_x;

  /// No description provided for @label_unit_millisecond.
  ///
  /// In en, this message translates to:
  /// **'毫秒'**
  String get label_unit_millisecond;

  /// No description provided for @label_unit_millisecond_x.
  ///
  /// In en, this message translates to:
  /// **'%s毫秒'**
  String get label_unit_millisecond_x;

  /// No description provided for @label_unit_day2.
  ///
  /// In en, this message translates to:
  /// **'天'**
  String get label_unit_day2;

  /// No description provided for @label_unit_day2_x.
  ///
  /// In en, this message translates to:
  /// **'%s天'**
  String get label_unit_day2_x;

  /// No description provided for @label_form_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get label_form_divide_text;

  /// No description provided for @label_full_name.
  ///
  /// In en, this message translates to:
  /// **'姓名'**
  String get label_full_name;

  /// No description provided for @label_full_name_x.
  ///
  /// In en, this message translates to:
  /// **'姓名：%s'**
  String get label_full_name_x;

  /// No description provided for @label_tel.
  ///
  /// In en, this message translates to:
  /// **'电话'**
  String get label_tel;

  /// No description provided for @label_tel_x.
  ///
  /// In en, this message translates to:
  /// **'电话：%s'**
  String get label_tel_x;

  /// No description provided for @label_phone.
  ///
  /// In en, this message translates to:
  /// **'手机'**
  String get label_phone;

  /// No description provided for @label_phone_x.
  ///
  /// In en, this message translates to:
  /// **'手机：%s'**
  String get label_phone_x;

  /// No description provided for @label_mailbox.
  ///
  /// In en, this message translates to:
  /// **'邮箱'**
  String get label_mailbox;

  /// No description provided for @label_mailbox_x.
  ///
  /// In en, this message translates to:
  /// **'邮箱：%s'**
  String get label_mailbox_x;

  /// No description provided for @label_wechat.
  ///
  /// In en, this message translates to:
  /// **'微信'**
  String get label_wechat;

  /// No description provided for @label_wechat_x.
  ///
  /// In en, this message translates to:
  /// **'微信：%s'**
  String get label_wechat_x;

  /// No description provided for @label_address.
  ///
  /// In en, this message translates to:
  /// **'地址'**
  String get label_address;

  /// No description provided for @label_address_x.
  ///
  /// In en, this message translates to:
  /// **'地址：%s'**
  String get label_address_x;

  /// No description provided for @label_job_title.
  ///
  /// In en, this message translates to:
  /// **'职务'**
  String get label_job_title;

  /// No description provided for @label_job_title_x.
  ///
  /// In en, this message translates to:
  /// **'职务：%s'**
  String get label_job_title_x;

  /// No description provided for @label_id_card.
  ///
  /// In en, this message translates to:
  /// **'身份证'**
  String get label_id_card;

  /// No description provided for @label_id_card_x.
  ///
  /// In en, this message translates to:
  /// **'身份证：%s'**
  String get label_id_card_x;

  /// No description provided for @label_company.
  ///
  /// In en, this message translates to:
  /// **'公司'**
  String get label_company;

  /// No description provided for @label_company_x.
  ///
  /// In en, this message translates to:
  /// **'公司：%s'**
  String get label_company_x;

  /// No description provided for @label_not.
  ///
  /// In en, this message translates to:
  /// **'无'**
  String get label_not;

  /// No description provided for @label_refresh_divide_text.
  ///
  /// In en, this message translates to:
  /// **'-----------------------------'**
  String get label_refresh_divide_text;

  /// No description provided for @label_refresh_load_complete.
  ///
  /// In en, this message translates to:
  /// **'上拉加载更多'**
  String get label_refresh_load_complete;

  /// No description provided for @label_refresh_load_end.
  ///
  /// In en, this message translates to:
  /// **'没有更多数据'**
  String get label_refresh_load_end;

  /// No description provided for @label_refresh_load_failed.
  ///
  /// In en, this message translates to:
  /// **'加载失败，请重试'**
  String get label_refresh_load_failed;

  /// No description provided for @label_refresh_loading.
  ///
  /// In en, this message translates to:
  /// **'正在加载中...'**
  String get label_refresh_loading;

  /// No description provided for @label_refresh_loading_succeed.
  ///
  /// In en, this message translates to:
  /// **'加载成功'**
  String get label_refresh_loading_succeed;

  /// No description provided for @label_refresh_loading_no_more.
  ///
  /// In en, this message translates to:
  /// **'--我是有底线的--'**
  String get label_refresh_loading_no_more;

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

  /// No description provided for @app_label_attachment.
  ///
  /// In en, this message translates to:
  /// **'附件'**
  String get app_label_attachment;

  /// No description provided for @app_label_unknown_file.
  ///
  /// In en, this message translates to:
  /// **'未知文件'**
  String get app_label_unknown_file;

  /// No description provided for @app_label_compressed_file.
  ///
  /// In en, this message translates to:
  /// **'压缩文件'**
  String get app_label_compressed_file;

  /// No description provided for @app_label_click_preview.
  ///
  /// In en, this message translates to:
  /// **'点击预览'**
  String get app_label_click_preview;

  /// No description provided for @app_label_please_wait_for_the_download_to_complete.
  ///
  /// In en, this message translates to:
  /// **'请等待下载完成'**
  String get app_label_please_wait_for_the_download_to_complete;

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

  /// No description provided for @app_label_add_attachments.
  ///
  /// In en, this message translates to:
  /// **'添加附件'**
  String get app_label_add_attachments;

  /// No description provided for @app_label_add_add_details.
  ///
  /// In en, this message translates to:
  /// **'添加明细'**
  String get app_label_add_add_details;

  /// No description provided for @app_label_add_no_attachments.
  ///
  /// In en, this message translates to:
  /// **'没有附件'**
  String get app_label_add_no_attachments;

  /// No description provided for @app_label_get_attachments_error.
  ///
  /// In en, this message translates to:
  /// **'附件获取失败'**
  String get app_label_get_attachments_error;

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
}

class _FastLocalizationsDelegate extends LocalizationsDelegate<FastLocalizations> {
  const _FastLocalizationsDelegate();

  @override
  Future<FastLocalizations> load(Locale locale) {
    return SynchronousFuture<FastLocalizations>(lookupFastLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_FastLocalizationsDelegate old) => false;
}

FastLocalizations lookupFastLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return FastLocalizationsEn();
  }

  throw FlutterError(
    'FastLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
