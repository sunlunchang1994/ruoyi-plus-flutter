import 'main_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class MainLocalizationsEn extends MainLocalizations {
  MainLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get main_divide_text => '-----------------------------';

  @override
  String get analyse_label_title => '分析';

  @override
  String get analyse_label_week_online => '在线统计';

  @override
  String get analyse_label_traffic_trends => '流量趋势';

  @override
  String get analyse_label_month_visits => '月访问量';

  @override
  String get analyse_label_access_source => '访问来源';

  @override
  String get analyse_label_access_trends => '访问趋势';
}
