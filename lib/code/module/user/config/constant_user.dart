import '../../../base/api/api_config.dart';
import 'package:flutter_slc_boxes/flutter/slc/router/router.dart';

import '../../../base/vm/global_vm.dart';
import '../ui/login_page.dart';
import '../repository/local/sp_user_config.dart';

class ConstantUser {
  static void logOut(RouterVmBox routerVm) {
    SpUserConfig.saveIsAutoLogin(false);
    ApiConfig().token = null;
    GlobalVm globalVm = GlobalVm();
    globalVm.userVmBox.userInfoOf.value = null;
    routerVm.startByPage(LoginPage(), finish: true);
  }
}
