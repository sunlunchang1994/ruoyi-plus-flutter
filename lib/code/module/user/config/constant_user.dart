import 'package:flutter_slc_boxes/flutter/slc/router/router_vm.dart';

import '../../../base/api/api_config.dart';

import '../../../base/vm/global_vm.dart';
import '../../../feature/auth/ui/login_page.dart';
import '../repository/local/UserConfig.dart';

class ConstantUser {
  static void logOut(RouterVmSub routerSub) {
    UserConfig().saveIsAutoLogin(false);
    ApiConfig().setToken(null);
    GlobalVm globalVm = GlobalVm();
    globalVm.userShareVm.userInfoOf.value = null;
    routerSub.pushReplacementPage(LoginPage());
  }
}
