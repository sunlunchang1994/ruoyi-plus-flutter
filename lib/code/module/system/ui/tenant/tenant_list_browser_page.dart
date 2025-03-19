import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/utils/fast_dialog_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/system/repository/remote/sys_tenant_api.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/tenant/package/tenant_package_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/tenant/tenant_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/tenant/tenant_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../feature/bizapi/system/entity/sys_tenant.dart';
import '../../../../lib/fast/utils/widget_utils.dart';

///
/// @author slc
/// 租户列表
class TenantListBrowserPage extends AppBaseStatelessWidget<_TenantListBrowserVm> {
  static const String routeName = '/tenant/tenant';
  final String title;

  TenantListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _TenantListBrowserVm(),
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
                          NqSelector<_TenantListBrowserVm, bool>(builder: (context, value, child) {
                        return WidgetUtils.getAnimCrossFade(const CloseButton(), const BackButton(),
                            showOne: value);
                      }, selector: (context, vm) {
                        return vm.listVmSub.selectModelIsRun;
                      }),
                      title: Text(title),
                      actions: [
                        NqSelector<_TenantListBrowserVm, bool>(builder: (context, value, child) {
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
                                                  S.current.sys_label_sys_tenant_del_prompt,
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
                                      actions.add(PopupMenuButton<String>(itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                              value: S.current.sys_label_sys_tenant_sync_dict,
                                              child: Text(S.current.sys_label_sys_tenant_sync_dict))
                                        ];
                                      }, onSelected: (value) {
                                        if (value == S.current.sys_label_sys_tenant_sync_dict) {
                                          //同步套餐
                                          showSyncTenantDictDialog(context);
                                        }
                                      }));
                                    }
                                    return actions;
                                  }.call()
                                ],
                              ));
                        }, selector: (context, vm) {
                          return vm.listVmSub.selectModelIsRun;
                        })
                      ]),
                  endDrawer: TenantListPageWidget.getSearchEndDrawer<_TenantListBrowserVm>(
                      context, themeData, getVm().listVmSub),
                  floatingActionButton:
                      NqSelector<_TenantListBrowserVm, bool>(builder: (context, value, child) {
                    return WidgetUtils.getAnimVisibility(
                        !value,
                        FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              getVm().onAddItem();
                            }));
                  }, selector: (context, vm) {
                    return vm.listVmSub.selectModelIsRun;
                  }),
                  body: PageDataVd(getVm().listVmSub, getVm(),
                      refreshOnStart: true,
                      child: NqSelector<_TenantListBrowserVm, int>(builder: (context, vm, child) {
                        return TenantListPageWidget.getDataListWidget(themeData, getVm().listVmSub);
                      }, selector: (context, vm) {
                        return vm.listVmSub.shouldSetState.version;
                      }))));
        });
  }

  // 同步租户字典对话框
  void showSyncTenantDictDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.current.label_prompt),
            content: Text(S.current.sys_label_sys_tenant_sync_dict_confirm),
            actions: FastDialogUtils.getCommonlyAction(context, positiveLister: () {
              Navigator.of(context).pop();
              getVm().syncTenantDict();
            }),
          );
        });
  }
}

class _TenantListBrowserVm extends AppBaseVm with CancelTokenAssist {
  late TenantListDataVmSub listVmSub;

  _TenantListBrowserVm() {
    listVmSub = TenantListDataVmSub();
    listVmSub.enableSelectModel = true;
    listVmSub.onSuffixClick = (itemData) {
      /*pushNamed(NoticeAddEditPage.routeName,
          arguments: {ConstantSys.KEY_SYS_NOTICE: itemData}).then((result) {
        if (result != null) {
          //更新列表
          listVmSub.sendRefreshEvent();
        }
      });*/
    };
  }

  // 初始化
  void initVm() {
    registerVmSub(listVmSub);
  }

  // 添加租户
  void onAddItem() {
    pushNamed(TenantAddEditPage.routeName).then((result) {
      if (result != null) {
        //更新列表
        listVmSub.sendRefreshEvent();
      }
    });
  }

  // 同步租户字典
  void syncTenantDict() {
    showLoading(text: S.current.sys_label_sys_tenant_sync_dict);
    SysTenantRepository.syncTenantDict(defCancelToken).then((result) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.sys_label_sys_tenant_sync_dict_succeed);
    }, onError: (e) {
      dismissLoading();
      BaseDio.handlerError(e, defErrMsg: S.current.sys_label_sys_tenant_sync_dict_failed);
    });
  }

  //删除事件
  void onDelete({Future<bool?> Function(List<String>)? confirmHandler, List<int>? idList}) {
    if (idList == null) {
      List<SysTenant> selectList = SelectUtils.getSelect(listVmSub.dataList) ?? [];
      if (selectList.isEmpty) {
        AppToastUtil.showToast(msg: S.current.sys_label_sys_tenant_del_select_empty);
        return;
      }
      List<String> nameList = selectList.map<String>((item) => item.companyName!).toList();
      List<int> idList = selectList.map<int>((item) => item.id!).toList();
      confirmHandler?.call(nameList).then((value) {
        if (value == true) {
          onDelete(idList: idList);
        }
      });
      return;
    }
    //删除
    showLoading(text: S.current.label_delete_ing);
    SysTenantRepository.delete(listVmSub.defCancelToken, ids: idList).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.label_delete_success);
      listVmSub.sendRefreshEvent();
    }, onError: (e) {
      dismissLoading();
      BaseDio.handlerError(e);
      AppToastUtil.showToast(msg: S.current.label_delete_failed);
    });
  }
}
