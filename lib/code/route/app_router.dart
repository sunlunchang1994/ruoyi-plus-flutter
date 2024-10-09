import 'package:flutter/cupertino.dart';
import 'package:ruoyi_plus_flutter/code/module/biz_main/ui/main_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/welcome_page.dart';

import '../module/user/ui/login_page.dart';

// GoRouter configuration
final Map<String, WidgetBuilder> router = {
  WelcomePage.routeName: (BuildContext context) => WelcomePage(),
  LoginPage.routeName: (BuildContext context) => LoginPage(),
  MainPage.routeName: (BuildContext context) => MainPage(),

};
