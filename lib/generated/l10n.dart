// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `ruoyi-plus-flutter`
  String get app_name {
    return Intl.message(
      'ruoyi-plus-flutter',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Label{name}`
  String label_params(Object name) {
    return Intl.message(
      'Label$name',
      name: 'label_params',
      desc: '',
      args: [name],
    );
  }

  /// `-----------------------------`
  String get action_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'action_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `保存`
  String get action_save {
    return Intl.message(
      '保存',
      name: 'action_save',
      desc: '',
      args: [],
    );
  }

  /// `编辑`
  String get action_edit {
    return Intl.message(
      '编辑',
      name: 'action_edit',
      desc: '',
      args: [],
    );
  }

  /// `添加`
  String get action_add {
    return Intl.message(
      '添加',
      name: 'action_add',
      desc: '',
      args: [],
    );
  }

  /// `下一步`
  String get action_next_step {
    return Intl.message(
      '下一步',
      name: 'action_next_step',
      desc: '',
      args: [],
    );
  }

  /// `上一步`
  String get action_pre_step {
    return Intl.message(
      '上一步',
      name: 'action_pre_step',
      desc: '',
      args: [],
    );
  }

  /// `删除`
  String get action_delete {
    return Intl.message(
      '删除',
      name: 'action_delete',
      desc: '',
      args: [],
    );
  }

  /// `移除`
  String get action_remove {
    return Intl.message(
      '移除',
      name: 'action_remove',
      desc: '',
      args: [],
    );
  }

  /// `重置`
  String get action_reset {
    return Intl.message(
      '重置',
      name: 'action_reset',
      desc: '',
      args: [],
    );
  }

  /// `搜索`
  String get action_search {
    return Intl.message(
      '搜索',
      name: 'action_search',
      desc: '',
      args: [],
    );
  }

  /// `确定`
  String get action_ok {
    return Intl.message(
      '确定',
      name: 'action_ok',
      desc: '',
      args: [],
    );
  }

  /// `确认`
  String get action_confirm {
    return Intl.message(
      '确认',
      name: 'action_confirm',
      desc: '',
      args: [],
    );
  }

  /// `关闭`
  String get action_close {
    return Intl.message(
      '关闭',
      name: 'action_close',
      desc: '',
      args: [],
    );
  }

  /// `退出`
  String get action_exit {
    return Intl.message(
      '退出',
      name: 'action_exit',
      desc: '',
      args: [],
    );
  }

  /// `不保存退出`
  String get action_exit_without_save {
    return Intl.message(
      '不保存退出',
      name: 'action_exit_without_save',
      desc: '',
      args: [],
    );
  }

  /// `发送`
  String get action_send {
    return Intl.message(
      '发送',
      name: 'action_send',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get action_setting {
    return Intl.message(
      '设置',
      name: 'action_setting',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get action_cancel {
    return Intl.message(
      '取消',
      name: 'action_cancel',
      desc: '',
      args: [],
    );
  }

  /// `不再提示`
  String get action_do_not_remind_again {
    return Intl.message(
      '不再提示',
      name: 'action_do_not_remind_again',
      desc: '',
      args: [],
    );
  }

  /// `完成`
  String get action_complete {
    return Intl.message(
      '完成',
      name: 'action_complete',
      desc: '',
      args: [],
    );
  }

  /// `提交`
  String get action_submit {
    return Intl.message(
      '提交',
      name: 'action_submit',
      desc: '',
      args: [],
    );
  }

  /// `我知道了`
  String get action_i_know {
    return Intl.message(
      '我知道了',
      name: 'action_i_know',
      desc: '',
      args: [],
    );
  }

  /// `继续`
  String get action_continue {
    return Intl.message(
      '继续',
      name: 'action_continue',
      desc: '',
      args: [],
    );
  }

  /// `查看`
  String get action_look {
    return Intl.message(
      '查看',
      name: 'action_look',
      desc: '',
      args: [],
    );
  }

  /// `拒绝`
  String get action_deny {
    return Intl.message(
      '拒绝',
      name: 'action_deny',
      desc: '',
      args: [],
    );
  }

  /// `筛选`
  String get action_filter {
    return Intl.message(
      '筛选',
      name: 'action_filter',
      desc: '',
      args: [],
    );
  }

  /// `全部`
  String get action_entire {
    return Intl.message(
      '全部',
      name: 'action_entire',
      desc: '',
      args: [],
    );
  }

  /// `导入`
  String get action_import {
    return Intl.message(
      '导入',
      name: 'action_import',
      desc: '',
      args: [],
    );
  }

  /// `导出`
  String get action_export {
    return Intl.message(
      '导出',
      name: 'action_export',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get label_common_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'label_common_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `提示`
  String get label_prompt {
    return Intl.message(
      '提示',
      name: 'label_prompt',
      desc: '',
      args: [],
    );
  }

  /// `默认`
  String get label_def {
    return Intl.message(
      '默认',
      name: 'label_def',
      desc: '',
      args: [],
    );
  }

  /// `正在运行`
  String get label_running {
    return Intl.message(
      '正在运行',
      name: 'label_running',
      desc: '',
      args: [],
    );
  }

  /// `我们需要获取读写存储器权限才能进行文件选择操作！`
  String get label_permission_file_picker_hint {
    return Intl.message(
      '我们需要获取读写存储器权限才能进行文件选择操作！',
      name: 'label_permission_file_picker_hint',
      desc: '',
      args: [],
    );
  }

  /// `这是我们需要的最基本的权限，请授予允许！`
  String get label_permission_base_hint {
    return Intl.message(
      '这是我们需要的最基本的权限，请授予允许！',
      name: 'label_permission_base_hint',
      desc: '',
      args: [],
    );
  }

  /// `这是我们需要的最基本的权限，请在设置界面中授予允许！`
  String get label_permission_base_setting_hint {
    return Intl.message(
      '这是我们需要的最基本的权限，请在设置界面中授予允许！',
      name: 'label_permission_base_setting_hint',
      desc: '',
      args: [],
    );
  }

  /// `您没有授予最基本的权限，部分功能将无法使用！`
  String get label_permission_base_hint_denied {
    return Intl.message(
      '您没有授予最基本的权限，部分功能将无法使用！',
      name: 'label_permission_base_hint_denied',
      desc: '',
      args: [],
    );
  }

  /// `内容不能为空或空格`
  String get label_content_cannot_be_empty_blank {
    return Intl.message(
      '内容不能为空或空格',
      name: 'label_content_cannot_be_empty_blank',
      desc: '',
      args: [],
    );
  }

  /// `参数丢失`
  String get label_select_parameter_is_missing {
    return Intl.message(
      '参数丢失',
      name: 'label_select_parameter_is_missing',
      desc: '',
      args: [],
    );
  }

  /// `登录超时，请重新登录！`
  String get label_token_failure_prompt {
    return Intl.message(
      '登录超时，请重新登录！',
      name: 'label_token_failure_prompt',
      desc: '',
      args: [],
    );
  }

  /// `正在加载...`
  String get label_loading {
    return Intl.message(
      '正在加载...',
      name: 'label_loading',
      desc: '',
      args: [],
    );
  }

  /// `加载成功`
  String get label_loading_success {
    return Intl.message(
      '加载成功',
      name: 'label_loading_success',
      desc: '',
      args: [],
    );
  }

  /// `加载失败`
  String get label_loading_failure {
    return Intl.message(
      '加载失败',
      name: 'label_loading_failure',
      desc: '',
      args: [],
    );
  }

  /// `正在删除...`
  String get label_delete_ing {
    return Intl.message(
      '正在删除...',
      name: 'label_delete_ing',
      desc: '',
      args: [],
    );
  }

  /// `确认删除？`
  String get label_delete_really {
    return Intl.message(
      '确认删除？',
      name: 'label_delete_really',
      desc: '',
      args: [],
    );
  }

  /// `删除成功`
  String get label_delete_success {
    return Intl.message(
      '删除成功',
      name: 'label_delete_success',
      desc: '',
      args: [],
    );
  }

  /// `删除失败`
  String get label_delete_failed {
    return Intl.message(
      '删除失败',
      name: 'label_delete_failed',
      desc: '',
      args: [],
    );
  }

  /// `上传文件失败`
  String get label_file_upload_by_file_failed {
    return Intl.message(
      '上传文件失败',
      name: 'label_file_upload_by_file_failed',
      desc: '',
      args: [],
    );
  }

  /// `下载文件失败`
  String get label_file_download_failed {
    return Intl.message(
      '下载文件失败',
      name: 'label_file_download_failed',
      desc: '',
      args: [],
    );
  }

  /// `下载文件失败 请重试`
  String get label_file_download_failed_download_file_failed {
    return Intl.message(
      '下载文件失败 请重试',
      name: 'label_file_download_failed_download_file_failed',
      desc: '',
      args: [],
    );
  }

  /// `正在上传`
  String get label_file_are_uploading {
    return Intl.message(
      '正在上传',
      name: 'label_file_are_uploading',
      desc: '',
      args: [],
    );
  }

  /// `上传失败`
  String get label_file_upload_failed {
    return Intl.message(
      '上传失败',
      name: 'label_file_upload_failed',
      desc: '',
      args: [],
    );
  }

  /// `上传成功`
  String get label_file_uploaded_success {
    return Intl.message(
      '上传成功',
      name: 'label_file_uploaded_success',
      desc: '',
      args: [],
    );
  }

  /// `正在提交...`
  String get label_submit_ing {
    return Intl.message(
      '正在提交...',
      name: 'label_submit_ing',
      desc: '',
      args: [],
    );
  }

  /// `提交成功`
  String get label_submitted_success {
    return Intl.message(
      '提交成功',
      name: 'label_submitted_success',
      desc: '',
      args: [],
    );
  }

  /// `提交失败`
  String get label_submitted_failure {
    return Intl.message(
      '提交失败',
      name: 'label_submitted_failure',
      desc: '',
      args: [],
    );
  }

  /// `修改成功`
  String get toast_edit_success {
    return Intl.message(
      '修改成功',
      name: 'toast_edit_success',
      desc: '',
      args: [],
    );
  }

  /// `修改失败`
  String get toast_edit_failure {
    return Intl.message(
      '修改失败',
      name: 'toast_edit_failure',
      desc: '',
      args: [],
    );
  }

  /// `操作失败`
  String get label_operation_failed {
    return Intl.message(
      '操作失败',
      name: 'label_operation_failed',
      desc: '',
      args: [],
    );
  }

  /// `正在保存...`
  String get label_save_ing {
    return Intl.message(
      '正在保存...',
      name: 'label_save_ing',
      desc: '',
      args: [],
    );
  }

  /// `保存失败`
  String get label_save_failed {
    return Intl.message(
      '保存失败',
      name: 'label_save_failed',
      desc: '',
      args: [],
    );
  }

  /// `保存成功`
  String get label_success_saved {
    return Intl.message(
      '保存成功',
      name: 'label_success_saved',
      desc: '',
      args: [],
    );
  }

  /// `正在退出...`
  String get label_exiting {
    return Intl.message(
      '正在退出...',
      name: 'label_exiting',
      desc: '',
      args: [],
    );
  }

  /// `正在重启`
  String get label_restarting {
    return Intl.message(
      '正在重启',
      name: 'label_restarting',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get label_update_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'label_update_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `暂不更新`
  String get action_temporarily_not_update {
    return Intl.message(
      '暂不更新',
      name: 'action_temporarily_not_update',
      desc: '',
      args: [],
    );
  }

  /// `立即更新`
  String get action_update_now {
    return Intl.message(
      '立即更新',
      name: 'action_update_now',
      desc: '',
      args: [],
    );
  }

  /// `正在获取安装包`
  String get action_get_the_installation_package {
    return Intl.message(
      '正在获取安装包',
      name: 'action_get_the_installation_package',
      desc: '',
      args: [],
    );
  }

  /// `有最新版本`
  String get title_the_latest_version {
    return Intl.message(
      '有最新版本',
      name: 'title_the_latest_version',
      desc: '',
      args: [],
    );
  }

  /// `已是最新版本`
  String get title_already_the_latest_version {
    return Intl.message(
      '已是最新版本',
      name: 'title_already_the_latest_version',
      desc: '',
      args: [],
    );
  }

  /// `正在更新`
  String get title_be_updating {
    return Intl.message(
      '正在更新',
      name: 'title_be_updating',
      desc: '',
      args: [],
    );
  }

  /// `已下载%1$s`
  String get label_completed_size {
    return Intl.message(
      '已下载%1\$s',
      name: 'label_completed_size',
      desc: '',
      args: [],
    );
  }

  /// `下载完成`
  String get action_download_on_success {
    return Intl.message(
      '下载完成',
      name: 'action_download_on_success',
      desc: '',
      args: [],
    );
  }

  /// `立即安装`
  String get action_install_now {
    return Intl.message(
      '立即安装',
      name: 'action_install_now',
      desc: '',
      args: [],
    );
  }

  /// `下载出错`
  String get action_download_on_error {
    return Intl.message(
      '下载出错',
      name: 'action_download_on_error',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get label_list_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'label_list_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `暂时没有数据`
  String get label_there_is_no_data_at_present {
    return Intl.message(
      '暂时没有数据',
      name: 'label_there_is_no_data_at_present',
      desc: '',
      args: [],
    );
  }

  /// `下载出错，点击重试`
  String get action_download_on_error_click_retry {
    return Intl.message(
      '下载出错，点击重试',
      name: 'action_download_on_error_click_retry',
      desc: '',
      args: [],
    );
  }

  /// `获取数据失败`
  String get label_data_acquisition_failed {
    return Intl.message(
      '获取数据失败',
      name: 'label_data_acquisition_failed',
      desc: '',
      args: [],
    );
  }

  /// `无效的数据`
  String get label_invalid_data {
    return Intl.message(
      '无效的数据',
      name: 'label_invalid_data',
      desc: '',
      args: [],
    );
  }

  /// `数据为空`
  String get label_data_is_null {
    return Intl.message(
      '数据为空',
      name: 'label_data_is_null',
      desc: '',
      args: [],
    );
  }

  /// `未知异常`
  String get label_unknown_exception {
    return Intl.message(
      '未知异常',
      name: 'label_unknown_exception',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get label_select_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'label_select_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `全部`
  String get label_state_complete {
    return Intl.message(
      '全部',
      name: 'label_state_complete',
      desc: '',
      args: [],
    );
  }

  /// `已完成`
  String get label_state_completed {
    return Intl.message(
      '已完成',
      name: 'label_state_completed',
      desc: '',
      args: [],
    );
  }

  /// `未完成`
  String get label_state_undone {
    return Intl.message(
      '未完成',
      name: 'label_state_undone',
      desc: '',
      args: [],
    );
  }

  /// `已选择`
  String get label_state_selected {
    return Intl.message(
      '已选择',
      name: 'label_state_selected',
      desc: '',
      args: [],
    );
  }

  /// `未选择`
  String get label_state_not_selected {
    return Intl.message(
      '未选择',
      name: 'label_state_not_selected',
      desc: '',
      args: [],
    );
  }

  /// `您的选择未进行确认，是否确认完成？`
  String get label_select_undone_prompt {
    return Intl.message(
      '您的选择未进行确认，是否确认完成？',
      name: 'label_select_undone_prompt',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get label_unit_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'label_unit_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `个`
  String get label_unit_entries {
    return Intl.message(
      '个',
      name: 'label_unit_entries',
      desc: '',
      args: [],
    );
  }

  /// `%s个`
  String get label_unit_entries_x {
    return Intl.message(
      '%s个',
      name: 'label_unit_entries_x',
      desc: '',
      args: [],
    );
  }

  /// `人`
  String get label_unit_person {
    return Intl.message(
      '人',
      name: 'label_unit_person',
      desc: '',
      args: [],
    );
  }

  /// `%s人`
  String get label_unit_person_x {
    return Intl.message(
      '%s人',
      name: 'label_unit_person_x',
      desc: '',
      args: [],
    );
  }

  /// `条`
  String get label_unit_strip {
    return Intl.message(
      '条',
      name: 'label_unit_strip',
      desc: '',
      args: [],
    );
  }

  /// `%s条`
  String get label_unit_strip_x {
    return Intl.message(
      '%s条',
      name: 'label_unit_strip_x',
      desc: '',
      args: [],
    );
  }

  /// `辆`
  String get label_unit_car {
    return Intl.message(
      '辆',
      name: 'label_unit_car',
      desc: '',
      args: [],
    );
  }

  /// `%s辆`
  String get label_unit_car_x {
    return Intl.message(
      '%s辆',
      name: 'label_unit_car_x',
      desc: '',
      args: [],
    );
  }

  /// `只`
  String get label_unit_merely {
    return Intl.message(
      '只',
      name: 'label_unit_merely',
      desc: '',
      args: [],
    );
  }

  /// `%s只`
  String get label_unit_merely_x {
    return Intl.message(
      '%s只',
      name: 'label_unit_merely_x',
      desc: '',
      args: [],
    );
  }

  /// `元`
  String get label_unit_element {
    return Intl.message(
      '元',
      name: 'label_unit_element',
      desc: '',
      args: [],
    );
  }

  /// `%s元`
  String get label_unit_element_x {
    return Intl.message(
      '%s元',
      name: 'label_unit_element_x',
      desc: '',
      args: [],
    );
  }

  /// `米`
  String get label_unit_meter {
    return Intl.message(
      '米',
      name: 'label_unit_meter',
      desc: '',
      args: [],
    );
  }

  /// `%s米`
  String get label_unit_meter_x {
    return Intl.message(
      '%s米',
      name: 'label_unit_meter_x',
      desc: '',
      args: [],
    );
  }

  /// `千米`
  String get label_unit_Kilometer {
    return Intl.message(
      '千米',
      name: 'label_unit_Kilometer',
      desc: '',
      args: [],
    );
  }

  /// `%s千米`
  String get label_unit_Kilometer_x {
    return Intl.message(
      '%s千米',
      name: 'label_unit_Kilometer_x',
      desc: '',
      args: [],
    );
  }

  /// `年`
  String get label_unit_year {
    return Intl.message(
      '年',
      name: 'label_unit_year',
      desc: '',
      args: [],
    );
  }

  /// `%s年`
  String get label_unit_year_x {
    return Intl.message(
      '%s年',
      name: 'label_unit_year_x',
      desc: '',
      args: [],
    );
  }

  /// `月`
  String get label_unit_month {
    return Intl.message(
      '月',
      name: 'label_unit_month',
      desc: '',
      args: [],
    );
  }

  /// `%s月`
  String get label_unit_month_x {
    return Intl.message(
      '%s月',
      name: 'label_unit_month_x',
      desc: '',
      args: [],
    );
  }

  /// `日`
  String get label_unit_day {
    return Intl.message(
      '日',
      name: 'label_unit_day',
      desc: '',
      args: [],
    );
  }

  /// `%s日`
  String get label_unit_day_x {
    return Intl.message(
      '%s日',
      name: 'label_unit_day_x',
      desc: '',
      args: [],
    );
  }

  /// `%s年%s月`
  String get label_unit_year_x_month_x {
    return Intl.message(
      '%s年%s月',
      name: 'label_unit_year_x_month_x',
      desc: '',
      args: [],
    );
  }

  /// `%s年%s月%s日`
  String get label_unit_year_x_month_x_day_x {
    return Intl.message(
      '%s年%s月%s日',
      name: 'label_unit_year_x_month_x_day_x',
      desc: '',
      args: [],
    );
  }

  /// `小时`
  String get label_unit_hour {
    return Intl.message(
      '小时',
      name: 'label_unit_hour',
      desc: '',
      args: [],
    );
  }

  /// `%s小时`
  String get label_unit_hour_x {
    return Intl.message(
      '%s小时',
      name: 'label_unit_hour_x',
      desc: '',
      args: [],
    );
  }

  /// `分`
  String get label_unit_minute {
    return Intl.message(
      '分',
      name: 'label_unit_minute',
      desc: '',
      args: [],
    );
  }

  /// `%s分`
  String get label_unit_minute_x {
    return Intl.message(
      '%s分',
      name: 'label_unit_minute_x',
      desc: '',
      args: [],
    );
  }

  /// `分种`
  String get label_unit_minute2 {
    return Intl.message(
      '分种',
      name: 'label_unit_minute2',
      desc: '',
      args: [],
    );
  }

  /// `%s分种`
  String get label_unit_minute2_x {
    return Intl.message(
      '%s分种',
      name: 'label_unit_minute2_x',
      desc: '',
      args: [],
    );
  }

  /// `秒`
  String get label_unit_second {
    return Intl.message(
      '秒',
      name: 'label_unit_second',
      desc: '',
      args: [],
    );
  }

  /// `%s秒`
  String get label_unit_second_x {
    return Intl.message(
      '%s秒',
      name: 'label_unit_second_x',
      desc: '',
      args: [],
    );
  }

  /// `毫秒`
  String get label_unit_millisecond {
    return Intl.message(
      '毫秒',
      name: 'label_unit_millisecond',
      desc: '',
      args: [],
    );
  }

  /// `%s毫秒`
  String get label_unit_millisecond_x {
    return Intl.message(
      '%s毫秒',
      name: 'label_unit_millisecond_x',
      desc: '',
      args: [],
    );
  }

  /// `天`
  String get label_unit_day2 {
    return Intl.message(
      '天',
      name: 'label_unit_day2',
      desc: '',
      args: [],
    );
  }

  /// `%s天`
  String get label_unit_day2_x {
    return Intl.message(
      '%s天',
      name: 'label_unit_day2_x',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get label_form_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'label_form_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `姓名`
  String get label_full_name {
    return Intl.message(
      '姓名',
      name: 'label_full_name',
      desc: '',
      args: [],
    );
  }

  /// `姓名：%s`
  String get label_full_name_x {
    return Intl.message(
      '姓名：%s',
      name: 'label_full_name_x',
      desc: '',
      args: [],
    );
  }

  /// `电话`
  String get label_tel {
    return Intl.message(
      '电话',
      name: 'label_tel',
      desc: '',
      args: [],
    );
  }

  /// `电话：%s`
  String get label_tel_x {
    return Intl.message(
      '电话：%s',
      name: 'label_tel_x',
      desc: '',
      args: [],
    );
  }

  /// `手机`
  String get label_phone {
    return Intl.message(
      '手机',
      name: 'label_phone',
      desc: '',
      args: [],
    );
  }

  /// `手机：%s`
  String get label_phone_x {
    return Intl.message(
      '手机：%s',
      name: 'label_phone_x',
      desc: '',
      args: [],
    );
  }

  /// `邮箱`
  String get label_mailbox {
    return Intl.message(
      '邮箱',
      name: 'label_mailbox',
      desc: '',
      args: [],
    );
  }

  /// `邮箱：%s`
  String get label_mailbox_x {
    return Intl.message(
      '邮箱：%s',
      name: 'label_mailbox_x',
      desc: '',
      args: [],
    );
  }

  /// `微信`
  String get label_wechat {
    return Intl.message(
      '微信',
      name: 'label_wechat',
      desc: '',
      args: [],
    );
  }

  /// `微信：%s`
  String get label_wechat_x {
    return Intl.message(
      '微信：%s',
      name: 'label_wechat_x',
      desc: '',
      args: [],
    );
  }

  /// `地址`
  String get label_address {
    return Intl.message(
      '地址',
      name: 'label_address',
      desc: '',
      args: [],
    );
  }

  /// `地址：%s`
  String get label_address_x {
    return Intl.message(
      '地址：%s',
      name: 'label_address_x',
      desc: '',
      args: [],
    );
  }

  /// `职务`
  String get label_job_title {
    return Intl.message(
      '职务',
      name: 'label_job_title',
      desc: '',
      args: [],
    );
  }

  /// `职务：%s`
  String get label_job_title_x {
    return Intl.message(
      '职务：%s',
      name: 'label_job_title_x',
      desc: '',
      args: [],
    );
  }

  /// `身份证`
  String get label_id_card {
    return Intl.message(
      '身份证',
      name: 'label_id_card',
      desc: '',
      args: [],
    );
  }

  /// `身份证：%s`
  String get label_id_card_x {
    return Intl.message(
      '身份证：%s',
      name: 'label_id_card_x',
      desc: '',
      args: [],
    );
  }

  /// `公司`
  String get label_company {
    return Intl.message(
      '公司',
      name: 'label_company',
      desc: '',
      args: [],
    );
  }

  /// `公司：%s`
  String get label_company_x {
    return Intl.message(
      '公司：%s',
      name: 'label_company_x',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get label_refresh_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'label_refresh_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `上拉加载更多`
  String get label_refresh_load_complete {
    return Intl.message(
      '上拉加载更多',
      name: 'label_refresh_load_complete',
      desc: '',
      args: [],
    );
  }

  /// `没有更多数据`
  String get label_refresh_load_end {
    return Intl.message(
      '没有更多数据',
      name: 'label_refresh_load_end',
      desc: '',
      args: [],
    );
  }

  /// `加载失败，请重试`
  String get label_refresh_load_failed {
    return Intl.message(
      '加载失败，请重试',
      name: 'label_refresh_load_failed',
      desc: '',
      args: [],
    );
  }

  /// `正在加载中...`
  String get label_refresh_loading {
    return Intl.message(
      '正在加载中...',
      name: 'label_refresh_loading',
      desc: '',
      args: [],
    );
  }

  /// `加载成功`
  String get label_refresh_loading_succeed {
    return Intl.message(
      '加载成功',
      name: 'label_refresh_loading_succeed',
      desc: '',
      args: [],
    );
  }

  /// `--我是有底线的--`
  String get label_refresh_loading_no_more {
    return Intl.message(
      '--我是有底线的--',
      name: 'label_refresh_loading_no_more',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get app_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'app_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `我们需要获取位置权限才能进定位！`
  String get app_label_location_permission_hint {
    return Intl.message(
      '我们需要获取位置权限才能进定位！',
      name: 'app_label_location_permission_hint',
      desc: '',
      args: [],
    );
  }

  /// `使用该功能需要位置权限，请授予允许！`
  String get app_label_location_permission_request_hint {
    return Intl.message(
      '使用该功能需要位置权限，请授予允许！',
      name: 'app_label_location_permission_request_hint',
      desc: '',
      args: [],
    );
  }

  /// `您没有授予位置权限，此功能将无法使用！`
  String get app_label_location_permission_request_hint_denied {
    return Intl.message(
      '您没有授予位置权限，此功能将无法使用！',
      name: 'app_label_location_permission_request_hint_denied',
      desc: '',
      args: [],
    );
  }

  /// `未知文件`
  String get app_label_unknown_file {
    return Intl.message(
      '未知文件',
      name: 'app_label_unknown_file',
      desc: '',
      args: [],
    );
  }

  /// `压缩文件`
  String get app_label_compressed_file {
    return Intl.message(
      '压缩文件',
      name: 'app_label_compressed_file',
      desc: '',
      args: [],
    );
  }

  /// `点击预览`
  String get app_label_click_preview {
    return Intl.message(
      '点击预览',
      name: 'app_label_click_preview',
      desc: '',
      args: [],
    );
  }

  /// `请等待下载完成`
  String get app_label_please_wait_for_the_download_to_complete {
    return Intl.message(
      '请等待下载完成',
      name: 'app_label_please_wait_for_the_download_to_complete',
      desc: '',
      args: [],
    );
  }

  /// `开始时间必须小于结束时间`
  String get app_label_start_time_less_than_end_time {
    return Intl.message(
      '开始时间必须小于结束时间',
      name: 'app_label_start_time_less_than_end_time',
      desc: '',
      args: [],
    );
  }

  /// `结束时间必须大于开始时间`
  String get app_label_end_time_more_than_the_start_time {
    return Intl.message(
      '结束时间必须大于开始时间',
      name: 'app_label_end_time_more_than_the_start_time',
      desc: '',
      args: [],
    );
  }

  /// `请选择`
  String get app_label_please_choose {
    return Intl.message(
      '请选择',
      name: 'app_label_please_choose',
      desc: '',
      args: [],
    );
  }

  /// `请输入`
  String get app_label_please_input {
    return Intl.message(
      '请输入',
      name: 'app_label_please_input',
      desc: '',
      args: [],
    );
  }

  /// `待完善`
  String get app_label_not_completed {
    return Intl.message(
      '待完善',
      name: 'app_label_not_completed',
      desc: '',
      args: [],
    );
  }

  /// `未填写`
  String get app_label_unfilled {
    return Intl.message(
      '未填写',
      name: 'app_label_unfilled',
      desc: '',
      args: [],
    );
  }

  /// `添加附件`
  String get app_label_add_attachments {
    return Intl.message(
      '添加附件',
      name: 'app_label_add_attachments',
      desc: '',
      args: [],
    );
  }

  /// `添加明细`
  String get app_label_add_add_details {
    return Intl.message(
      '添加明细',
      name: 'app_label_add_add_details',
      desc: '',
      args: [],
    );
  }

  /// `没有附件`
  String get app_label_add_no_attachments {
    return Intl.message(
      '没有附件',
      name: 'app_label_add_no_attachments',
      desc: '',
      args: [],
    );
  }

  /// `附件获取失败`
  String get app_label_get_attachments_error {
    return Intl.message(
      '附件获取失败',
      name: 'app_label_get_attachments_error',
      desc: '',
      args: [],
    );
  }

  /// `必要信息不能为空`
  String get app_label_required_information_cannot_be_empty {
    return Intl.message(
      '必要信息不能为空',
      name: 'app_label_required_information_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `同意`
  String get app_label_agree {
    return Intl.message(
      '同意',
      name: 'app_label_agree',
      desc: '',
      args: [],
    );
  }

  /// `全选`
  String get app_label_select_all {
    return Intl.message(
      '全选',
      name: 'app_label_select_all',
      desc: '',
      args: [],
    );
  }

  /// `全不选`
  String get app_label_unselect_all {
    return Intl.message(
      '全不选',
      name: 'app_label_unselect_all',
      desc: '',
      args: [],
    );
  }

  /// `通过`
  String get app_label_pass {
    return Intl.message(
      '通过',
      name: 'app_label_pass',
      desc: '',
      args: [],
    );
  }

  /// `拒绝`
  String get app_label_refuse {
    return Intl.message(
      '拒绝',
      name: 'app_label_refuse',
      desc: '',
      args: [],
    );
  }

  /// `备注`
  String get app_label_remark {
    return Intl.message(
      '备注',
      name: 'app_label_remark',
      desc: '',
      args: [],
    );
  }

  /// `无`
  String get app_label_not {
    return Intl.message(
      '无',
      name: 'app_label_not',
      desc: '',
      args: [],
    );
  }

  /// `元`
  String get app_label_yuan {
    return Intl.message(
      '元',
      name: 'app_label_yuan',
      desc: '',
      args: [],
    );
  }

  /// `部门：%1$s`
  String get app_label_department_x {
    return Intl.message(
      '部门：%1\$s',
      name: 'app_label_department_x',
      desc: '',
      args: [],
    );
  }

  /// `部门`
  String get app_label_department {
    return Intl.message(
      '部门',
      name: 'app_label_department',
      desc: '',
      args: [],
    );
  }

  /// `岗位：%1$s`
  String get app_label_post_x {
    return Intl.message(
      '岗位：%1\$s',
      name: 'app_label_post_x',
      desc: '',
      args: [],
    );
  }

  /// `岗位`
  String get app_label_post {
    return Intl.message(
      '岗位',
      name: 'app_label_post',
      desc: '',
      args: [],
    );
  }

  /// `上午`
  String get app_label_am {
    return Intl.message(
      '上午',
      name: 'app_label_am',
      desc: '',
      args: [],
    );
  }

  /// `下午`
  String get app_label_pm {
    return Intl.message(
      '下午',
      name: 'app_label_pm',
      desc: '',
      args: [],
    );
  }

  /// `全天`
  String get app_label_am_pm_full {
    return Intl.message(
      '全天',
      name: 'app_label_am_pm_full',
      desc: '',
      args: [],
    );
  }

  /// `错误`
  String get app_label_am_pm_error {
    return Intl.message(
      '错误',
      name: 'app_label_am_pm_error',
      desc: '',
      args: [],
    );
  }

  /// `未获取到位置信息`
  String get app_label_no_location_information {
    return Intl.message(
      '未获取到位置信息',
      name: 'app_label_no_location_information',
      desc: '',
      args: [],
    );
  }

  /// `请添加附件`
  String get app_label_please_add_attachments {
    return Intl.message(
      '请添加附件',
      name: 'app_label_please_add_attachments',
      desc: '',
      args: [],
    );
  }

  /// `未提交`
  String get app_label_un_submitted {
    return Intl.message(
      '未提交',
      name: 'app_label_un_submitted',
      desc: '',
      args: [],
    );
  }

  /// `开始时间`
  String get app_label_starting_time {
    return Intl.message(
      '开始时间',
      name: 'app_label_starting_time',
      desc: '',
      args: [],
    );
  }

  /// `结束时间`
  String get app_label_end_time {
    return Intl.message(
      '结束时间',
      name: 'app_label_end_time',
      desc: '',
      args: [],
    );
  }

  /// `附件`
  String get app_label_attachment {
    return Intl.message(
      '附件',
      name: 'app_label_attachment',
      desc: '',
      args: [],
    );
  }

  /// `个人信息`
  String get app_label_personal_information {
    return Intl.message(
      '个人信息',
      name: 'app_label_personal_information',
      desc: '',
      args: [],
    );
  }

  /// `正在登录`
  String get app_label_logging_in {
    return Intl.message(
      '正在登录',
      name: 'app_label_logging_in',
      desc: '',
      args: [],
    );
  }

  /// `登录成功`
  String get app_toast_login_login_successful {
    return Intl.message(
      '登录成功',
      name: 'app_toast_login_login_successful',
      desc: '',
      args: [],
    );
  }

  /// `登录失败`
  String get app_toast_login_login_failed {
    return Intl.message(
      '登录失败',
      name: 'app_toast_login_login_failed',
      desc: '',
      args: [],
    );
  }

  /// `拍照`
  String get app_label_photograph {
    return Intl.message(
      '拍照',
      name: 'app_label_photograph',
      desc: '',
      args: [],
    );
  }

  /// `相册`
  String get app_label_photo_album {
    return Intl.message(
      '相册',
      name: 'app_label_photo_album',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get user_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'user_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get user_label_setting {
    return Intl.message(
      '设置',
      name: 'user_label_setting',
      desc: '',
      args: [],
    );
  }

  /// `登录`
  String get user_label_login {
    return Intl.message(
      '登录',
      name: 'user_label_login',
      desc: '',
      args: [],
    );
  }

  /// `机构`
  String get user_label_tenant {
    return Intl.message(
      '机构',
      name: 'user_label_tenant',
      desc: '',
      args: [],
    );
  }

  /// `请选择机构`
  String get user_label_select_tenant {
    return Intl.message(
      '请选择机构',
      name: 'user_label_select_tenant',
      desc: '',
      args: [],
    );
  }

  /// `账号`
  String get user_label_account {
    return Intl.message(
      '账号',
      name: 'user_label_account',
      desc: '',
      args: [],
    );
  }

  /// `请输入账号`
  String get user_label_input_account {
    return Intl.message(
      '请输入账号',
      name: 'user_label_input_account',
      desc: '',
      args: [],
    );
  }

  /// `密码`
  String get user_label_password {
    return Intl.message(
      '密码',
      name: 'user_label_password',
      desc: '',
      args: [],
    );
  }

  /// `请输入密码`
  String get user_label_input_password {
    return Intl.message(
      '请输入密码',
      name: 'user_label_input_password',
      desc: '',
      args: [],
    );
  }

  /// `验证码`
  String get user_label_captcha_code {
    return Intl.message(
      '验证码',
      name: 'user_label_captcha_code',
      desc: '',
      args: [],
    );
  }

  /// `请输入验证码`
  String get user_label_input_captcha_code {
    return Intl.message(
      '请输入验证码',
      name: 'user_label_input_captcha_code',
      desc: '',
      args: [],
    );
  }

  /// `保存密码`
  String get user_label_save_password {
    return Intl.message(
      '保存密码',
      name: 'user_label_save_password',
      desc: '',
      args: [],
    );
  }

  /// `自动登录`
  String get user_label_auto_login {
    return Intl.message(
      '自动登录',
      name: 'user_label_auto_login',
      desc: '',
      args: [],
    );
  }

  /// `退出登录`
  String get user_label_sign_out {
    return Intl.message(
      '退出登录',
      name: 'user_label_sign_out',
      desc: '',
      args: [],
    );
  }

  /// `正在登录`
  String get user_label_logging_in {
    return Intl.message(
      '正在登录',
      name: 'user_label_logging_in',
      desc: '',
      args: [],
    );
  }

  /// `登录成功`
  String get user_toast_login_login_successful {
    return Intl.message(
      '登录成功',
      name: 'user_toast_login_login_successful',
      desc: '',
      args: [],
    );
  }

  /// `登录失败`
  String get user_toast_login_login_failed {
    return Intl.message(
      '登录失败',
      name: 'user_toast_login_login_failed',
      desc: '',
      args: [],
    );
  }

  /// `昵称`
  String get user_label_pet_name {
    return Intl.message(
      '昵称',
      name: 'user_label_pet_name',
      desc: '',
      args: [],
    );
  }

  /// `修改密码`
  String get user_label_edit_pass_word {
    return Intl.message(
      '修改密码',
      name: 'user_label_edit_pass_word',
      desc: '',
      args: [],
    );
  }

  /// `原密码`
  String get user_label_old_password {
    return Intl.message(
      '原密码',
      name: 'user_label_old_password',
      desc: '',
      args: [],
    );
  }

  /// `新密码`
  String get user_label_new_password {
    return Intl.message(
      '新密码',
      name: 'user_label_new_password',
      desc: '',
      args: [],
    );
  }

  /// `确认新密码`
  String get user_label_verify_new_password {
    return Intl.message(
      '确认新密码',
      name: 'user_label_verify_new_password',
      desc: '',
      args: [],
    );
  }

  /// `两次新密码不一致，请重新出入`
  String get user_label_verify_new_password_error {
    return Intl.message(
      '两次新密码不一致，请重新出入',
      name: 'user_label_verify_new_password_error',
      desc: '',
      args: [],
    );
  }

  /// `手机`
  String get user_label_cell_phone {
    return Intl.message(
      '手机',
      name: 'user_label_cell_phone',
      desc: '',
      args: [],
    );
  }

  /// `未开启基本权限,请授予该权限！`
  String get user_toast_base_permission {
    return Intl.message(
      '未开启基本权限,请授予该权限！',
      name: 'user_toast_base_permission',
      desc: '',
      args: [],
    );
  }

  /// `未开启基本权限,请手动到设置去开启权限`
  String get user_toast_base_permission_go_setting {
    return Intl.message(
      '未开启基本权限,请手动到设置去开启权限',
      name: 'user_toast_base_permission_go_setting',
      desc: '',
      args: [],
    );
  }

  /// `再次点击回到桌面`
  String get user_toast_click_again_to_return_to_the_desktop {
    return Intl.message(
      '再次点击回到桌面',
      name: 'user_toast_click_again_to_return_to_the_desktop',
      desc: '',
      args: [],
    );
  }

  /// `数据初始化失败，请卸载重装此APP`
  String get user_toast_data_init_error {
    return Intl.message(
      '数据初始化失败，请卸载重装此APP',
      name: 'user_toast_data_init_error',
      desc: '',
      args: [],
    );
  }

  /// `敬请期待`
  String get user_label_stay_tuned {
    return Intl.message(
      '敬请期待',
      name: 'user_label_stay_tuned',
      desc: '',
      args: [],
    );
  }

  /// `我的二维码`
  String get user_label_my_qr_code {
    return Intl.message(
      '我的二维码',
      name: 'user_label_my_qr_code',
      desc: '',
      args: [],
    );
  }

  /// `检查更新`
  String get user_label_check_for_updates {
    return Intl.message(
      '检查更新',
      name: 'user_label_check_for_updates',
      desc: '',
      args: [],
    );
  }

  /// `正在获取更新信息`
  String get user_label_check_for_updates_ing {
    return Intl.message(
      '正在获取更新信息',
      name: 'user_label_check_for_updates_ing',
      desc: '',
      args: [],
    );
  }

  /// `获取更新信息失败`
  String get user_label_check_for_updates_error {
    return Intl.message(
      '获取更新信息失败',
      name: 'user_label_check_for_updates_error',
      desc: '',
      args: [],
    );
  }

  /// `部门列表`
  String get user_label_dept_list {
    return Intl.message(
      '部门列表',
      name: 'user_label_dept_list',
      desc: '',
      args: [],
    );
  }

  /// `用户列表`
  String get user_label_user_info_list {
    return Intl.message(
      '用户列表',
      name: 'user_label_user_info_list',
      desc: '',
      args: [],
    );
  }

  /// `%s人`
  String get user_label_x_people {
    return Intl.message(
      '%s人',
      name: 'user_label_x_people',
      desc: '',
      args: [],
    );
  }

  /// `没有获取到部门信息`
  String get user_label_dept_not_found {
    return Intl.message(
      '没有获取到部门信息',
      name: 'user_label_dept_not_found',
      desc: '',
      args: [],
    );
  }

  /// `没有获取到用户信息`
  String get user_label_user_info_not_found {
    return Intl.message(
      '没有获取到用户信息',
      name: 'user_label_user_info_not_found',
      desc: '',
      args: [],
    );
  }

  /// `所有部门`
  String get user_label_all_dept {
    return Intl.message(
      '所有部门',
      name: 'user_label_all_dept',
      desc: '',
      args: [],
    );
  }

  /// `顶级部门`
  String get user_label_top_dept {
    return Intl.message(
      '顶级部门',
      name: 'user_label_top_dept',
      desc: '',
      args: [],
    );
  }

  /// `选择%s`
  String get user_label_select_x {
    return Intl.message(
      '选择%s',
      name: 'user_label_select_x',
      desc: '',
      args: [],
    );
  }

  /// `机构不能为空`
  String get user_label_tenant_not_empty_hint {
    return Intl.message(
      '机构不能为空',
      name: 'user_label_tenant_not_empty_hint',
      desc: '',
      args: [],
    );
  }

  /// `账号不能为空`
  String get user_label_account_not_empty_hint {
    return Intl.message(
      '账号不能为空',
      name: 'user_label_account_not_empty_hint',
      desc: '',
      args: [],
    );
  }

  /// `密码不能为空`
  String get user_label_password_bot_empty_hint {
    return Intl.message(
      '密码不能为空',
      name: 'user_label_password_bot_empty_hint',
      desc: '',
      args: [],
    );
  }

  /// `选择机构`
  String get user_label_tenant_select {
    return Intl.message(
      '选择机构',
      name: 'user_label_tenant_select',
      desc: '',
      args: [],
    );
  }

  /// `获取机构信息失败`
  String get user_label_tenant_get_info_error {
    return Intl.message(
      '获取机构信息失败',
      name: 'user_label_tenant_get_info_error',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get dict_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'dict_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `字典名`
  String get dict_label_ley {
    return Intl.message(
      '字典名',
      name: 'dict_label_ley',
      desc: '',
      args: [],
    );
  }

  /// `字典值`
  String get dict_label_name {
    return Intl.message(
      '字典值',
      name: 'dict_label_name',
      desc: '',
      args: [],
    );
  }

  /// `子节点`
  String get dict_label_child_node {
    return Intl.message(
      '子节点',
      name: 'dict_label_child_node',
      desc: '',
      args: [],
    );
  }

  /// `字典详情`
  String get dict_label_details {
    return Intl.message(
      '字典详情',
      name: 'dict_label_details',
      desc: '',
      args: [],
    );
  }

  /// `系统字典不允许修改`
  String get dict_label_system_dict_edit_hint {
    return Intl.message(
      '系统字典不允许修改',
      name: 'dict_label_system_dict_edit_hint',
      desc: '',
      args: [],
    );
  }

  /// `系统字典不允许删除`
  String get dict_label_system_dict_remove_hint {
    return Intl.message(
      '系统字典不允许删除',
      name: 'dict_label_system_dict_remove_hint',
      desc: '',
      args: [],
    );
  }

  /// `-----------------------------`
  String get main_divide_text {
    return Intl.message(
      '-----------------------------',
      name: 'main_divide_text',
      desc: '',
      args: [],
    );
  }

  /// `工作台`
  String get main_label_workbench {
    return Intl.message(
      '工作台',
      name: 'main_label_workbench',
      desc: '',
      args: [],
    );
  }

  /// `我的`
  String get main_label_mine {
    return Intl.message(
      '我的',
      name: 'main_label_mine',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
