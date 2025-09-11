import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';

///@author sunlunchang
///快速dialog工具
class FastDialogUtils {
  ///获取常用的action
  static List<Widget> getCommonlyAction(BuildContext context,
      {String? negativeText,
      String? positiveText,
      VoidCallback? negativeLister,
      VoidCallback? positiveLister}) {
    return [
      TextButton(
        onPressed: negativeLister ??
            () {
              Navigator.pop(context);
            },
        child: Text(negativeText ?? FastS.current.action_cancel),
      ),
      TextButton(
          onPressed: positiveLister ??
              () {
                Navigator.pop(context);
              },
          child: Text(positiveText ?? FastS.current.action_ok))
    ];
  }

  static AlertDialog getBottomAlertDialog(
      {Key? key,
      Widget? icon,
      EdgeInsetsGeometry? iconPadding,
      Color? iconColor,
      Widget? title,
      TextStyle? titleTextStyle,
      Widget? content,
      TextStyle? contentTextStyle,
      List<Widget>? actions,
      EdgeInsetsGeometry? actionsPadding,
      MainAxisAlignment? actionsAlignment,
      OverflowBarAlignment? actionsOverflowAlignment,
      VerticalDirection? actionsOverflowDirection,
      double? actionsOverflowButtonSpacing,
      EdgeInsetsGeometry? buttonPadding,
      Color? backgroundColor,
      double? elevation,
      Color? shadowColor,
      Color? surfaceTintColor,
      String? semanticLabel,
      Clip? clipBehavior,
      ShapeBorder? shape,
      AlignmentGeometry? alignment,
      bool scrollable = false}) {
    return AlertDialog(
      key: key,
      icon: icon,
      iconPadding: iconPadding,
      title: title,
      titleTextStyle: titleTextStyle,
      titlePadding: EdgeInsets.only(
          left: SlcDimens.appDimens16,
          right: SlcDimens.appDimens16,
          top: SlcDimens.appDimens16,
          bottom: SlcDimens.appDimens8),
      content: content,
      contentTextStyle: contentTextStyle,
      contentPadding: EdgeInsets.zero,
      actions: actions,
      actionsPadding: actionsPadding,
      actionsAlignment: actionsAlignment,
      actionsOverflowAlignment: actionsOverflowAlignment,
      actionsOverflowDirection: actionsOverflowDirection,
      actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
      buttonPadding: buttonPadding,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      semanticLabel: semanticLabel,
      clipBehavior: clipBehavior,
      insetPadding: EdgeInsets.zero,
      shape: shape,
      alignment: alignment,
      scrollable: scrollable,
    );
  }

  static SimpleDialog getBottomSimpleDialog(
      {Key? key,
      Widget? icon,
      Widget? title,
      TextStyle? titleTextStyle,
      List<Widget>? children,
      List<Widget>? actions,
      Color? backgroundColor,
      double? elevation,
      Color? shadowColor,
      Color? surfaceTintColor,
      String? semanticLabel,
      Clip? clipBehavior,
      ShapeBorder? shape,
      AlignmentGeometry? alignment}) {
    return SimpleDialog(
        key: key,
        title: title,
        titleTextStyle: titleTextStyle,
        titlePadding: EdgeInsets.only(
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            top: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens8),
        contentPadding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        semanticLabel: semanticLabel,
        clipBehavior: clipBehavior,
        insetPadding: EdgeInsets.zero,
        shape: shape,
        alignment: alignment,
        children: children);
  }

  static Future<bool?> showDelConfirmDialog(BuildContext context, {String? contentText, Widget? content}) {
    assert(content == null || contentText == null);
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(FastS.current.label_prompt),
            content: content ??
                Text(contentText ?? TextUtil.format(FastS.current.app_label_data_del_prompt, [""])),
            actions: getCommonlyAction(context, positiveLister: () {
              Navigator.pop(context, true);
            }, negativeLister: () {
              Navigator.pop(context, false);
            }),
          );
        });
  }
}
