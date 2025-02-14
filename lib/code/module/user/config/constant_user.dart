import 'package:flutter_slc_boxes/flutter/slc/router/router_vm.dart';

import '../../../base/api/api_config.dart';

import '../../../base/vm/global_vm.dart';
import '../ui/login_page.dart';
import '../repository/local/sp_user_config.dart';

class ConstantUser {
  static void logOut(RouterVmSub routerSub) {
    SpUserConfig.saveIsAutoLogin(false);
    ApiConfig().token = null;
    GlobalVm globalVm = GlobalVm();
    globalVm.userShareVm.userInfoOf.value = null;
    routerSub.pushReplacementPage(LoginPage());
  }
}
