import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../lib/fast/utils/app_toast.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../entity/sys_client.dart';
import '../../repository/remote/sys_client_api.dart';
import 'sys_client_add_edit_page.dart';
import 'sys_client_list_page_vd.dart';

///
/// @author slc
/// OssClient列表
class SysClientListBrowserPage extends AppBaseStatelessWidget<_SysClientListBrowserVm> {
  static const String routeName = '/system/client';

  final String title;
  SysClientListBrowserPage(this.title,{super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _SysClientListBrowserVm(),
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
              appBar: AppBar(leading:
              NqSelector<_SysClientListBrowserVm, bool>(builder: (context, value, child) {
                return WidgetUtils.getAnimCrossFade(const CloseButton(), const BackButton(),
                    showOne: value);
              }, selector: (context, vm) {
                return vm.listVmSub.selectModelIsRun;
              }),
                  title: Text(title),
                  actions: [
                    NqSelector<_SysClientListBrowserVm, bool>(builder: (context, value, child) {
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
                                              S.current.sys_label_sys_client_del_prompt,
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
                    })
              ]),
              endDrawer: OssConfigListPageWidget.getSearchEndDrawer<_SysClientListBrowserVm>(
                  context, themeData, getVm().listVmSub),
              floatingActionButton:
              NqSelector<_SysClientListBrowserVm, bool>(builder: (context, value, child) {
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
                  child: NqSelector<_SysClientListBrowserVm, int>(builder: (context, vm, child) {
                    return OssConfigListPageWidget.getDataListWidget(themeData, getVm().listVmSub);
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  }))));
        });
  }
}

class _SysClientListBrowserVm extends AppBaseVm {
  late SysClientListDataVmSub listVmSub;

  _SysClientListBrowserVm() {
    listVmSub = SysClientListDataVmSub();
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

  ///添加客户端事件
  void onAddItem() {
    pushNamed(SysClientAddEditPage.routeName).then((result) {
      if (result != null) {
        //更新列表
        listVmSub.sendRefreshEvent();
      }
    });
  }

  //删除事件
  void onDelete({Future<bool?> Function(List<String>)? confirmHandler, List<int>? idList}) {
    if (idList == null) {
      List<SysClient> selectList = SelectUtils.getSelect(listVmSub.dataList) ?? [];
      if (selectList.isEmpty) {
        AppToastUtil.showToast(msg: S.current.sys_label_sys_client_del_select_empty);
        return;
      }
      List<String> nameList = selectList.map<String>((item) => item.clientId!).toList();
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
    SysClientRepository.delete(listVmSub.defCancelToken, ids: idList).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.label_delete_success);
      listVmSub.sendRefreshEvent();
    }, onError: (e) {
      dismissLoading();
      BaseDio.handlerErr(e);
      AppToastUtil.showToast(msg: S.current.label_delete_failed);
    });
  }
}
