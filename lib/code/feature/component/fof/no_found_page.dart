import 'package:flutter/material.dart';
import '../../../../../generated/l10n.dart';
import 'package:provider/provider.dart';

import '../../../base/ui/app_mvvm.dart';

//404页面
class NotFoundPage extends AppBaseStatelessWidget<_NotFoundVm> {
  static const String routeName = '/404';

  NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    // 隐藏状态栏和底部按钮栏
    return ChangeNotifierProvider(
      create: (context) => _NotFoundVm(),
      builder: (context, child) {
        registerEvent(context);
        return Scaffold(
          appBar: AppBar(title: Text(S.current.app_label_404)),
          body: Center(child: Text(S.current.app_label_404_msg)),
        );
      },
    );
  }
}

class _NotFoundVm extends AppBaseVm {}
