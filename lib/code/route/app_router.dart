import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/router/slc_router.dart';
import 'package:ruoyi_plus_flutter/code/module/biz_main/ui/main_page.dart';
import 'package:ruoyi_plus_flutter/code/feature/welcome/ui/welcome_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_browser_page.dart';

import '../base/config/constant_base.dart';
import '../module/system/ui/fof/no_found_page.dart';
import '../module/system/ui/menu/menu_page.dart';
import '../module/user/ui/dept/dept_add_edit_page.dart';
import '../module/user/ui/dept/dept_list_browser_page.dart';
import '../feature/auth/ui/login_page.dart';
import '../module/user/ui/dept/dept_list_single_select_page.dart';
import '../module/user/ui/role/role_list_single_select_page.dart';
import '../module/user/ui/user/info/profile_page.dart';
import '../module/user/ui/user/user_add_edit_page.dart';
import '../module/user/ui/user/user_list_browser_page.dart';
import '../module/user/ui/user/user_list_browser_tree_page.dart';
import '../module/user/ui/user/user_list_select_by_dept_page.dart';
import '../module/user/ui/user/user_list_single_select_page.dart';

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
  //用户：单选用户列表
  UserListSingleSelectPage.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo()!;
    return UserListSingleSelectPage(slcRouterInfo.arguments[ConstantBase.KEY_INTENT_TITLE],
        dept: slcRouterInfo.arguments[ConstantUser.KEY_DEPT]);
  },
  //用户：单选用户列表->仅指定部门下的
  UserListSelectByDeptPage.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo()!;
    return UserListSelectByDeptPage(slcRouterInfo.arguments[ConstantBase.KEY_INTENT_TITLE],
        slcRouterInfo.arguments[ConstantUser.KEY_DEPT]!);
  },
  //用户：树结构列表
  UserListBrowserPage2.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo()!;
    return UserListBrowserPage2(slcRouterInfo.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //用户：添加编辑用户信息
  UserAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo slcRouterInfo = context.getSlcRouterInfo()!;
    return UserAddEditPage(slcRouterInfo.arguments[ConstantUser.KEY_USER]);
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
  //角色
  //角色：列表
  RoleListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return RoleListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //角色：单选
  RoleListSingleSelectPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return RoleListSingleSelectPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  }
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
