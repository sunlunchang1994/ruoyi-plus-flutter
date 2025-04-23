import 'package:flutter/cupertino.dart';
import 'package:flutter_slc_boxes/flutter/slc/code/observable_field.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/router_vo.dart';

import '../../../../base/api/api_config.dart';
import '../../../auth/entity/login_result.dart';
import '../../../auth/ui/login_page.dart';
import '../entity/my_user_info_vo.dart';
import '../repository/local/user_config.dart';

class UserShareVm {
  final ObservableField<MyUserInfoVo> userInfoOf = ObservableField(); //用户信息监听
  final ObservableField<List<RouterVo>> routerVoOf = ObservableField(); //路由信息监听

  LoginResult? loginResult; //登录结果信息

  UserShareVm() {}

  void saveLoginInfo() {}

  // 退出登录
  void logOut(BuildContext context) {
    UserConfig().saveIsAutoLogin(false);
    ApiConfig().setToken(null);
    userInfoOf.setValue(null);
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginPage.routeName,
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

}
