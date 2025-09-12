import 'base_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class BaseLocalizationsEn extends BaseLocalizations {
  BaseLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_divide_text => '-----------------------------';

  @override
  String get app_label_no_location_information => '未获取到位置信息';

  @override
  String get app_label_please_add_attachments => '请添加附件';

  @override
  String get app_label_un_submitted => '未提交';

  @override
  String get app_label_starting_time => '开始时间';

  @override
  String get app_label_end_time => '结束时间';

  @override
  String get app_label_personal_information => '个人信息';

  @override
  String get app_label_logging_in => '正在登录';

  @override
  String get app_toast_login_login_successful => '登录成功';

  @override
  String get app_toast_login_login_failed => '登录失败';

  @override
  String get app_label_login_normal_unauthorized => '登录失效，请重新登录！';

  @override
  String get app_label_show_sort => '显示排序';

  @override
  String get app_label_status => '状态';

  @override
  String get app_label_photograph => '拍照';

  @override
  String get app_label_photo_album => '相册';

  @override
  String get app_label_image_crop => '裁剪';

  @override
  String get app_label_select_file => '选择文件';

  @override
  String get app_label_crop_ing => '正在裁剪...';

  @override
  String get app_label_open_url_in_sys_browser => '在系统浏览器打开';
}
