//欢迎
import 'dart:async';

import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/route/base_router.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:base/base/startup/task.dart';
import 'package:base/base/repository/local/app_config.dart';
import 'package:base/gen/assets.gen.dart';
import 'package:base/package_base_info.dart';
import 'package:bizapi/gen/biz_api_l10n.dart';
import 'package:bizapi/system/entity/router_vo.dart';
import 'package:bizapi/system/repository/remote/pub_dict_data_api.dart';
import 'package:bizapi/system/repository/remote/pub_menu_api.dart';
import 'package:bizapi/user/repository/local/user_config.dart';
import 'package:bizapi/user/repository/remote/pub_user_api.dart';
import 'package:fast/fast/utils/app_toast.dart';
import 'package:fast/fast/utils/bar_utils.dart';
import 'package:fast/fast/vd/request_token_manager.dart';
import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_extension.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';

/// @author sunlunchang
/// 欢迎页
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
                      Center(
                          child: Assets.images.icAppLogo
                              .image(width: 56, height: 56, package: BasePkgInfo.packageName)),
                      ThemeUtil.getSizedBox(height: SlcDimens.appDimens12),
                      Text(AppConfig().appName, style: Theme.of(context).textTheme.titleMedium)
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(FastS.current.label_loading,
                        style: themeData.slcTidyUpStyle.getTextColorHintStyleByTheme(themeData)),
                  )),
              const Spacer(flex: 1),
            ],
          ),
        );
      },
    );
  }
}

class _WelcomeVm extends AppBaseVm with CancelTokenAssist {
  //是否是完成页面
  bool isFinishPage = false;
  bool _initialized = false;
  Timer? _autoLoginTimeOutTimer;

  _WelcomeVm() {}

  void init(BuildContext context) async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    TaskManager().execSlcTask(context: context).then((value) async {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!UserConfig().isAutoLogin() || ApiConfig().getToken() == null) {
        isFinishPage = true;
        pushReplacementNamed(BaseRouter.loginPage);
        return;
      }
      _autoLoginTimeOutTimer = Timer(Duration(milliseconds: 2000), () {
        defCancelToken.cancel();
      });
      PubUserRepository.getInfo(defCancelToken)
          .asStream()
          .asyncMap((event) => PubMenuPublicRepository.getRouters(defCancelToken))
          .asyncMap((event) => PubDictDataRepository.cacheDict(defCancelToken)
              .asStream()
              .map((cacheDictEvent) => event)
              .single)
          .single
          .then((IntensifyEntity<List<RouterVo>> value) {
        isFinishPage = true;
        //登录成功了就取消
        _autoLoginTimeOutTimer?.cancel();
        if (value.isSuccess()) {
          //成功了跳转主界面
          AppToastUtil.showToast(msg: BizApiS.current.user_toast_login_login_successful);
          pushReplacementNamed(BaseRouter.mainName);
          return;
        }
        //失败跳转到登录界面
        pushReplacementNamed(BaseRouter.loginPage);
      }, onError: (e) {
        if (isFinishPage) {
          return;
        }
        //失败跳转到登录界面
        isFinishPage = true;
        pushReplacementNamed(BaseRouter.loginPage);
      });
    });
  }

  @override
  void dispose() {
    _autoLoginTimeOutTimer?.cancel();
    super.dispose();
  }
}
