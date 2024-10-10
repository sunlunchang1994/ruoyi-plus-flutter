import 'package:flutter/cupertino.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/router/slc_router.dart';
import 'package:ruoyi_plus_flutter/code/module/biz_main/ui/main_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/welcome_page.dart';

import '../module/system/ui/menu/menu_page.dart';
import '../module/user/ui/login_page.dart';

// GoRouter configuration
final Map<String, WidgetBuilder> router = {
  WelcomePage.routeName: (BuildContext context) => WelcomePage(),
  LoginPage.routeName: (BuildContext context) => LoginPage(),
  MainPage.routeName: (BuildContext context) => MainPage(),
  MenuPage.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo();
    return MenuPage(slcRouterInfo.arguments["title"], slcRouterInfo.arguments["routerList"],
        slcRouterInfo.arguments["path"]);
  },
};
