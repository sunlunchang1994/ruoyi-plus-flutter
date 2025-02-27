import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/code/value_wrapper.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/entity/label_value.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/config/constant_base.dart';
import '../../entity/sys_menu_tree.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/vd/list_data_vd.dart';
import '../../../../lib/fast/widget/menu/slc_checked_popup_menu_item.dart';
import 'menu_tree_page_vd.dart';

class MenuTreeSelectMultiplePage
    extends AppBaseStatelessWidget<_MenuTreeSelectMultipleVm> {
  static const String routeName = '/system/menu/tree_multiple_select';

  final String title;
  final int? roleId;
  final List<int>? checkedIds;

  MenuTreeSelectMultiplePage(this.title,
      {super.key, this.roleId, this.checkedIds});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _MenuTreeSelectMultipleVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(roleId: roleId, checkedIds: checkedIds);
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
                appBar: AppBar(
                  title: Text(title),
                  actions: [
                    IconButton(
                        onPressed: () {
                          List<int> collection = List.empty(growable: true);
                          SysMenuTree.getSelectAll2Ids(
                              collection, getVm().listVmSub.dataList,
                              penetrate: true,
                              linkageEnable: getVm().linkageEnable.data!);
                          getVm().finish(result: collection);
                        },
                        icon: Icon(Icons.save)),
                    PopupMenuButton<ValueWrap<bool>>(
                        itemBuilder: (popupMenuButtonContext) {
                      return [
                        SlcCheckedPopupMenuItem<ValueWrap<bool>>(
                            value: getVm().selectAllEnable,
                            checked: getVm().selectAllEnable.data!,
                            child: Row(
                              children: [
                                Text(
                                    "${S.current.app_label_select_all}/${S.current.app_label_unselect_all}")
                              ],
                            )),
                        SlcCheckedPopupMenuItem<ValueWrap<bool>>(
                            value: getVm().linkageEnable,
                            checked: getVm().linkageEnable.data!,
                            child: Row(
                              children: [
                                Text(S
                                    .current.user_label_menu_father_son_linkage)
                              ],
                            )),
                      ];
                    }, onSelected: (value) {
                      value.data = !value.data!;
                      if (value == getVm().selectAllEnable) {
                        //全选
                        getVm().onSelectAllAction(value.data!);
                      } else if (value == getVm().linkageEnable) {
                        //联动
                        getVm().listVmSub.shouldSetState.updateVersion();
                        getVm().notifyListeners();
                      }
                    })
                  ],
                ),
                body: Column(children: [
                  NqSelector<_MenuTreeSelectMultipleVm, int>(
                      builder: (context, value, child) {
                    return MenuTreePageWidget.getNavWidget(
                        themeData, getVm().listVmSub.treeNacStacks,
                        (currentItem) {
                      getVm().listVmSub.previous(currentItem.id);
                    });
                  }, selector: (context, vm) {
                    return vm.listVmSub.treeNacStacks.length;
                  }),
                  Expanded(
                      child: ListDataVd(getVm().listVmSub, getVm(),
                          refreshOnStart: true,
                          child: NqSelector<_MenuTreeSelectMultipleVm, int>(
                              builder: (context, vm, child) {
                            return MenuTreePageWidget.getDataListWidget(
                                themeData, getVm().listVmSub, (currentItem) {
                              //选择按钮
                              return NqSelector<_MenuTreeSelectMultipleVm,
                                  bool?>(builder: (context, value, child) {
                                return Checkbox(
                                    value: value,
                                    tristate: true,
                                    onChanged: (checkValue) {
                                      getVm().onSelectItem(
                                          currentItem, checkValue ?? false);
                                    });
                              }, selector: (context, vm) {
                                return SelectUtils.getSelectFromSingle(
                                    currentItem,
                                    linkage: vm.linkageEnable.data!);
                                //return currentItem.isBoxChecked();
                              });
                            });
                          }, selector: (context, vm) {
                            return vm.listVmSub.shouldSetState.version;
                          })))
                ])),
          );
        });
  }
}

class _MenuTreeSelectMultipleVm extends AppBaseVm {
  late MenuTreeListDataVmSub listVmSub;

  final ValueWrap<bool> selectAllEnable = ValueWrap(data: false);
  final ValueWrap<bool> linkageEnable = ValueWrap(data: true);

  void initVm({int? roleId, List<int>? checkedIds}) {
    listVmSub =
        MenuTreeListDataVmSub(this, roleId: roleId, checkedIds: checkedIds);
    registerVmSub(listVmSub);

    SlcTreeNav slcTreeNav =
        SlcTreeNav(ConstantBase.VALUE_PARENT_ID_DEF, S.current.menu_label_root);
    listVmSub.next(slcTreeNav, notify: false);
  }

  //选择所有item事件
  void onSelectAllAction(bool isSelected) {
    SelectUtils.selectAll(listVmSub.allTreeList!, isSelected,
        penetrate: linkageEnable.data!);
    notifyListeners();
  }

  //选择单个item
  void onSelectItem(SysMenuTree sysMenuTree, bool isSelected) {
    SelectUtils.selectAll([sysMenuTree], isSelected,
        penetrate: linkageEnable.data!);
    notifyListeners();
  }
}
