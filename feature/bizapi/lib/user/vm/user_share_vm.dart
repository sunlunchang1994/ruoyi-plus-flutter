import 'package:base/base/api/api_config.dart';
import 'package:base/base/route/base_router.dart';
import 'package:bizapi/auth/entity/login_result.dart';
import 'package:bizapi/system/entity/router_vo.dart';
import 'package:boxes_flutter/flutter/slc/common/object_util.dart';
import 'package:boxes_flutter/flutter/slc/mvvm/base_mvvm.dart';
import 'package:flutter/cupertino.dart';
import 'package:boxes_flutter/flutter/slc/code/observable_field.dart';
import '../entity/my_user_info_vo.dart';
import '../repository/local/user_config.dart';

/// @author sunlunchang
/// 用户共享数据
class UserShareVm extends AbsoluteChangeNotifier {
  final ObservableField<MyUserInfoVo> userInfoOf = ObservableField(); //用户信息监听
  final ObservableField<List<RouterVo>> routerVoOf = ObservableField(); //路由信息监听

  LoginResult? loginResult; //登录结果信息

  UserShareVm._privateConstructor();

  static final UserShareVm _instance = UserShareVm._privateConstructor();

  factory UserShareVm() {
    return _instance;
  }

  void saveLoginInfo() {}

  // 退出登录
  void logOut(BuildContext context) {
    UserConfig().saveIsAutoLogin(false);
    ApiConfig().setToken(null);
    userInfoOf.setValue(null);
    Navigator.of(context).pushNamedAndRemoveUntil(
      BaseRouter.loginPage,
      (Route<dynamic> route) => false,
    );
  }

  /// 权限相关方法

  bool hasPermiAny(List<String> permis) {
    return userInfoOf.value?.hasPermiAny(permis) ?? false;
  }

  Widget? widgetWithPermiAny(List<String> permis, Widget Function() buildWidget) {
    if (hasPermiAny(permis)) {
      return buildWidget.call();
    }
    return null;
  }

  void execPermiAny(List<String> permis, Function() buildWidget) {
    if (hasPermiAny(permis)) {
      buildWidget.call();
    }
  }

  bool hasPermiEvery(List<String> permis) {
    return userInfoOf.value?.hasPermiEvery(permis) ?? false;
  }

  Widget? widgetWithPermiEvery(List<String> permis, Widget Function() buildWidget) {
    if (hasPermiEvery(permis)) {
      return buildWidget.call();
    }
    return null;
  }

  void execPermiEvery(List<String> permis, Function() buildWidget) {
    if (hasPermiEvery(permis)) {
      buildWidget.call();
    }
  }

  bool hasRouter(List<RouterVo>? routers, String path) {
    return findRouterVo(routers, path) != null;
  }

  RouterVo? findRouterVo(List<RouterVo>? routers, String path) {
    if (ObjectUtil.isEmpty(routers)) {
      return null;
    }
    for (RouterVo router in routers!) {
      if (router.path == path) {
        return router;
      }
    }
    return null;
  }
}
