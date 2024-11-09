import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/router/slc_router.dart';
import 'package:ruoyi_plus_flutter/code/module/biz_main/ui/main_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/welcome_page.dart';

import '../base/config/constant_base.dart';
import '../module/system/ui/fof/no_found_page.dart';
import '../module/system/ui/menu/menu_page.dart';
import '../module/user/ui/dept/dept_list_browser_page.dart';
import '../module/user/ui/login_page.dart';
import '../module/user/ui/profile_page.dart';

// GoRouter configuration
final Map<String, WidgetBuilder> router = {
  WelcomePage.routeName: (BuildContext context) => WelcomePage(),
  NotFoundPage.routeName: (BuildContext context) => NotFoundPage(),
  LoginPage.routeName: (BuildContext context) => LoginPage(),
  ProfilePage.routeName: (BuildContext context) => ProfilePage(),
  MainPage.routeName: (BuildContext context) => MainPage(),
  MenuPage.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo();
    return MenuPage(slcRouterInfo.arguments[ConstantBase.KEY_INTENT_TITLE],
        slcRouterInfo.arguments["routerList"], slcRouterInfo.arguments["parentPath"]);
  },
  DeptListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo();
    return DeptListBrowserPage(slcRouterInfo.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
};

Route get404Route(RouteSettings settings) {
  return MaterialPageRoute(
      builder: (context) {
        return router[NotFoundPage.routeName]!(context);
      },
      settings: settings);
}

///路由拦截
///暂未用上
Route onGenerateRoute<T extends Object>(RouteSettings settings) {
  return MaterialPageRoute<T>(
    settings: settings,
    builder: (context) {
      String? name = settings.name;
      name ??= NotFoundPage.routeName;
      if (router[name] == null) {
        name = NotFoundPage.routeName;
      }
      Widget widget = router[name]!(context);
      return widget;
    },
  );
}
