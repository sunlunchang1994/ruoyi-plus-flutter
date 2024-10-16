import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/sp_util.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:ruoyi_plus_flutter/code/base/config/env_config.dart';

import 'route/app_router.dart';
import '../generated/l10n.dart';
import '../res/styles.dart';
import 'base/config/constant_base.dart';
import 'module/system/ui/welcome_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _init();
    return MaterialApp(
      initialRoute: WelcomePage.routeName,
      routes: router,
      onGenerateTitle: (context) {
        return S.of(context).app_name;
      },
      theme: AppStyles.getAppLightThemeMD3(),
      // 设置语言
      localizationsDelegates: const [
        S.delegate,
        FormBuilderLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      // 将zh设置为第一项,没有适配语言时，英语为首选项
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  void _init() {
    LogUtil.init(isDebug: !EnvConfig.getEnvConfig().isRelease);
    SpUtil.getInstance().then((value) => {LogUtil.d("初始化SpUtil成功")});
  }
}
