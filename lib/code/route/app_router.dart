import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ruoyi_plus_flutter/code/module/system/welcome_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/login_page.dart';

import '../module/biz_main/ui/main_page.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainPage(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
  ],
);