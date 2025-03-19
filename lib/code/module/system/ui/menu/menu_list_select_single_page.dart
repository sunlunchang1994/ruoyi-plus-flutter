import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_menu.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/component/tree/vd/tree_data_list_vd.dart';
import '../../../../lib/fast/vd/list_data_vd.dart';
import 'menu_list_page_vd.dart';
import 'tree/menu_tree_page_vd.dart';

class MenuListSelectSinglePage extends AppBaseStatelessWidget<_MenuListSelectSingleVm> {
  static const String routeName = '/system/menu/select_single';

  final String title;

  MenuListSelectSinglePage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _MenuListSelectSingleVm(),
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
                body: Column(children: [
                  Selector<_MenuListSelectSingleVm, List<SlcTreeNav>>(
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
                              Consumer<_MenuListSelectSingleVm>(
                                  builder: (context, vm, child) {
                    return MenuListPageWidget.getDataListWidget(
                        themeData, getVm().listVmSub, (currentItem) {
                      return Ink(
                          child: InkWell(
                              child: Padding(
                                  padding: EdgeInsets.all(SlcDimens.appDimens12),
                                  child: const Icon(Icons.radio_button_off, size: 24)),
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

class _MenuListSelectSingleVm extends AppBaseVm {
  late MenuListDataVmSub listVmSub;

  _MenuListSelectSingleVm(){
    listVmSub = MenuListDataVmSub(this);
  }

  void initVm() {
    registerVmSub(listVmSub);
    SlcTreeNav slcTreeNav =
        SlcTreeNav(ConstantBase.VALUE_PARENT_ID_DEF, S.current.menu_label_root);
    listVmSub.next(slcTreeNav, notify: false);

    listVmSub.onSuffixClick = (SysMenu data) {
      //选择了
      finish(result: data);
    };
  }
}
