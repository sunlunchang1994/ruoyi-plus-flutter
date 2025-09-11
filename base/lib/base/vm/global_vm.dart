import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/mvvm/base_mvvm.dart';
import '../repository/local/app_config.dart';

/// @author sunlunchang
/// 全局的vm，在系统初始化时就存在，多个模块的基础共享和缓存可在此处配置
/// 单例模式
class GlobalVm extends AbsoluteChangeNotifier {
  GlobalVm._privateConstructor();

  static final GlobalVm _instance = GlobalVm._privateConstructor();

  factory GlobalVm() {
    return _instance;
  }

  final Map<String, dynamic> globalCache = {};

  //final mixManager = MixManager();

  ThemeMode _themeMode = AppConfig().getThemeMode();

  ThemeMode get currentTheme => _themeMode;

  void switchThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    AppConfig().setThemeMode(themeMode);
    notifyListeners();
  }
}
