import 'package:fast/fast/utils/app_toast.dart';
import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:boxes_flutter/flutter/slc/adapter/select_box.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:fast/fast/provider/fast_select.dart';
import 'package:fast/fast/utils/widget_utils.dart';
import 'package:fast/fast/vd/page_data_vd.dart';
import 'package:system/gen/sys_l10n.dart';
import 'package:system/system/config/constant_sys.dart';
import 'package:system/system/repository/remote/dict_data_api.dart';

import 'package:base/base/api/base_dio.dart';
import 'package:base/base/ui/utils/fast_dialog_utils.dart';
import 'package:bizapi/system/entity/sys_dict_data.dart';
import 'package:bizapi/user/vm/user_share_vm.dart';
import 'dict_data_add_edit_page.dart';
import 'dict_data_list_page_vd.dart';

///
/// @author slc
/// 字典数据列表
class DictDataListBrowserPage extends AppBaseStatelessWidget<_DictDataListBrowserVm> {
  static const String routeName = '/system/dict/data';
  final String title;
  final String dictType;

  DictDataListBrowserPage(this.title, this.dictType, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _DictDataListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(dictType);
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
                      leading: NqSelector<_DictDataListBrowserVm, bool>(
                          builder: (context, value, child) {
                        return WidgetUtils.getAnimCrossFade(const CloseButton(), const BackButton(),
                            showOne: value);
                      }, selector: (context, vm) {
                        return vm.listVmSub.selectModelIsRun;
                      }),
                      title: Text(title),
                      actions: [
                        NqSelector<_DictDataListBrowserVm, bool>(builder: (context, value, child) {
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
                                                  S.current.sys_label_dict_del_prompt,
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
                  endDrawer: DictTypeListPageWidget.getSearchEndDrawer<_DictDataListBrowserVm>(
                      context, themeData, getVm().listVmSub),
                  floatingActionButton: UserShareVm().widgetWithPermiAny(["system:dict:add"], () {
                    return NqSelector<_DictDataListBrowserVm, bool>(
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
                      child: NqSelector<_DictDataListBrowserVm, int>(builder: (context, vm, child) {
                        return DictTypeListPageWidget.getDataListWidget(
                            themeData, getVm().listVmSub.dataList, getVm().listVmSub,
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
                      }, selector: (context, vm) {
                        return vm.listVmSub.shouldSetState.version;
                      }))));
        });
  }
}

class _DictDataListBrowserVm extends AppBaseVm {
  late DictDataPageVmSub listVmSub;

  _DictDataListBrowserVm() {
    listVmSub = DictDataPageVmSub();
    listVmSub.enableSelectModel = true;
    listVmSub.onSuffixClick = (itemData) {
      pushNamed(DictDataAddEditPage.routeName, arguments: {ConstantSys.KEY_DICT_DATA: itemData})
          .then((result) {
        if (result != null) {
          //更新列表
          listVmSub.sendRefreshEvent();
        }
      });
    };
  }

  void initVm(String dictType) {
    registerVmSub(listVmSub);
    listVmSub.currentSearch.dictType = dictType;
  }

  ///添加字典数据事件
  void onAddItem() {
    pushNamed(DictDataAddEditPage.routeName,
            arguments: {ConstantSys.KEY_DICT_PARENT_TYPE: listVmSub.currentSearch.dictType})
        .then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }

  //删除事件
  void onDelete({Future<bool?> Function(List<String>)? confirmHandler, List<int>? idList}) {
    if (idList == null) {
      List<SysDictData> selectList = SelectUtils.getSelect(listVmSub.dataList) ?? [];
      if (selectList.isEmpty) {
        AppToastUtil.showToast(msg: S.current.sys_label_dict_del_select_empty);
        return;
      }
      List<String> nameList = selectList.map<String>((item) => item.dictLabel!).toList();
      List<int> idList = selectList.map<int>((item) => item.dictCode!).toList();
      confirmHandler?.call(nameList).then((value) {
        if (value == true) {
          onDelete(idList: idList);
        }
      });
      return;
    }
    //删除
    showLoading(text: FastS.current.label_delete_ing);
    DictDataRepository.delete(listVmSub.defCancelToken, dictDataIds: idList).then((value) {
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
