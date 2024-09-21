import 'package:flutter_slc_boxes/flutter/slc/code/observable_field.dart';

import '../entity/login_result.dart';

class UserVmBox {
  final ObservableField<dynamic> userInfoOf = ObservableField(); //用户信息监听

  LoginResult? loginResult; //登录结果信息

  UserVmBox() {}


  void saveLoginInfo() {

  }
}
