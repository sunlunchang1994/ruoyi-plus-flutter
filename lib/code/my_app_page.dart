import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/sp_util.dart';

import '../generated/l10n.dart';
import '../res/styles.dart';
import 'base/config/constant_base.dart';
import 'module/system/welcome_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _init();
    return MaterialApp(
      home: WelcomePage(),
      //home: MainPage(),
      //title: S.of(context).app_name,
      onGenerateTitle: (context) {
        return S.of(context).app_name;
      },
      //builder: BotToastInit(),
      theme: AppStyles.getAppLightThemeMD3(),
      // 设置语言
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      // 将zh设置为第一项,没有适配语言时，英语为首选项
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  void _init() {
    LogUtil.init(isDebug: !ConstantBase.IS_RELEASE);
    SpUtil.getInstance().then((value) => {LogUtil.d("初始化SpUtil成功")});
  }
}
