import 'package:flutter/material.dart';

class WidgetUtils{

  //传入Scaffold下级的context
  static void autoHandlerSearchDrawer(BuildContext context) {
    ScaffoldState scaffoldState = Scaffold.of(context);
    if (scaffoldState.isEndDrawerOpen) {
      scaffoldState.closeEndDrawer();
    } else {
      scaffoldState.openEndDrawer();
    }
  }
}