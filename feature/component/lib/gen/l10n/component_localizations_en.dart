import 'component_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ComponentLocalizationsEn extends ComponentLocalizations {
  ComponentLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get comp_label_attachment => '附件';

  @override
  String get comp_label_unknown_file => '未知文件';

  @override
  String get comp_label_compressed_file => '压缩文件';

  @override
  String get comp_label_click_preview => '点击预览';

  @override
  String get comp_label_please_wait_for_the_download_to_complete => '请等待下载完成';

  @override
  String get comp_label_add_attachments => '添加附件';

  @override
  String get comp_label_add_no_attachments => '没有附件';

  @override
  String get comp_label_get_attachments_error => '附件获取失败';

  @override
  String get comp_label_file_downloaded => '文件已下载：%s';

  @override
  String get comp_label_check_browser_downloads => '请在浏览器的下载文件夹中查看';
}
