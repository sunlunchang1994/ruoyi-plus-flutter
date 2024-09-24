import 'package:flutter_slc_boxes/flutter/slc/code/observable_field.dart';

import '../entity/login_result.dart';
import '../entity/user_info_vo.dart';

class UserVmBox {
  final ObservableField<UserInfoVo> userInfoOf = ObservableField(); //用户信息监听

  LoginResult? loginResult; //登录结果信息

  UserVmBox() {}


  void saveLoginInfo() {

  }
}
