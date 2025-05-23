import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/tree/vd/tree_data_list_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_menu.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_vd.dart';
import '../../config/constant_sys.dart';
import 'menu_add_edit_page.dart';
import 'menu_list_page_vd.dart';
import 'tree/menu_tree_page_vd.dart';

class MenuListBrowserPage extends AppBaseStatelessWidget<_MenuListBrowserVm> {
  static const String routeName = '/system/menu';

  final String title;

  MenuListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _MenuListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return PopScope(
            canPop: false,
            onPopInvokedWithResult:
                getVm().listVmSub.getPopInvokedWithTree(handlerLast: (didPop, result) {
              Navigator.pop(context);
            }),
            child: Scaffold(
                appBar: AppBar(title: Text(title)),
                floatingActionButton:
                    globalVm.userShareVm.widgetWithPermiAny(["system:menu:add"], () {
                  return NqSelector<_MenuListBrowserVm, bool>(builder: (context, value, child) {
                    return WidgetUtils.getAnimVisibility(
                        !value,
                        FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              getVm().onAddItem();
                            }));
                  }, selector: (context, vm) {
                    return vm.listVmSub.selectModelIsRun;
                  });
                }),
                body: Column(children: [
                  Selector<_MenuListBrowserVm, List<SlcTreeNav>>(
                    builder: (context, value, child) {
                      return TreeNavVd.getNavWidget(themeData, value, (currentItem) {
                        getVm().listVmSub.previous(currentItem.id);
                      });
                    },
                    selector: (context, vm) {
                      return vm.listVmSub.treeNacStacks;
                    },
                    shouldRebuild: (oldVal, newVal) {
                      return true;
                    },
                  ),
                  Expanded(
                      child: ListDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
                          child: Consumer<_MenuListBrowserVm>(builder: (context, vm, child) {
                    return MenuListPageWidget.getDataListWidget(themeData, getVm().listVmSub,
                        (currentItem) {
                      return Ink(
                          child: InkWell(
                              child: Padding(
                                  padding: EdgeInsets.all(SlcDimens.appDimens12),
                                  child: const Icon(Icons.chevron_right, size: 24)),
                              onTap: () {
                                //点击更多事件
                                getVm().listVmSub.onSuffixClick?.call(currentItem);
                              }));
                    });
                  })))
                ])),
          );
        });
  }
}

class _MenuListBrowserVm extends AppBaseVm {
  late MenuListDataVmSub listVmSub;

  _MenuListBrowserVm() {
    listVmSub = MenuListDataVmSub(this);
  }

  void initVm() {
    registerVmSub(listVmSub);

    listVmSub.onSuffixClick = (SysMenu data) {
      pushNamed(MenuAddEditPage.routeName, arguments: {ConstantSys.KEY_MENU: data}).then((value) {
        if (value != null) {
          listVmSub.refreshAndClearTreeStacks();
        }
      });
    };

    SlcTreeNav slcTreeNav = SlcTreeNav(ConstantBase.VALUE_PARENT_ID_DEF, S.current.menu_label_root);
    listVmSub.next(slcTreeNav, notify: false);
  }

  ///添加菜单事件
  void onAddItem() {
    SlcTreeNav? lastTree = listVmSub.getLastTree();
    pushNamed(MenuAddEditPage.routeName, arguments: {
      ConstantSys.KEY_MENU_PARENT: SysMenu(menuId: lastTree?.id, menuName: lastTree?.treeName)
    }).then((result) {
      if (result != null) {
        //更新列表
        listVmSub.refreshAndClearTreeStacks();
      }
    });
  }
}
