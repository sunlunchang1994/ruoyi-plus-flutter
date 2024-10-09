import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import '../../../base/ui/app_mvvm.dart';
import 'package:provider/provider.dart';

import '../../../extras/system/entity/router_vo.dart';

class MenuPage extends AppBaseStatelessWidget<_MenuVm> {
  final List<RouterVo> routerList;
  final String? path;

  MenuPage(this.routerList, this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (loginModel) => _MenuVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        final menuVm = Provider.of<_MenuVm>(context, listen: false);
        menuVm.initVm(this.routerList, this.path);
        return GridView.count(
            // 定义列数
            crossAxisCount: 3,
            // 定义列边距
            crossAxisSpacing: SlcDimens.appDimens16,
            // 定义行边距
            mainAxisSpacing: SlcDimens.appDimens16,
            // 定义内边距
            padding: EdgeInsets.all(SlcDimens.appDimens16),
            // 宽度和高度的比例（变相的调整了高度）
            childAspectRatio: 1.2,
            // 子元素
            children: getMenuWidgetList());
      },
    );
  }

  List<Widget> getMenuWidgetList() {
    List<Widget> menuList = List.empty(growable: true);
    getVm().routerList.forEach((action) {
      menuList.add(Container(child: Center(
        child: Text(action.meta?.title ?? action.name ?? ""),
      ),color: Colors.blueAccent));
    });
    return menuList;
  }
}

class _MenuVm extends AppBaseVm {
  late List<RouterVo> routerList;
  String? path;

  void initVm(List<RouterVo> routerList, String? path) {
    this.routerList = routerList;
    this.path = path;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
