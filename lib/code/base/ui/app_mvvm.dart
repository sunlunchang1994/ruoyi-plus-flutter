import 'dart:developer';

import 'package:auto_route/src/route/page_route_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/dialog/dialog_loading.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/base_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/router/router.dart';
import 'package:provider/provider.dart';

abstract class AppBaseStatelessWidget<T extends AppBaseVm>
    extends MvvmStatelessWidget<T> {
  final LoadingDialogWidgetVd loadingDialogWidgetVd = LoadingDialogWidgetVd();

  final RouterWidgetVd routerWidgetVd = RouterWidgetVd();

  AppBaseStatelessWidget({super.key});

  ///注册事件
  @override
  void registerEvent(BuildContext context) {
    super.registerEvent(context);
    onRegisterEventByVm(context, getVm());
    loadingDialogWidgetVd.registerDialogEvent(
        context, getVm().loadingDialogVmBox);
    routerWidgetVd.registerRouterEvent(context, getVm().routerVmBox);
  }

  /*@override
  Future startByPageAndListener(BuildContext context, Widget page,
      {RouteSettings? routeSettings, bool finish = false}) async {
    //定义transitionsBuilder
    if (finish) {
      return Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => page, settings: routeSettings));
    } else {
      return Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset(0.0, 0.0);
          const curve = Curves.easeInOutSine;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        settings: routeSettings,
      ));
    }
  }*/

/*Future<Widget> buildPageAsync(Widget page) async {
    return Future.microtask(() {
      return page;
    });
  }*/
}

abstract class AppBaseState<W extends StatefulWidget, T extends AppBaseVm>
    extends MvvmState<W, T> {
  final LoadingDialogWidgetVd loadingDialogWidgetVd = LoadingDialogWidgetVd();
  final RouterWidgetVd routerWidgetVd = RouterWidgetVd();

  ///注册事件
  @override
  void registerEvent(BuildContext context) {
    super.registerEvent(context);
    onRegisterEventByVm(context, getVm());
    loadingDialogWidgetVd.registerDialogEvent(
        context, getVm().loadingDialogVmBox);
    routerWidgetVd.registerRouterEvent(context, getVm().routerVmBox);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AppBaseVm extends BaseVm implements ILoadingDialogVmBox, IRouterVmBox {
  final LoadingDialogVmBox loadingDialogVmBox = LoadingDialogVmBox();
  final RouterVmBox routerVmBox = RouterVmBox();

  @override
  dismissLoading() {
    loadingDialogVmBox.dismissLoading();
  }

  @override
  showLoading({String? text}) {
    return loadingDialogVmBox.showLoading(text: text);
  }

  @override
  finish({result}) {
    routerVmBox.finish(result: result);
  }

  @override
  Future startByPage(Widget page,
      {RouteSettings? routeSettings,
        int requestCode = 0,
        bool finish = false}) {
    return routerVmBox.startByPage(page,
        routeSettings: routeSettings, requestCode: requestCode, finish: finish);
  }

  @override
  Future startByPageParams(PushPageParams pushParameter) {
    return routerVmBox.startByPageParams(pushParameter);
  }

  @override
  Future startByRoute(PageRouteInfo page,
      {int requestCode = 0, bool finish = false}) {
    return routerVmBox.startByRoute(page,
        requestCode: requestCode, finish: finish);
  }

  @override
  Future startByRouteParams(PushRouteParams pushRouteParams) {
    return routerVmBox.startByRouteParams(pushRouteParams);
  }

  @override
  Future startByRoutePath(String path,
      {int requestCode = 0, bool finish = false}) {
    return routerVmBox.startByRoutePath(path,
        requestCode: requestCode, finish: finish);
  }
}
