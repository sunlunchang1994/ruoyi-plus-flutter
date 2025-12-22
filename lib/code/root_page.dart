import 'package:auth/gen/auth_l10n.dart';
import 'package:base/base/route/base_router.dart';
import 'package:base/base/startup/task.dart';
import 'package:base/gen/base_l10n.dart';
import 'package:biz_main/gen/main_l10n.dart';
import 'package:component/gen/component_l10n.dart';
import 'package:bizapi/gen/biz_api_l10n.dart';
import 'package:fast/fast/provider/fast_select.dart';
import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/common/log_util.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:provider/provider.dart';
import 'package:base/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/gen/l10n/app_localizations.dart';
import 'package:boxes_flutter/gen/l10n/boxes_localizations.dart';
import 'package:ruoyi_plus_flutter/res/styles.dart';
import 'package:system/gen/sys_l10n.dart';
import 'package:user/gen/user_l10n.dart';

import '../gen/app_l10n.dart' as app_l10n;
import 'route/app_router.dart';

/// @author sunlunchang
/// 页面入口
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _init(context);
    return ChangeNotifierProvider<GlobalVm>(
        create: (context) => GlobalVm(),
        builder: (context, child) {
          return NqSelector<GlobalVm, ThemeMode>(builder: (context, themeMode, child) {
            return MaterialApp(
              navigatorKey: BaseRouter.navigatorKey,
              initialRoute: BaseRouter.initialPage,
              routes: router,
              onUnknownRoute: get404Route,
              onGenerateTitle: (context) {
                return app_l10n.S.current.app_name;
              },
              theme: AppStyles.getAppLightThemeMD3(),
              darkTheme: AppStyles.getAppDarkThemeMD3(),
              themeMode: themeMode,
              // 设置语言
              localizationsDelegates: const [
                ...app_l10n.S.localizationsDelegates,
                FastS.delegate,
                BaseS.delegate,
                ComponentS.delegate,
                AuthS.delegate,
                BizApiS.delegate,
                UserS.delegate,
                SysS.delegate,
                MainS.delegate,
                BoxesLocalizations.delegate,
                FormBuilderLocalizations.delegate,
              ],
              // 将zh设置为第一项,没有适配语言时，英语为首选项
              locale: Locale('zh', 'CN'),
              supportedLocales: AppLocalizations.supportedLocales,
            );
          }, selector: (context, vm) {
            return vm.currentTheme;
          });
        });
  }

  void _init(BuildContext context) {
    TaskManager().execRunAppAfterTask(context: context).then((value) {
      LogUtil.d("初始化完毕", tag: "FirstTask");
    });
  }
}
