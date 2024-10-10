import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/menu/menu_grid.dart';

import '../../../../extras/system/entity/router_vo.dart';

class MenuPage extends AppBaseStatelessWidget<_MenuPageVm> {

  static const String routeName = '/menu_page';

  final String title;
  final List<RouterVo> routerList;
  final String? path;

  MenuPage(this.title, this.routerList, this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (loginModel) => _MenuPageVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm();
        return Scaffold(
            appBar: AppBar(title: Text(title)),
            //图标滚动使用固定大小来解决
            body: MenuGrid(routerList, null));
      },
    );
  }
}

class _MenuPageVm extends AppBaseVm {
  void initVm() {

  }
}
