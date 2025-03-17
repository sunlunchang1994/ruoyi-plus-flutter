import 'package:flutter/material.dart';

import '../../../lib/db_base/dp_manager.dart';

class AppConfig extends DpManager {
  static const String SP_NAME = "app_config";

  AppConfig._privateConstructor() : super(SP_NAME);

  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }

  ThemeMode getThemeMode() {
    int? mode = getDp().getInt("themeMode", defValue: 0);
    switch (mode) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        getDp().putValue("themeMode", 1);
        break;
      case ThemeMode.dark:
        getDp().putValue("themeMode", 2);
        break;
      default:
        getDp().putValue("themeMode", 0);
        break;
    }
  }
}
