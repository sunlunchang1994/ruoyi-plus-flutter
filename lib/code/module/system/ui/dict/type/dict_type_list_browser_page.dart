import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/post/post_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/post/post_list_page_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_page_vd.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../../feature/bizapi/system/entity/sys_dict_type.dart';
import '../../../../../lib/fast/utils/app_toast.dart';
import '../../../config/constant_sys.dart';
import '../../../repository/remote/dict_type_api.dart';
import 'dict_type_add_edit_page.dart';
import 'dict_type_list_page_vd.dart';

///
/// @author slc
/// 字典类型列表
class DictTypeListBrowserPage extends AppBaseStatelessWidget<_DictTypeListBrowserVm> {
  static const String routeName = '/system/dict';
  final String title;

  DictTypeListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _DictTypeListBrowserVm(),
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
                      leading: NqSelector<_DictTypeListBrowserVm, bool>(
                          builder: (context, value, child) {
                        return WidgetUtils.getAnimCrossFade(const CloseButton(), const BackButton(),
                            showOne: value);
                      }, selector: (context, vm) {
                        return vm.listVmSub.selectModelIsRun;
                      }),
                      title: Text(title),
                      actions: [
                        NqSelector<_DictTypeListBrowserVm, bool>(builder: (context, value, child) {
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
                                                  S.current.sys_label_config_del_prompt,
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
                  endDrawer: DictTypeListPageWidget.getSearchEndDrawer<_DictTypeListBrowserVm>(
                      context, themeData, getVm().listVmSub),
                  floatingActionButton:
                      NqSelector<_DictTypeListBrowserVm, bool>(builder: (context, value, child) {
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
                      child: NqSelector<_DictTypeListBrowserVm, int>(builder: (context, vm, child) {
                        return DictTypeListPageWidget.getDataListWidget(
                            themeData, getVm().listVmSub, (currentItem) {
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

class _DictTypeListBrowserVm extends AppBaseVm {
  late DictTypeListDataVmSub listVmSub;

  _DictTypeListBrowserVm() {
    listVmSub = DictTypeListDataVmSub();
    listVmSub.enableSelectModel = true;
    listVmSub.onSuffixClick = (itemData) {
      pushNamed(DictTypeAddEditPage.routeName, arguments: {ConstantSys.KEY_DICT_TYPE: itemData})
          .then((result) {
        if (result != null) {
          //更新列表
          listVmSub.sendRefreshEvent();
        }
      });
    };
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  ///添加字典类型事件
  void onAddItem() {
    pushNamed(DictTypeAddEditPage.routeName).then((result) {
      if (result != null) {
        //更新列表
        listVmSub.sendRefreshEvent();
      }
    });
  }

  //删除事件
  void onDelete({Future<bool?> Function(List<String>)? confirmHandler, List<int>? idList}) {
    if (idList == null) {
      List<SysDictType> selectList = SelectUtils.getSelect(listVmSub.dataList) ?? [];
      if (selectList.isEmpty) {
        AppToastUtil.showToast(msg: S.current.sys_label_dict_del_select_empty);
        return;
      }
      List<String> nameList = selectList.map<String>((item) => item.dictName!).toList();
      List<int> idList = selectList.map<int>((item) => item.dictId!).toList();
      confirmHandler?.call(nameList).then((value) {
        if (value == true) {
          onDelete(idList: idList);
        }
      });
      return;
    }
    //删除
    showLoading(text: S.current.label_delete_ing);
    DictTypeRepository.delete(listVmSub.defCancelToken, dictTypeIds: idList).then((value) {
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
