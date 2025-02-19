//欢迎
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/startup/task_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/local/user_config.dart';

import '../../../../generated/l10n.dart';
import '../../../base/api/result_entity.dart';
import '../../../base/ui/app_mvvm.dart';
import '../../../base/utils/app_toast.dart';
import '../../../lib/fast/utils/bar_utils.dart';
import '../../../module/biz_main/ui/main_page.dart';
import '../../auth/repository/remote/auth_api.dart';
import '../../auth/ui/login_page.dart';
import '../../bizapi/system/entity/router_vo.dart';
import '../../bizapi/system/repository/remote/menu_api.dart';
import '../../bizapi/user/repository/remote/user_api.dart';

class WelcomePage extends AppBaseStatelessWidget<_WelcomeVm> {
  static const String routeName = '/';

  WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // 隐藏状态栏和底部按钮栏
    BarUtils.showEnabledSystemUI(false);
    return ChangeNotifierProvider(
      create: (context) => _WelcomeVm(),
      builder: (context, child) {
        registerEvent(context);
        getVm().init(context);
        return Scaffold(
          body: Column(
            children: [
              const Spacer(flex: 1),
              Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                          child: Image(
                              image:
                                  AssetImage("assets/images/ic_launcher.png"),
                              width: 56,
                              height: 56)),
                      Text(S.current.app_name,
                          style: Theme.of(context).textTheme.titleMedium)
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(S.current.label_loading,
                        style:
                            SlcStyles.getTextColorHintStyleByTheme(themeData)),
                  )),
              const Spacer(flex: 1),
            ],
          ),
        );
      },
    );
  }
}

class _WelcomeVm extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();
  final CancelToken cancelAutoLoginToken = CancelToken();

  _WelcomeVm() {}

  void init(BuildContext context) async {
    TaskUtils.execOtherTask(context).then((value) async {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!UserConfig().isAutoLogin() || ApiConfig().getToken() == null) {
        pushReplacementNamed(LoginPage.routeName);
        return;
      }
      Timer? autoLoginTimeOutTimer;
      UserServiceRepository.getInfo(cancelAutoLoginToken)
          .asStream()
          .asyncMap(
              (event) => MenuServiceRepository.getRouters(cancelAutoLoginToken))
          .single
          .then((IntensifyEntity<List<RouterVo>> value) {
        //登录成功了就取消
        if (autoLoginTimeOutTimer != null) {
          autoLoginTimeOutTimer.cancel();
        }
        if (value.isSuccess()) {
          //成功了跳转主界面
          AppToastBridge.showToast(
              msg: S.current.user_toast_login_login_successful);
          pushReplacementNamed(MainPage.routeName);
          return;
        }
        //失败跳转到登录界面
        pushReplacementNamed(LoginPage.routeName);
      }, onError: (e) {
        //失败跳转到登录界面
        pushReplacementNamed(LoginPage.routeName);
      });
      //两秒后取消，防止主界面显示时间太长
      autoLoginTimeOutTimer = Timer(Duration(milliseconds: 2000), () {
        cancelAutoLoginToken.cancel();
      });
    });
  }

  @override
  void dispose() {
    cancelToken.cancel();
    cancelAutoLoginToken.cancel();
    super.dispose();
  }
}
