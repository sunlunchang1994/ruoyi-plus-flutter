import 'package:flutter_slc_boxes/flutter/slc/router/router_vm.dart';

import '../../../base/api/api_config.dart';

import '../../../base/config/constant_base.dart';
import '../../../base/vm/global_vm.dart';
import '../../../feature/auth/ui/login_page.dart';
import '../repository/local/user_config.dart';

class ConstantUser extends ConstantBase {
  //用户信息
  static const String KEY_USER = "user";
  //岗位信息
  static const String KEY_POST = "post";
  //角色信息
  static const String KEY_ROLE = "role";
  //部门信息
  static const String KEY_DEPT = "dept";
  static const String KEY_PARENT_DEPT = "parentDept";

  //超级管理员角色
  static const int VALUE_ROLE_SUPER_ADMIN = 1;

  static void logOut(RouterVmSub routerSub) {
    UserConfig().saveIsAutoLogin(false);
    ApiConfig().setToken(null);
    GlobalVm globalVm = GlobalVm();
    globalVm.userShareVm.userInfoOf.setValue(null);
    routerSub.pushReplacementPage(LoginPage());
  }
}
