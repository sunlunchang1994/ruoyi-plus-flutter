import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/router/slc_router.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/config/constant_sys_api.dart';
import 'package:ruoyi_plus_flutter/code/module/biz_main/ui/main_page.dart';
import 'package:ruoyi_plus_flutter/code/feature/welcome/ui/welcome_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/config/constant_sys.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/monitor/cache_monitor/cache_monitor_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_browser_page.dart';

import '../base/config/constant_base.dart';
import '../module/system/ui/client/sys_client_add_edit_page.dart';
import '../module/system/ui/client/sys_client_list_browser_page.dart';
import '../module/system/ui/config/config_add_edit_page.dart';
import '../module/system/ui/config/config_list_browser_page.dart';
import '../module/system/ui/dict/data/dict_data_add_edit_page.dart';
import '../module/system/ui/dict/data/dict_data_list_browser_page.dart';
import '../module/system/ui/dict/type/dict_type_add_edit_page.dart';
import '../module/system/ui/dict/type/dict_type_list_browser_page.dart';
import '../module/system/ui/fof/no_found_page.dart';
import '../module/system/ui/log/sys_log_page.dart';
import '../module/system/ui/log/sys_oper_log_details_page.dart';
import '../module/system/ui/menu_tree/menu_add_edit_page.dart';
import '../module/system/ui/menu_tree/menu_list_borwser_page.dart';
import '../module/system/ui/menu_tree/menu_list_select_single_page.dart';
import '../module/system/ui/menu_tree/menu_tree_borwser_page.dart';
import '../module/system/ui/menu_tree/menu_tree_select_multiple_page.dart';
import '../module/system/ui/monitor/cache_monitor/test_p.dart';
import '../module/system/ui/monitor/online/user_online_list_browser_page.dart';
import '../module/system/ui/notice/notice_add_edit_page.dart';
import '../module/system/ui/notice/notice_list_browser_page.dart';
import '../module/system/ui/oss/config/oss_config_add_edit_page.dart';
import '../module/system/ui/oss/config/oss_config_list_browser_page.dart';
import '../module/system/ui/oss/oss_details_page.dart';
import '../module/system/ui/oss/oss_list_browser_page.dart';
import '../module/system/ui/router/router_page.dart';
import '../module/system/ui/tenant/package/tenant_package_add_edit_page.dart';
import '../module/system/ui/tenant/package/tenant_package_list_browser_page.dart';
import '../module/system/ui/tenant/package/tenant_package_select_single_page.dart';
import '../module/system/ui/tenant/tenant_add_edit_page.dart';
import '../module/system/ui/tenant/tenant_list_browser_page.dart';
import '../module/user/ui/dept/dept_add_edit_page.dart';
import '../module/user/ui/dept/dept_list_browser_page.dart';
import '../feature/auth/ui/login_page.dart';
import '../module/user/ui/dept/dept_list_select_single_page.dart';
import '../module/user/ui/post/post_add_edit_page.dart';
import '../module/user/ui/post/post_list_browser_page.dart';
import '../module/user/ui/post/post_list_select_single_page.dart';
import '../module/user/ui/role/role_add_edit_page.dart';
import '../module/user/ui/role/role_list_select_single_page.dart';
import '../module/user/ui/user/info/profile_page.dart';
import '../module/user/ui/user/user_add_edit_page.dart';
import '../module/user/ui/user/user_list_browser_page.dart';
import '../module/user/ui/user/user_list_browser_tree_page.dart';
import '../module/user/ui/user/user_list_select_by_dept_page.dart';
import '../module/user/ui/user/user_list_select_single_page.dart';

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
  //路由页
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
  },
  //角色：新增或编辑
  RoleAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return RoleAddEditPage(slcRouterInfo?.arguments[ConstantUser.KEY_ROLE]);
  },
  //岗位
  //岗位：列表
  PostListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return PostListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //岗位：单选
  PostListSingleSelectPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return PostListSingleSelectPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //岗位：新增或编辑
  PostAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return PostAddEditPage(slcRouterInfo?.arguments[ConstantUser.KEY_POST]);
  },
  //菜单：菜单列表-操作列表
  MenuListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return MenuListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //菜单：菜单列表-操作列表
  MenuListSelectSinglePage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return MenuListSelectSinglePage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //菜单：新增或编辑
  MenuAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return MenuAddEditPage(
        sysMenuInfo: slcRouterInfo?.arguments[ConstantSys.KEY_MENU],
        parentSysMenu: slcRouterInfo?.arguments[ConstantSys.KEY_MENU_PARENT]);
  },
  //菜单：菜单树列表
  MenuTreeBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return MenuTreeBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //菜单：角色菜单树多选
  RoleMenuTreeSelectMultiplePage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return RoleMenuTreeSelectMultiplePage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE],
        roleId: slcRouterInfo?.arguments[ConstantSys.KEY_MENU_ID],
        checkedIds: slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_SELECT_DATA]);
  },
  //菜单：租户菜单树多选
  TenantPackageMenuTreeSelectMultiplePage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return TenantPackageMenuTreeSelectMultiplePage(
        slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE],
        packageId: slcRouterInfo?.arguments[ConstantSys.KEY_SYS_TENANT_PACKAGE_ID],
        linkageEnable: slcRouterInfo?.arguments[ConstantSys.KEY_MENU_LINKAGE_ENABLE],
        checkedIds: slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_SELECT_DATA]);
  },
  //字典类型
  //字典类型：新增或编辑
  DictTypeAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return DictTypeAddEditPage(slcRouterInfo?.arguments[ConstantSys.KEY_DICT_TYPE]);
  },
  //字典类型：类型列表
  DictTypeListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return DictTypeListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //字典数据
  //字典数据：新增或编辑
  DictDataAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return DictDataAddEditPage(
        dictData: slcRouterInfo?.arguments[ConstantSys.KEY_DICT_DATA],
        parentType: slcRouterInfo?.arguments[ConstantSys.KEY_DICT_PARENT_TYPE]);
  },
  //字典数据：数据列表
  DictDataListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return DictDataListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE],
        slcRouterInfo?.arguments[ConstantSys.KEY_DICT_TYPE]);
  },
  //系统配置参数
  //系统配置参数：列表
  ConfigListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return ConfigListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //系统配置参数：列表
  ConfigAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return ConfigAddEditPage(sysConfig: slcRouterInfo?.arguments[ConstantSys.KEY_SYS_CONFIG]);
  },
  //系统通知公告
  //系统通知公告：列表
  NoticeListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return NoticeListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //系统通知公告：新增编辑
  NoticeAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return NoticeAddEditPage(sysNotice: slcRouterInfo?.arguments[ConstantSys.KEY_SYS_NOTICE]);
  },
  //日志
  SysLogPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return SysLogPage(slcRouterInfo?.arguments[ConstantSysApi.INTENT_KEY_ROUTER]);
  },
  //日志：操作日志
  SysOperLogDetailsPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return SysOperLogDetailsPage(slcRouterInfo?.arguments[ConstantSys.KEY_SYS_LOG]);
  },
  //oss
  //oss列表
  OssListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return OssListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //oss详情
  OssDetailsPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return OssDetailsPage(slcRouterInfo?.arguments[ConstantSys.KEY_SYS_OSS]);
  },
  //oss config
  OssConfigListBrowserPage.routeName: (BuildContext context) {
    return OssConfigListBrowserPage();
  },
  OssConfigAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return OssConfigAddEditPage(
        sysOssConfig: slcRouterInfo?.arguments[ConstantSys.KEY_SYS_OSS_CONFIG]);
  },
  //客户端
  SysClientListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return SysClientListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  SysClientAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return SysClientAddEditPage(sysClient: slcRouterInfo?.arguments[ConstantSys.KEY_SYS_CLIENT]);
  },
  //租户套餐
  //租户套餐：列表
  TenantPackageListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return TenantPackageListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //租户套餐：单选列表
  TenantPackageSelectSinglePage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return TenantPackageSelectSinglePage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //租户套餐：新增与编辑
  TenantPackageAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return TenantPackageAddEditPage(
        sysTenantPackage: slcRouterInfo?.arguments[ConstantSys.KEY_SYS_TENANT_PACKAGE]);
  },
  //租户：
  //租户：列表
  TenantListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return TenantListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //租户：新增或修改
  TenantAddEditPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return TenantAddEditPage(sysTenant: slcRouterInfo?.arguments[ConstantSys.KEY_SYS_TENANT]);
  },
  //在线用户
  //在线用户：列表
  UserOnlineListBrowserPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    return UserOnlineListBrowserPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
  },
  //缓存监控
  //缓存监控：信息
  CacheMonitorPage.routeName: (BuildContext context) {
    SlcRouterInfo? slcRouterInfo = context.getSlcRouterInfo();
    //return LineChartSample11();
    return CacheMonitorPage(slcRouterInfo?.arguments[ConstantBase.KEY_INTENT_TITLE]);
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
