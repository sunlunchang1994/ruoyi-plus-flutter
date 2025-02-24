import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/router/router_grid.dart';

import '../../../../feature/bizapi/system/entity/router_vo.dart';

class MenuPage extends AppBaseStatelessWidget<_MenuPageVm> {

  static const String routeName = '/router_page';

  final String title;
  final List<RouterVo> routerList;
  final String? parentPath;

  MenuPage(this.title, this.routerList, this.parentPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _MenuPageVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm();
        return Scaffold(
            appBar: AppBar(title: Text(title)),
            //图标滚动使用固定大小来解决
            body: MenuGrid(routerList, parentPath));
      },
    );
  }
}

class _MenuPageVm extends AppBaseVm {
  void initVm() {

  }
}
