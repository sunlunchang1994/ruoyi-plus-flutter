import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/component/tree/vd/tree_data_list_vd.dart';
import '../../../../lib/fast/vd/list_data_vd.dart';
import 'menu_tree_page_vd.dart';

class MenuTreeBrowserPage extends AppBaseStatelessWidget<_MenuTreeBrowserVm> {
  static const String routeName = '/system/menu/browser';

  final String title;

  MenuTreeBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _MenuTreeBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }
              if (getVm().listVmSub.canPop()) {
                Navigator.pop(context);
                return;
              }
              getVm().listVmSub.autoPrevious();
            },
            child: Scaffold(
                appBar: AppBar(title: Text(title)),
                body: Column(children: [
                  Selector<_MenuTreeBrowserVm, List<SlcTreeNav>>(
                    builder: (context, value, child) {
                      return TreeNavVd.getNavWidget(themeData, value,
                          (currentItem) {
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
                      child: ListDataVd(getVm().listVmSub, getVm(),
                          refreshOnStart: true, child:
                              Consumer<_MenuTreeBrowserVm>(
                                  builder: (context, vm, child) {
                    return MenuTreePageWidget.getDataListWidget(
                        themeData, getVm().listVmSub, (currentItem) {
                      return Ink(
                          child: InkWell(
                              child: Padding(
                                  padding:
                                      EdgeInsets.all(SlcDimens.appDimens12),
                                  child: const Icon(Icons.chevron_right,
                                      size: 24)),
                              onTap: () {
                                //点击更多事件
                                getVm()
                                    .listVmSub
                                    .onSuffixClick
                                    ?.call(currentItem);
                              }));
                    });
                  })))
                ])),
          );
        });
  }
}

class _MenuTreeBrowserVm extends AppBaseVm {
  late RoleMenuTreeListDataVmSub listVmSub;

  void initVm() {
    listVmSub = RoleMenuTreeListDataVmSub(this);
    registerVmSub(listVmSub);
    SlcTreeNav slcTreeNav =
        SlcTreeNav(ConstantBase.VALUE_PARENT_ID_DEF, S.current.menu_label_root);
    listVmSub.next(slcTreeNav, notify: false);
  }
}
