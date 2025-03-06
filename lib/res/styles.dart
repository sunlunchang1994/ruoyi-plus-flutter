import 'package:flutter/material.dart';
import '/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';

class AppStyles extends SlcStyles {
  static ThemeData? _appLightTheme = null;

  ///MD3
  static ThemeData getAppLightThemeMD3() {
    _appLightTheme ??= SlcStyles.appTheme.copyWith(
        appBarTheme: AppBarTheme(
      toolbarHeight: AppDimens.appBarHeight,
      titleSpacing: 0,
    ));
    return _appLightTheme!;
  }

  ///MD2风格
  static ThemeData getAppLightTheme() {
    if (_appLightTheme == null) {
      ColorScheme colorScheme =
          ColorScheme.fromSwatch(primarySwatch: Colors.blue)
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
          hintColor: SlcColors.globalHintTextColorBlack);
    }
    return _appLightTheme!;
  }

  //全局appToolbarTextStyle 如果需要就在上面主题中用上
  static const TextStyle appToolbarTextStyle = TextStyle(fontSize: 18);

  //基础控件
  static const Divider defLightDivider = Divider(
      height: 0.8, thickness: 0.8, color: SlcColors.globalDividerColorBlack);
  static const Divider defDarkDivider = Divider(
      height: 0.8, thickness: 0.8, color: SlcColors.globalDividerColorWhite);

  static Divider getDefDividerByTheme(ThemeData themeData) {
    return getDefDividerByDark(themeData.brightness == Brightness.dark);
  }

  static Divider getDefDividerByDark(bool isDark) {
    return isDark ? defDarkDivider : defLightDivider;
  }

  //List
  static TextStyle getItemTitleStyleByContext(BuildContext context) {
    return getItemTitleStyleByThemeData(Theme.of(context));
  }

  static TextStyle getItemTitleStyleByThemeData(ThemeData themeData) {
    return themeData.listTileTheme.titleTextStyle ??
        themeData.textTheme.bodyLarge!
            .copyWith(color: themeData.colorScheme.onSurface);
  }

  static TextStyle getItemSubTitleStyleByContext(BuildContext context) {
    return getItemSubTitleStyleByThemeData(Theme.of(context));
  }

  static TextStyle getItemSubTitleStyleByThemeData(ThemeData themeData) {
    return themeData.listTileTheme.subtitleTextStyle ??
        themeData.textTheme.bodyMedium!
            .copyWith(color: themeData.colorScheme.onSurfaceVariant);
  }
}
