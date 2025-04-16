import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/list_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/dept_api.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_add_edit_page.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';
import '../../../../feature/component/tree/vd/tree_data_list_vd.dart';
import '../../../../lib/fast/utils/app_toast.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../entity/dept_tree.dart';
import 'dept_list_page_vd.dart';

///
/// 部门浏览列表
///
class DeptListBrowserPage extends AppBaseStatelessWidget<_DeptListBrowserVm> {
  static const String routeName = '/system/dept';

  final String title;

  DeptListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _DeptListBrowserVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm();
        return PopScope(
            canPop: false,
            onPopInvokedWithResult:
                getVm().listVmSub.getPopInvokedWithTree(handlerFirst: (didPop, result) {
              if (didPop) {
                return true;
              }
              if (getVm().listVmSub.selectModelIsRun) {
                getVm().listVmSub.selectModelIsRun = false;
                return true;
              }
              return false;
            }, handlerLast: (didPop, result) {
              Navigator.pop(context);
            }),
            child: Scaffold(
                appBar: AppBar(
                  leading: NqSelector<_DeptListBrowserVm, bool>(builder: (context, value, child) {
                    return WidgetUtils.getAnimCrossFade(const CloseButton(), const BackButton(),
                        showOne: value);
                  }, selector: (context, vm) {
                    return vm.listVmSub.selectModelIsRun;
                  }),
                  title: Text(title),
                  //此处需要更改或完善
                  /*actions: [
                      NqSelector<_DeptListBrowserVm2, bool>(builder: (context, value, child) {
                        return AnimatedSize(
                            duration: WidgetUtils.adminDurationNormal,
                            child: Row(
                              children: [
                                ...() {
                                  List<Widget> actions = [];
                                  if (value) {
                                    actions.addAll(WidgetUtils.getDeleteFamilyAction(onDelete: () {
                                      getVm().onDelete(confirmHandler: (nameList) {
                                        return FastDialogUtils.showDelConfirmDialog(context,
                                            contentText: TextUtil.format(
                                                S.current.user_label_dept_del_prompt,
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
                    ]*/
                ),
                //图标滚动使用固定大小来解决
                floatingActionButton:
                    globalVm.userShareVm.widgetWithPermiAny(["system:dept:add"], () {
                  return NqSelector<_DeptListBrowserVm, bool>(builder: (context, value, child) {
                    return WidgetUtils.getAnimVisibility(
                        !value,
                        FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              getVm().onAddDept();
                            }));
                  }, selector: (context, vm) {
                    return vm.listVmSub.selectModelIsRun;
                  });
                }),
                body: Column(children: [
                  Selector<_DeptListBrowserVm, List<SlcTreeNav>>(builder: (context, value, child) {
                    return TreeNavVd.getNavWidget(themeData, value, (currentItem) {
                      getVm().listVmSub.previous(currentItem.id);
                    });
                  }, selector: (context, vm) {
                    return vm.listVmSub.treeNacStacks;
                  }, shouldRebuild: (oldVal, newVal) {
                    return true;
                  }),
                  Expanded(
                      child: ListDataVd(getVm().listVmSub, getVm(),
                          refreshOnStart: true,
                          child: NqSelector<_DeptListBrowserVm, int>(builder: (context, vm, child) {
                            return DeptListPageWidget.getDataListWidget(
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
                          })))
                ])));
      },
    );
  }
}

//点击列表直接切换数据 存储上级数据列表 返回时直接获取上级加载
class _DeptListBrowserVm extends AppBaseVm {
  late DeptTreeListDataVmSub listVmSub;

  _DeptListBrowserVm() {
    listVmSub = DeptTreeListDataVmSub(this);
    listVmSub.enableSelectModel = false; // 此处不用显式调用，默认就是false，此处不开启是因为后端不允许一次性删除多个
    listVmSub.onSuffixClick = (DeptTree data) {
      pushNamed(DeptAddEditPage.routeName, arguments: {ConstantUser.KEY_DEPT: Dept(deptId: data.id, deptName: data.label)}).then((value) {
        if (value != null) {
          listVmSub.sendRefreshEvent();
        }
      });
    };
  }

  void initVm() {
    registerVmSub(listVmSub);
    SlcTreeNav slcTreeNav =
        SlcTreeNav(ConstantBase.VALUE_PARENT_ID_DEF, S.current.user_label_top_dept);
    listVmSub.next(slcTreeNav, notify: false);
  }

  ///添加部门事件
  void onAddDept() {
    //此处刚好把_currentSearch作为参数进行赋值传输
    pushNamed(DeptAddEditPage.routeName, arguments: {
      ConstantUser.KEY_PARENT_DEPT:
          Dept(deptId: listVmSub.getLastTree()!.id, deptName: listVmSub.getLastTree()?.treeName)
    }).then((value) {
      if (value != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }

  //删除事件
  void onDelete({Future<bool?> Function(List<String>)? confirmHandler, List<int>? idList}) {
    if (idList == null) {
      List<DeptTree> selectList = SelectUtils.getSelect(listVmSub.dataList) ?? [];
      if (selectList.isEmpty) {
        AppToastUtil.showToast(msg: S.current.user_label_dept_del_select_empty);
        return;
      }
      List<String> nameList = selectList.map<String>((item) => item.label).toList();
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
    DeptRepository.delete(listVmSub.defCancelToken, deptIds: idList).then((value) {
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
