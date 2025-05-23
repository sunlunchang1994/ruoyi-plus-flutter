import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import '/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';

class AppStyles extends SlcStyles {
  static ThemeData? _appLightTheme = null;
  static ThemeData? _appDarkTheme = null;

  ///MD3
  static ThemeData getAppLightThemeMD3() {
    _appLightTheme ??= SlcStyles.buildAppTheme().copyWith(
        appBarTheme: AppBarTheme(
      toolbarHeight: AppDimens.appBarHeight,
      titleSpacing: 0,
    ));
    return _appLightTheme!;
  }

  ///MD3
  static ThemeData getAppDarkThemeMD3() {
    _appDarkTheme ??= SlcStyles.buildAppTheme(brightness: Brightness.dark).copyWith(
        appBarTheme: AppBarTheme(
      toolbarHeight: AppDimens.appBarHeight,
      titleSpacing: 0,
    ));
    return _appDarkTheme!;
  }

  ///MD2风格
  static ThemeData getAppLightTheme() {
    if (_appLightTheme == null) {
      ColorScheme colorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue)
          .copyWith(surface: SlcColors.colorBackground);
      _appLightTheme = ThemeData(
          useMaterial3: false,
          colorScheme: colorScheme,
          cardColor: Colors.white,
          // 这个只是临时做法，为了符合人力通主题，是过时的
          appBarTheme: AppBarTheme(
              toolbarHeight: AppDimens.appBarHeight,
              toolbarTextStyle: TextStyle(color: colorScheme.onSurface),
              titleTextStyle: TextStyle(color: colorScheme.onSurface),
              iconTheme: IconThemeData(color: colorScheme.onSurface),
              actionsIconTheme: IconThemeData(color: colorScheme.onSurface),
              backgroundColor: Colors.white,
              elevation: 0),
          scaffoldBackgroundColor: SlcColors.colorBackground,
          hintColor: SlcTidyUpColor().globalHintTextColorBlack);
    }
    return _appLightTheme!;
  }
}

class SysStyle {
  //日志状态
  static const TextStyle sysLogListStatusText = TextStyle(fontSize: 12);
  static const StrutStyle sysLogListStatusTextStrutStyle =
      StrutStyle(forceStrutHeight: true, height: 0.9);
}
