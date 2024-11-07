import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/vd/list_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/extras/system/repository/remote/dept_api.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../base/ui/vd/list_data_component.dart';
import '../../../../base/ui/vd/refresh/content_empty.dart';
import '../../../../extras/component/tree/entity/slc_tree_nav.dart';
import '../../../../extras/component/tree/vmbox/tree_data_list_vm_vox.dart';
import '../../../../extras/user/entity/dept.dart';

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
            onPopInvokedWithResult: (canPop, result) {
              if (canPop) {
                return;
              }
              if (getVm().canPop()) {
                Navigator.pop(context);
                return;
              }
              getVm().autoPrevious();
            },
            child: Scaffold(
                appBar: AppBar(title: Text(title)),
                //图标滚动使用固定大小来解决
                body: Column(children: [
                  Selector<_DeptListBrowserVm, List<SlcTreeNav>>(builder: (context, value, child) {
                    //最后一个
                    SlcTreeNav lastItem = value.last;
                    return Row(
                      children: [
                        SvgPicture.asset("assets/images/slc/user_ic_folder.svg",
                            height: 16, color: themeData.primaryColor),
                        Expanded(
                            child: SizedBox(
                                height: 32,
                                child: ListView.builder(
                                    itemCount: value.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (ctx, index) {
                                      SlcTreeNav currentItem = value[index];
                                      if (lastItem == currentItem) {
                                        return Row(children: [
                                          Icon(Icons.arrow_right, color: themeData.primaryColor),
                                          Text(currentItem.treeName,
                                              style: TextStyle(color: themeData.primaryColor))
                                        ]);
                                      } else {
                                        return GestureDetector(
                                            child: Row(children: [
                                              Icon(Icons.arrow_right,
                                                  color: SlcColors.getTextColorSecondaryByTheme(themeData)),
                                              Text(currentItem.treeName,
                                                  style: TextStyle(
                                                      color: SlcColors.getTextColorSecondaryByTheme(
                                                          themeData)))
                                            ]),
                                            onTap: () {
                                              getVm().previous(currentItem.id);
                                            });
                                      }
                                    })))
                      ],
                    );
                    return Row(
                      children: getNavWidget(themeData, value),
                    );
                  }, selector: (context, vm) {
                    return vm.listVmBox.treeNacStacks;
                  }, shouldRebuild: (oldVal, newVal) {
                    return true;
                  }),
                  Expanded(
                      child: ListDataVd(getVm().listVmBox, getVm(), refreshOnStart: true,
                          child: Consumer<_DeptListBrowserVm>(builder: (context, vm, child) {
                    if (vm.listVmBox.dataList.isEmpty) {
                      return const ContentEmptyWrapper();
                    }
                    return ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.zero,
                      itemCount: vm.listVmBox.dataList.length,
                      itemBuilder: (ctx, index) {
                        Dept listItem = vm.listVmBox.dataList[index];
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 1),
                            child: ListTile(
                                trailing: Ink(
                                    child: InkWell(
                                        child: Padding(
                                            padding: EdgeInsets.all(SlcDimens.appDimens12),
                                            child: const Icon(Icons.chevron_right, size: 24)),
                                        onTap: () {
                                          //点击事件
                                        })),
                                contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
                                title: Text(listItem.deptNameVo()),
                                visualDensity: VisualDensity.compact,
                                tileColor: SlcColors.getCardColorByTheme(themeData),
                                //根据card规则实现
                                onTap: () {
                                  getVm().nextByDept(listItem);
                                }));
                      },
                    );
                  })))
                ])));
      },
    );
  }

  List<Widget> getNavWidget(ThemeData themeData, List<SlcTreeNav> treeNavList) {
    List<Widget> navWidget = List.empty(growable: true);
    navWidget.add(SvgPicture.asset("assets/images/slc/user_ic_folder.svg",
        height: 16, color: themeData.primaryColor));
    if (treeNavList.isNotEmpty) {
      SlcTreeNav lastItem = treeNavList.last;
      for (var value in treeNavList) {
        if (lastItem == value) {
          navWidget.add(Row(children: [
            Icon(Icons.arrow_right, color: themeData.primaryColor),
            Text(value.treeName, style: TextStyle(color: themeData.primaryColor))
          ]));
        } else {
          navWidget.add(GestureDetector(
              child: Row(children: [
                Icon(Icons.arrow_right, color: SlcColors.getTextColorSecondaryByTheme(themeData)),
                Text(value.treeName,
                    style: TextStyle(color: SlcColors.getTextColorSecondaryByTheme(themeData)))
              ]),
              onTap: () {
                getVm().previous(value.id);
              }));
        }
      }
    }
    return navWidget;
  }
}

//TODO d点击列表直接切换数据 存储上级数据列表 返回时直接获取上级加载
class _DeptListBrowserVm extends AppBaseVm {
  final TreeFastBaseListDataVmBox<Dept> listVmBox = TreeFastBaseListDataVmBox();

  Dept _currentSearch = Dept(parentId: ConstantBase.VALUE_PARENT_ID_DEF);

  void initVm() {
    listVmBox.setRefresh(() async {
      try {
        IntensifyEntity<List<Dept>> intensifyEntity = await DeptServiceRepository.list(_currentSearch);
        DateWrapper<List<Dept>> dateWrapper = DateTransformUtils.entity2LDWrapper(intensifyEntity);
        return dateWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DateWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //类似于Android的runPost
    /*WidgetsBinding.instance.endOfFrame.then((value) {
      SlcTreeNav slcTreeNav = SlcTreeNav(ConstantBase.VALUE_PARENT_ID_DEF, S.current.user_label_top_dept);
      next(slcTreeNav);
    });*/
    SlcTreeNav slcTreeNav = SlcTreeNav(ConstantBase.VALUE_PARENT_ID_DEF, S.current.user_label_top_dept);
    next(slcTreeNav, notify: false);
  }

  ///根据部门信息获取下一个节点
  void nextByDept(Dept dept) {
    SlcTreeNav slcTreeNav = SlcTreeNav(dept.deptId, dept.deptName!);
    next(slcTreeNav, notify: true);
  }

  ///下一个节点
  void next(SlcTreeNav treeNav, {bool notify = true}) {
    _currentSearch.parentId = treeNav.id;
    listVmBox.next(treeNav, notify: notify);
    if (notify) {
      notifyListeners();
    }
  }

  ///自动上一级
  void autoPrevious() {
    dynamic previousTreeId = listVmBox.getPreviousTreeId();
    if (previousTreeId != null) {
      previous(previousTreeId);
    }
  }

  ///上一级
  void previous(dynamic treeId) {
    _currentSearch.parentId = treeId;
    listVmBox.previous(treeId);
    notifyListeners();
  }

  bool canPop() {
    return !listVmBox.canPrevious();
  }
}
