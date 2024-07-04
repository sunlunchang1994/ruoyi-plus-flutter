//欢迎
import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scaffold_single/code/extras/user/repository/remote/user_public_api.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../base/api/result_entity.dart';
import '../../base/ui/app_mvvm.dart';
import '../../base/ui/utils/bar_utils.dart';
import '../../base/utils/app_toast.dart';
import '../user/repository/local/sp_user_config.dart';
import '../user/ui/login_page.dart';

class WelcomePage extends AppBaseStatelessWidget<_WelcomeVm> {
  WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // 隐藏状态栏和底部按钮栏
    BarUtils.showEnabledSystemUI(false);
    return ChangeNotifierProvider(
      create: (context) => _WelcomeVm(),
      builder: (context, child) {
        registerEvent(context);
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

  _WelcomeVm() {
    init();
  }

  void init() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (SpUserConfig.isAutoLogin() &&
        SpUserConfig.isSavePassword() &&
        !TextUtil.isEmpty(SpUserConfig.getAccount()) &&
        !TextUtil.isEmpty(SpUserConfig.getPassword())) {
      showLoading(title: S.current.user_label_logging_in);
      UserPublicServiceRepository.login(SpUserConfig.getAccount()!,
              SpUserConfig.getPassword()!, cancelToken)
          .then((IntensifyEntity<dynamic> value) {
        dismissLoading();
        if (value.isSuccess()) {
          AppToastBridge.showToast(
              msg: S.current.user_toast_login_login_successful);
          //startByPage(MainPage(), finish: true);
        } else {
          SpUserConfig.saveIsAutoLogin(true);
          AppToastBridge.showToast(msg: value.getMsg());
          startByPage(LoginPage(), finish: true);
        }
      }, onError: (e) {
        dismissLoading();
        if (!cancelToken.isCancelled) {
          startByPage(LoginPage(), finish: true);
        }
      });
    } else {
      startByPage(LoginPage(), finish: true);
    }
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }
}
