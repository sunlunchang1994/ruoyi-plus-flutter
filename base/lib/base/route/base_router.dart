import 'package:flutter/cupertino.dart';

/// @author sunlunchang
/// 路由配置
class BaseRouter {
  static const String loginPage = '/login';
  static const String mainName = '/index';
  static const String initialPage = '/';
  static const String notFoundPage = '/404';

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

}
