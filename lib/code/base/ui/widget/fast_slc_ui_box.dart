import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';

/// @author sunlunchang
/// 简单的UI风格工具，用于构建标准的表单页、数据列表页
/// 对于不喜欢MD风格的场景非常实用
class SlcUiBoxStyleUtils {
  ///icon边距
  static const EdgeInsets itemPrefixWidgetMargin = EdgeInsets.fromLTRB(16, 12, 0, 12);
  static const EdgeInsets itemSuffixItemHMargin = EdgeInsets.fromLTRB(0, 12, 16, 12);

  ///表单
  static const TextStyle variantFormLabelTextStyleByDay =
      TextStyle(color: Colors.black87, fontSize: 16);
  static const TextStyle variantFormLabelTextStyleByNight =
      TextStyle(color: Colors.white, fontSize: 16);
  static const TextStyle variantFormPrimaryTextStyleByDay =
      TextStyle(color: Colors.black87, fontSize: 16);
  static const TextStyle variantFormPrimaryTextStyleByNight =
      TextStyle(color: Colors.white, fontSize: 16);

  static TextStyle getVariantFormLabelTextStyleByContext(BuildContext context) {
    return getVariantFormLabelTextStyleByThemeData(Theme.of(context));
  }

  static TextStyle getVariantFormLabelTextStyleByThemeData(ThemeData themeData) {
    if (themeData.brightness == Brightness.dark) {
      return variantFormLabelTextStyleByNight;
    } else {
      return variantFormLabelTextStyleByDay;
    }
  }

  static TextStyle getVariantFormPrimaryTextStyleByContext(BuildContext context) {
    return getVariantFormPrimaryTextStyleByThemeData(Theme.of(context));
  }

  static TextStyle getVariantFormPrimaryTextStyleByThemeData(ThemeData themeData) {
    if (themeData.brightness == Brightness.dark) {
      return variantFormPrimaryTextStyleByNight;
    } else {
      return variantFormPrimaryTextStyleByDay;
    }
  }

  ///单行labelMargin
  static const EdgeInsets variantFormLabelHMargin = EdgeInsets.fromLTRB(16, 12, 0, 12);

  ///多行labelMargin
  static const EdgeInsets variantFormLabelVMargin = EdgeInsets.fromLTRB(16, 12, 0, 0);

  ///单行ContentMargin
  static const EdgeInsets variantFormContentHMargin = EdgeInsets.fromLTRB(16, 10, 16, 10);

  ///单行ContentMargin结束间隔容忍宽度
  static const EdgeInsets variantFormContentHMarginByEndHumility =
      EdgeInsets.fromLTRB(16, 10, 8, 10);

  ///多行ContentMargin
  static const EdgeInsets variantFormContentVMargin = EdgeInsets.fromLTRB(16, 0, 16, 10);

  ///多行ContentMargin结束间隔容忍宽度
  static const EdgeInsets variantFormContentVMarginByEndHumility =
      EdgeInsets.fromLTRB(16, 0, 8, 10);

  ///icon边距
  static const EdgeInsets variantFormPrefixWidgetMargin = EdgeInsets.fromLTRB(16, 12, 0, 12);
  static const EdgeInsets variantFormSuffixItemHMargin = EdgeInsets.fromLTRB(0, 12, 16, 12);

  ///
  /// 使用笔记
  /// border: OutlineInputBorder(borderSide: BorderSide.none),
  /// 则内容居中，可选择去除contentPadding
  /// 要完美去除边框等信息只需使用isCollapsed: true,或InputDecoration.collapsed
  ///
  static InputDecoration getSimpleInputDecoration(
      {EdgeInsetsGeometry? contentPadding, String? hintText, TextStyle? hintStyle}) {
    return InputDecoration.collapsed(hintText: hintText, hintStyle: hintStyle ??= const TextStyle())
        .copyWith(contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 2));
  }

  static Divider getDividerByBg(
      {double height = 1,
      double thickness = 0,
      double? indent,
      double? endIndent,
      Color color = Colors.transparent}) {
    return Divider(
      height: height,
      thickness: thickness,
      endIndent: endIndent,
      indent: indent,
      color: color,
    );
  }

  static VerticalDivider getVerticalDividerByBg(
      {double width = 1,
      double thickness = 0,
      double? indent,
      double? endIndent,
      Color color = Colors.transparent}) {
    return VerticalDivider(
      color: color,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      width: width,
    );
  }
}

///简单的虚拟的表单
class SimpleVariantFormLayout extends StatelessWidget {
  //标签
  final Widget? label;

  //关键提示
  final Widget? emphasize;

  //标签风格
  final TextStyle? labelTextStyle;

  //内容
  final Widget? content;

