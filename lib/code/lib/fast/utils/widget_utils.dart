import 'package:flutter/material.dart';

class WidgetUtils {

  // 最小的视觉密度
  static const VisualDensity minimumDensity = VisualDensity(
      horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity);

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

}
