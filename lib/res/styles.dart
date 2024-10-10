import 'package:flutter/material.dart';
import '/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';

class AppStyles extends SlcStyles {
  static ThemeData? _appLightTheme = null;

  ///MD3
  static ThemeData getAppLightThemeMD3() {
    _appLightTheme ??= SlcStyles.appTheme.copyWith();
    return _appLightTheme!;
  }

  ///MD2风格
  static ThemeData getAppLightTheme() {
    if (_appLightTheme == null) {
      ColorScheme colorScheme =
          ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(surface: SlcColors.colorBackground);
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
          hintColor: SlcColors.globalHintTextColorBlack);
    }
    return _appLightTheme!;
  }

  //全局appToolbarTextStyle 如果需要就在上面主题中用上
  static const TextStyle appToolbarTextStyle = TextStyle(fontSize: 18);
}