  //final Widget prefix;
  //final Widget suffix;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? labelMargin;
  final EdgeInsetsGeometry? contentMargin;

  //final EdgeInsetsGeometry prefixWidgetMargin;
  //final EdgeInsetsGeometry suffixWidgetMargin;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final bool singleLine;
  final bool contentHumility;

  SimpleVariantFormLayout({
    Key? key,
    this.label,
    this.emphasize,
    this.labelTextStyle,
    @required this.content,
    //this.prefix,
    //this.suffix,
    this.padding,
    this.labelMargin,
    this.contentMargin,
    //this.prefixWidgetMargin,
    //this.suffixWidgetMargin,
    this.onTap,
    this.onLongPress,
    this.singleLine = true,
    this.contentHumility = false,
  })  : assert(content != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Ink(
        color: themeData.cardColor,
        child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Padding(
                padding: padding ?? const EdgeInsets.all(0),
                child: _createContentParent(_createChildren(themeData)))));
  }

  ///创建内容的父布局
  ///如果是单行则返回Row，否则返回Column
  Widget _createContentParent(List<Widget> children) {
    if (singleLine) {
      return Row(children: children);
    } else {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children);
    }
  }

  ///创建子控件
  List<Widget> _createChildren(ThemeData themeData) {
    List<Widget> children = <Widget>[];
    if (label != null) {
      List<Widget> labelChildren = <Widget>[];
      labelChildren.add(DefaultTextStyle(
          style: labelTextStyle ??
              SlcUiBoxStyleUtils.getVariantFormLabelTextStyleByThemeData(themeData),
          child: label!));
      if (emphasize != null) {
        labelChildren.add(DefaultTextStyle(
            style: labelTextStyle?.copyWith(color: Colors.red.shade500) ??
                SlcUiBoxStyleUtils.getVariantFormLabelTextStyleByThemeData(themeData)
                    .copyWith(color: Colors.red.shade500),
            child: emphasize!));
      }
      children.add(Padding(
          padding: labelMargin ??
              (singleLine
                  ? SlcUiBoxStyleUtils.variantFormLabelHMargin
                  : SlcUiBoxStyleUtils.variantFormLabelVMargin),
          child: Row(children: labelChildren)));
    }
    final contentPadding = Padding(
        padding: contentMargin ??
            (singleLine
                ? contentHumility
                    ? SlcUiBoxStyleUtils.variantFormContentHMarginByEndHumility
                    : SlcUiBoxStyleUtils.variantFormContentHMargin
                : contentHumility
                    ? SlcUiBoxStyleUtils.variantFormContentVMarginByEndHumility
                    : SlcUiBoxStyleUtils.variantFormContentVMargin),
        child: content);
    children.add(singleLine ? Expanded(child: contentPadding) : contentPadding);
    return children;
  }
}

///简单的list布局
class SimpleListItemLayout extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final EdgeInsetsGeometry? prefixWidgetMargin;
  final EdgeInsetsGeometry? suffixWidgetMargin;
  final Widget? child;

  SimpleListItemLayout(
      {this.prefix, this.suffix, this.child, this.prefixWidgetMargin, this.suffixWidgetMargin});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    List<Widget> children = <Widget>[];
    if (this.prefix != null) {
      children.add(Padding(
          padding: prefixWidgetMargin ?? SlcUiBoxStyleUtils.itemPrefixWidgetMargin,
          child: IconTheme(
              child: this.prefix!,
              data: IconThemeData(
                color: (themeData.slcTidyUpColor
                    .getTextColorSecondaryByTheme(Theme.of(context))),
              ))));
    }
    if (this.child != null) {
      children.add(DefaultTextStyle(
          style: themeData.slcListTileStyle.getItemTitleStyleByContext(context),
          child: this.child!));
    }
    if (this.suffix != null) {
      children.add(Padding(
          padding: suffixWidgetMargin ?? SlcUiBoxStyleUtils.itemSuffixItemHMargin,
          child: IconTheme(
            child: this.suffix!,
            data: IconThemeData(
                color: themeData.slcTidyUpColor
                    .getTextColorSecondaryByTheme(Theme.of(context))),
          )));
    }
    return Row(
      children: children,
    );
  }
}

///超级简单的列表布局，省去了边距
class SuperEasyListItemLayout extends SimpleListItemLayout {
  SuperEasyListItemLayout({IconData? prefixIcon, IconData? suffixIcon, String? labelText})
      : super(
            prefix: prefixIcon == null ? null : Icon(prefixIcon),
            suffix: suffixIcon == null ? null : Icon(suffixIcon),
            child: labelText == null
                ? null
                : Padding(padding: EdgeInsets.fromLTRB(16, 12, 0, 12), child: Text(labelText)));
}
