import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../feature/bizapi/user/config/constant_user_api.dart';
import '../../../../feature/bizapi/user/entity/role.dart';
import '../../repository/remote/role_api.dart';

///
/// @author slc
/// 角色列表
class RoleListBrowserPage extends AppBaseStatelessWidget<_RoleListBrowserVm> {
  static const String routeName = '/system/role';
  final String title;

  RoleListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _RoleListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return PopScope(
              canPop: false,
              onPopInvokedWithResult: (canPop, result) {
                if (canPop) {
                  return;
                }
                if (getVm().listVmSub.selectModelIsRun) {
                  getVm().listVmSub.selectModelIsRun = false;
                  return;
                }
                Navigator.pop(context);
              },
              child: Scaffold(
                  appBar: AppBar(
                      leading:
                          NqSelector<_RoleListBrowserVm, bool>(builder: (context, value, child) {
                        return WidgetUtils.getAnimCrossFade(const CloseButton(), const BackButton(),
                            showOne: value);
                      }, selector: (context, vm) {
                        return vm.listVmSub.selectModelIsRun;
                      }),
                      title: Text(title),
                      actions: [
                        NqSelector<_RoleListBrowserVm, bool>(builder: (context, value, child) {
                          return AnimatedSize(
                              duration: WidgetUtils.adminDurationNormal,
                              child: Row(
                                children: [
                                  ...() {
                                    List<Widget> actions = [];
                                    if (value) {
                                      actions
                                          .addAll(WidgetUtils.getDeleteFamilyAction(onDelete: () {
                                        getVm().onDelete(confirmHandler: (nameList) {
                                          return FastDialogUtils.showDelConfirmDialog(context,
                                              contentText: TextUtil.format(
                                                  S.current.user_label_role_del_prompt,
                                                  [nameList.join(TextUtil.COMMA)]));
                                        });
                                      }, onSelectAll: () {
                                        getVm().listVmSub.onSelectAll(true);
                                      }, onDeselect: () {
                                        getVm().listVmSub.onSelectAll(false);
                                      }));
                                    } else {
                                      actions.add(Builder(builder: (context) {
                                        return IconButton(
                                          icon: const Icon(Icons.search),
                                          onPressed: () {
                                            WidgetUtils.autoHandlerSearchDrawer(context);
                                          },
                                        );
                                      }));
                                    }
                                    return actions;
                                  }.call()
                                ],
                              ));
                        }, selector: (context, vm) {
                          return vm.listVmSub.selectModelIsRun;
                        }),
                      ]),
                  endDrawer: RoleListPageVd.getSearchEndDrawer<_RoleListBrowserVm>(
                      context, themeData, getVm().listVmSub),
                  floatingActionButton:
                      globalVm.userShareVm.widgetWithPermiAny(["system:role:add"], () {
                    return NqSelector<_RoleListBrowserVm, bool>(builder: (context, value, child) {
                      return WidgetUtils.getAnimVisibility(
                          !value,
                          FloatingActionButton(
                              child: Icon(Icons.add),
                              onPressed: () {
                                getVm().onAddRole();
                              }));
                    }, selector: (context, vm) {
                      return vm.listVmSub.selectModelIsRun;
                    });
                  }),
                  body: PageDataVd(getVm().listVmSub, getVm(),
                      refreshOnStart: true,
                      child: NqSelector<_RoleListBrowserVm, int>(builder: (context, vm, child) {
                        return RoleListPageVd.getUserListWidget(themeData, getVm().listVmSub);
                      }, selector: (context, vm) {
                        return vm.listVmSub.shouldSetState.version;
                      }))));
        });
  }
}

class _RoleListBrowserVm extends AppBaseVm {
  late RolePageDataVmSub listVmSub;

  _RoleListBrowserVm() {
    listVmSub = RolePageDataVmSub();
    listVmSub.enableSelectModel = true;
    listVmSub.setItemClick((index, role) {
      pushNamed(RoleAddEditPage.routeName, arguments: {ConstantUser.KEY_ROLE: role}).then((result) {
        if (result != null) {
          listVmSub.sendRefreshEvent();
        }
      });
    });
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  ///添加角色事件
  void onAddRole() {
    pushNamed(RoleAddEditPage.routeName).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }

  //删除事件
  void onDelete({Future<bool?> Function(List<String>)? confirmHandler, List<int>? idList}) {
    if (idList == null) {
      List<Role> selectList = SelectUtils.getSelect(listVmSub.dataList) ?? [];
      //移除超级管理员角色
      selectList.removeWhere((item) {
        return item.roleId == ConstantUserApi.VALUE_SUPER_ADMIN_ROLE_ID;
      });
      if (selectList.isEmpty) {
        AppToastUtil.showToast(msg: S.current.user_label_role_del_select_empty);
        return;
      }
      List<String> nameList = selectList.map<String>((item) => item.roleName!).toList();
      List<int> idList = selectList.map<int>((item) => item.roleId!).toList();
      confirmHandler?.call(nameList).then((value) {
        if (value == true) {
          onDelete(idList: idList);
        }
      });
      return;
    }
    //删除
    showLoading(text: S.current.label_delete_ing);
    RoleRepository.delete(listVmSub.defCancelToken, roleIds: idList).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.label_delete_success);
      listVmSub.sendRefreshEvent();
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: S.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}
