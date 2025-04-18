import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/object_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/slc_url_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/config/constant_sys_api.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/router/router_page.dart';
import '../../../../../generated/l10n.dart';
import '../../../../base/ui/app_mvvm.dart';
import 'package:provider/provider.dart';

import '../../../../feature/bizapi/system/entity/router_vo.dart';
import '../../../../feature/component/webview/app_web_view_page.dart';
import '../../../user/ui/dept/dept_list_browser_page.dart';
import 'router_item_view.dart';

class MenuGrid extends AppBaseStatelessWidget<_MenuGridVm> {
  final List<RouterVo> routerList;
  final String? parentPath;

  MenuGrid(this.routerList, this.parentPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (loginModel) => _MenuGridVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        final menuVm = Provider.of<_MenuGridVm>(context, listen: false);
        menuVm.initVm(routerList, parentPath);
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
  String? parentPath;

  void initVm(List<RouterVo> routerList, String? parentPath) {
    this.routerList = routerList;
    this.parentPath = parentPath;
  }

  ///获取目标path路由
  String _targetPathByRouter(RouterVo router) {
    String currentPath = (router.path ?? "");
    if (!currentPath.startsWith('/')) {
      currentPath = '/$currentPath';
    }
    return (parentPath ?? "") + currentPath;
  }

  void onRouterClick(RouterVo router) {
    if (UrlUtil.isUrl(router.path ?? "")) {
      pushNamed(AppWebViewPage.routeName, arguments: {
        ConstantBase.KEY_INTENT_TITLE: router.meta?.title,
        ConstantBase.KEY_INTENT_URL: router.path
      });
      return;
    }
    if (ConstantSysApi.VALUE_COMPONENT_LAYOUT == router.component &&
        !ObjectUtil.isEmptyList(router.children)) {
      pushNamed(MenuPage.routeName, arguments: {
        ConstantBase.KEY_INTENT_TITLE: router.getRouterTitle(),
        "routerList": router.children,
        "parentPath": _targetPathByRouter(router)
      });
      return;
    }
    if (ConstantSysApi.VALUE_COMPONENT_PARENT_VIEW == router.component) {
      pushNamed(_targetPathByRouter(router), arguments: {
        ConstantBase.KEY_INTENT_TITLE: router.meta?.title ?? S.current.app_name,
        ConstantSysApi.INTENT_KEY_ROUTER: router
      });
      return;
    }
    pushNamed(_targetPathByRouter(router),
        arguments: {ConstantBase.KEY_INTENT_TITLE: router.meta?.title ?? S.current.app_name});
  }

  @override
  void dispose() {
    super.dispose();
  }
}
