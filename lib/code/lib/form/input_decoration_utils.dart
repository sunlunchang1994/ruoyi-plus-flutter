import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';

import 'form_operate_with_provider.dart';

///@author slc
///InputDecoration 工具
class InputDecUtils {
  static Widget getSuffixAction(Icon actionIcon, [VoidCallback? onPressed]) {
    return IconButton(
      constraints: BoxConstraints(),
      visualDensity: ThemeUtil.minimumDensity,
      padding: EdgeInsets.zero,
      icon: actionIcon,
      onPressed: () {
        onPressed?.call();
      },
    );
  }

  static Widget getClearAction(VoidCallback? onPressed) {
    return getSuffixAction(const Icon(Icons.clear), onPressed);
  }

  static const moreIcon = Icon(Icons.chevron_right);

  static const defSuffixIconConstraints =
      BoxConstraints(minWidth: 32, minHeight: 32, maxHeight: 32);

  ///选择类型的InputDecoration 自动显示清除按钮
  static Widget autoClearSuffixBySelect(bool showClear, {VoidCallback? onPressed}) {
    return showClear ? getClearAction(onPressed) : moreIcon;
  }

  ///选择类型的InputDecoration 自动显示清除按钮
  static Widget autoClearSuffixBySelectVal(String? value, {VoidCallback? onPressed}) {
    return autoClearSuffixBySelect(TextUtil.isNotEmpty(value), onPressed: onPressed);
  }

  ///输入类型的InputDecoration 自动显示清除按钮
  static Widget autoClearSuffixByInput(bool showClear,
      {VoidCallback? onPressed, FormOperateWithProvider? formOperate, String? formFieldName}) {
    assert(onPressed == null || formOperate == null || formFieldName != null);
    return showClear
        ? getClearAction(onPressed ??
            () {
              formOperate?.clearField(formFieldName!);
            })
        : SizedBox.shrink();
  }

  ///输入类型的InputDecoration 自动显示清除按钮
  static Widget autoClearSuffixByInputVal(String? value,
      {VoidCallback? onPressed, FormOperateWithProvider? formOperate, String? formFieldName}) {
    return autoClearSuffixByInput(TextUtil.isNotEmpty(value),
        onPressed: onPressed, formOperate: formOperate, formFieldName: formFieldName);
  }

  ///追加必填字符
  static String additionalRequired(String text) {
    return "$text*";
  }

  ///获取必填label
  static Row getRequiredLabel(String text) {
    return Row(
      children: [
        Text("* ", style: TextStyle(color: SlcColors.globalUiColorRed1)),
        Text(text),
      ],
    );
  }
}
