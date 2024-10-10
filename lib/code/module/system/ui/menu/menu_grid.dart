import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/object_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/menu/menu_page.dart';
import '../../../../base/ui/app_mvvm.dart';
import 'package:provider/provider.dart';

import '../../../../extras/system/entity/router_vo.dart';
import 'menu_item_view.dart';

class MenuGrid extends AppBaseStatelessWidget<_MenuGridVm> {
  final List<RouterVo> routerList;
  final String? path;

  MenuGrid(this.routerList, this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (loginModel) => _MenuGridVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        final menuVm = Provider.of<_MenuGridVm>(context, listen: false);
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
      menuList.add(MenuItemView(action, onTap: () {
        getVm().onRouterClick(action);
      }));
    });
    return menuList;
  }
}

class _MenuGridVm extends AppBaseVm {
  late List<RouterVo> routerList;
  String? path;

  void initVm(List<RouterVo> routerList, String? path) {
    this.routerList = routerList;
    this.path = path;
  }

  void onRouterClick(RouterVo router) {
    if (ConstantBase.COMPONENT_LAYOUT == router.component && !ObjectUtil.isEmptyList(router.children)) {
      pushNamed(MenuPage.routeName, arguments: {
        "title": router.getRouterTitle(),
        "routerList": router.children,
        "path": router.path
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
