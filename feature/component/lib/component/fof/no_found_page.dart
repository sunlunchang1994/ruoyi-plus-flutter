import 'package:base/base/ui/app_mvvm.dart';
import 'package:base/gen/base_l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// @author sunlunchang
/// 404页面
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
          appBar: AppBar(title: Text(BaseS.current.ab_label_404)),
          body: Center(child: Text(BaseS.current.ab_label_404_msg)),
        );
      },
    );
  }
}

class _NotFoundVm extends AppBaseVm {}
