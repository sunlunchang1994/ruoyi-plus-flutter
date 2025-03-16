import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/startup/task_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';

import 'route/app_router.dart';
import '../generated/l10n.dart';
import '../res/styles.dart';
import 'feature/welcome/ui/welcome_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
              navigatorKey: navigatorKey,
              initialRoute: WelcomePage.routeName,
              routes: router,
              onUnknownRoute: get404Route,
              onGenerateTitle: (context) {
                return S.current.app_name;
              },
              theme: AppStyles.getAppLightThemeMD3(),
              darkTheme: AppStyles.getAppDarkThemeMD3(),
              themeMode: themeMode,
              // 设置语言
              localizationsDelegates: const [
                S.delegate,
                FormBuilderLocalizations.delegate,
                ...GlobalMaterialLocalizations.delegates,
              ],
              // 将zh设置为第一项,没有适配语言时，英语为首选项
              locale: Locale('zh', 'CN'),
              supportedLocales: S.delegate.supportedLocales,
            );
          }, selector: (context, vm) {
            return vm.currentTheme;
          });
        });
  }

  void _init(BuildContext context) {
    TaskUtils.execRunAppAfterTask(context:context).then((value) {
      LogUtil.d("初始化完毕", tag: "FirstTask");
    });
  }
}
