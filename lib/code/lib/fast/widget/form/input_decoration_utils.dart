import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';

///@author slc
///InputDecoration 工具
class InputDecorationUtils {
  ///选择类型的InputDecoration 自动显示清除按钮
  static Widget? autoClearSuffixBySelect(bool showClear,
      {VoidCallback? onPressed}) {
    return showClear ? getClearAction(onPressed) : getMoreIcon();
  }

  ///选择类型的InputDecoration 自动显示清除按钮
  static Widget? autoClearSuffixBySelectVal(String? value,
      {VoidCallback? onPressed}) {
    return autoClearSuffixBySelect(TextUtil.isNotEmpty(value),
        onPressed: onPressed);
  }

  ///输入类型的InputDecoration 自动显示清除按钮
  static Widget? autoClearSuffixByInput(bool showClear,
      {VoidCallback? onPressed}) {
    return showClear ? getClearAction(onPressed) : null;
  }

  ///输入类型的InputDecoration 自动显示清除按钮
  static Widget? autoClearSuffixByInputVal(String? value,
      {VoidCallback? onPressed}) {
    return autoClearSuffixByInput(TextUtil.isNotEmpty(value),
        onPressed: onPressed);
  }

  static Widget getClearAction(VoidCallback? onPressed) {
    return IconButton(
      constraints: BoxConstraints(),
      visualDensity: VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity),
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.close),
      onPressed: () {
        onPressed?.call();
      },
    );
  }

  static Widget getMoreIcon() {
    return const Icon(Icons.chevron_right);
  }
}
