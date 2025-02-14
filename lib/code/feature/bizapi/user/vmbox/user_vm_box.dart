import 'package:flutter_slc_boxes/flutter/slc/code/observable_field.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/router_vo.dart';

import '../../../auth/entity/login_result.dart';
import '../entity/user_info_vo.dart';

class UserShareVm {
  final ObservableField<UserInfoVo> userInfoOf = ObservableField(); //用户信息监听
  final ObservableField<List<RouterVo>> routerVoOf = ObservableField(); //用户信息监听

  LoginResult? loginResult; //登录结果信息

  UserShareVm() {}

  void saveLoginInfo() {

  }
}
