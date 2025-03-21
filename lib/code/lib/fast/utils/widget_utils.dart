import 'package:flutter/material.dart';

class WidgetUtils {

  ///////////////////// 侧滑栏 ///////////////////////
  // 传入Scaffold下级的context
  // 自动处理打开或关闭抽屉
  static void autoHandlerSearchDrawer(BuildContext context) {
    ScaffoldState scaffoldState = Scaffold.of(context);
    if (scaffoldState.isEndDrawerOpen) {
      scaffoldState.closeEndDrawer();
    } else {
      scaffoldState.openEndDrawer();
    }
  }

  ///////////////////// 动画 ///////////////////////
  static const adminDurationNormal = Duration(milliseconds: 300);

  static Widget getLeading({bool useCloseButton = false}) {
    return useCloseButton ? const CloseButton() : const BackButton();
  }

  // 交叉动画切换
  static Widget getAnimCrossFade(Widget firstChild, Widget secondChild,
      {bool? showOne, CrossFadeState? crossFadeState}) {
    assert(showOne != null || crossFadeState != null);
    crossFadeState ??= showOne == true ? CrossFadeState.showFirst : CrossFadeState.showSecond;
    return AnimatedCrossFade(
      duration: WidgetUtils.adminDurationNormal,
      crossFadeState: crossFadeState,
      firstChild: firstChild,
      secondChild: secondChild,
      // 可选参数：调整动画对齐方式
      alignment: Alignment.center,
      // 可选参数：控制尺寸变化的曲线
      sizeCurve: Curves.easeInOut,
    );
  }

  static Widget getAnimVisibility(bool visible, Widget child, {Curve? curve, Duration? duration}) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      curve: curve ?? Curves.easeInOut,
      duration: duration ?? WidgetUtils.adminDurationNormal,
      child: AnimatedScale(
          scale: visible ? 1.0 : 0.0,
          curve: curve ?? Curves.easeInOut,
          duration: duration ?? WidgetUtils.adminDurationNormal,
          child: child),
    );
  }

  ///////////////////// 顶部工具栏 ///////////////////////
  //获取操作操作系列按钮
  static List<Widget> getDeleteFamilyAction(
      {Function()? onSelectAll, Function()? onDeselect, required Function() onDelete}) {
    List<Widget> result = [];
    if (onSelectAll != null) {
      result.add(IconButton(
        icon: const Icon(Icons.select_all),
        onPressed: onSelectAll,
      ));
    }
    if (onDeselect != null) {
      result.add(IconButton(
        icon: const Icon(Icons.deselect),
        onPressed: onDeselect,
      ));
    }
    result.add(IconButton(
      icon: const Icon(Icons.delete_sweep_sharp),
      onPressed: onDelete,
    ));
    return result;
  }
}
