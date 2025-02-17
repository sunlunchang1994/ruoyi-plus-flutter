import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/router/slc_router.dart';
import 'package:ruoyi_plus_flutter/code/module/biz_main/ui/main_page.dart';
import 'package:ruoyi_plus_flutter/code/feature/welcome/ui/welcome_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';

import '../base/config/constant_base.dart';
import '../module/system/ui/fof/no_found_page.dart';
import '../module/system/ui/menu/menu_page.dart';
import '../module/user/ui/dept/dept_add_edit_page.dart';
import '../module/user/ui/dept/dept_list_browser_page.dart';
import '../feature/auth/ui/login_page.dart';
import '../module/user/ui/dept/dept_list_single_select_page.dart';
import '../module/user/ui/user/profile_page.dart';
import '../module/user/ui/user/user_list_browser_page.dart';

// GoRouter configuration
final Map<String, WidgetBuilder> router = {
  //404页面
  NotFoundPage.routeName: (BuildContext context) => NotFoundPage(),
  //欢迎页
  WelcomePage.routeName: (BuildContext context) => WelcomePage(),
  //登录页面
  LoginPage.routeName: (BuildContext context) => LoginPage(),
  //主页
  MainPage.routeName: (BuildContext context) => MainPage(),
  //菜单页
  MenuPage.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo()!;
    return MenuPage(slcRouterInfo.arguments[ConstantBase.KEY_INTENT_TITLE],
        slcRouterInfo.arguments["routerList"], slcRouterInfo.arguments["parentPath"]);
  },
  //用户
  //用户：修改个人信息
  ProfilePage.routeName: (BuildContext context) => ProfilePage(),
  //用户：用户列表
  UserListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo()!;
    return UserListBrowserPage(slcRouterInfo.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //部门
  //部门：部门列表
  DeptListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo()!;
    return DeptListBrowserPage(slcRouterInfo.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //部门：部门单选列表
  DeptListSingleSelectPage.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo()!;
    return DeptListSingleSelectPage(slcRouterInfo.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //部门：部门信息新增或删除
  DeptAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return DeptAddEditPage(
        deptInfo: slcRouterInfo?.arguments[ConstantUser.KEY_DEPT],
        parentDept: slcRouterInfo?.arguments[ConstantUser.KEY_PARENT_DEPT]);
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
