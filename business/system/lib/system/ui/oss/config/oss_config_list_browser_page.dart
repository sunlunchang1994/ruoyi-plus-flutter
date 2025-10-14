import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:boxes_flutter/flutter/slc/adapter/select_box.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:provider/provider.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:fast/fast/provider/fast_select.dart';
import 'package:fast/fast/vd/page_data_vd.dart';
import 'package:system/gen/sys_l10n.dart';
import 'package:system/system/entity/sys_oss_config.dart';
import 'package:system/system/repository/remote/sys_oss_config_api.dart';

import 'package:base/base/api/base_dio.dart';
import 'package:base/base/ui/utils/fast_dialog_utils.dart';
import 'package:fast/fast/utils/app_toast.dart';
import 'package:fast/fast/utils/widget_utils.dart';
import 'package:bizapi/user/vm/user_share_vm.dart';
import 'oss_config_add_edit_page.dart';
import 'oss_config_list_page_vd.dart';

///
/// @author slc
/// OssConfig列表
class OssConfigListBrowserPage extends AppBaseStatelessWidget<_OssConfigListBrowserVm> {
  static const String routeName = '/system/oss/config';

  OssConfigListBrowserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _OssConfigListBrowserVm(),
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
                      leading: NqSelector<_OssConfigListBrowserVm, bool>(
                          builder: (context, value, child) {
                        return WidgetUtils.getAnimCrossFade(const CloseButton(), const BackButton(),
                            showOne: value);
                      }, selector: (context, vm) {
                        return vm.listVmSub.selectModelIsRun;
                      }),
                      title: Text(S.current.sys_label_oss_config_name),
                      actions: [
                        NqSelector<_OssConfigListBrowserVm, bool>(builder: (context, value, child) {
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
                                                  S.current.sys_label_oss_config_del_prompt,
                                                  [nameList.join(TextUtil.comma)]));
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
                        })
                      ]),
                  endDrawer: OssConfigListPageWidget.getSearchEndDrawer<_OssConfigListBrowserVm>(
                      context, themeData, getVm().listVmSub),
                  floatingActionButton:
                      UserShareVm().widgetWithPermiAny(["system:ossConfig:add"], () {
                    return NqSelector<_OssConfigListBrowserVm, bool>(
                        builder: (context, value, child) {
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
                  body: PageDataVd(getVm().listVmSub, getVm(),
                      refreshOnStart: true,
                      child:
                          NqSelector<_OssConfigListBrowserVm, int>(builder: (context, vm, child) {
                        return OssConfigListPageWidget.getDataListWidget(
                            themeData, getVm().listVmSub);
                      }, selector: (context, vm) {
                        return vm.listVmSub.shouldSetState.version;
                      }))));
        });
  }
}

class _OssConfigListBrowserVm extends AppBaseVm {
  late OssConfigListDataVmSub listVmSub;

  _OssConfigListBrowserVm() {
    listVmSub = OssConfigListDataVmSub();
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

  void initVm() {
    registerVmSub(listVmSub);
  }

  ///添加Oss事件
  void onAddItem() {
    pushNamed(OssConfigAddEditPage.routeName).then((result) {
      if (result != null) {
        //更新列表
        listVmSub.sendRefreshEvent();
      }
    });
  }

  //删除事件
  void onDelete({Future<bool?> Function(List<String>)? confirmHandler, List<int>? idList}) {
    if (idList == null) {
      List<SysOssConfig> selectList = SelectUtils.getSelect(listVmSub.dataList) ?? [];
      if (selectList.isEmpty) {
        AppToastUtil.showToast(msg: S.current.sys_label_oss_config_del_select_empty);
        return;
      }
      List<String> nameList = selectList.map<String>((item) => item.configKey!).toList();
      List<int> idList = selectList.map<int>((item) => item.ossConfigId!).toList();
      confirmHandler?.call(nameList).then((value) {
        if (value == true) {
          onDelete(idList: idList);
        }
      });
      return;
    }
    //删除
    showLoading(text: FastS.current.label_delete_ing);
    SysOssConfigRepository.delete(listVmSub.defCancelToken, ids: idList).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: FastS.current.label_delete_success);
      listVmSub.sendRefreshEvent();
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: FastS.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}
