import 'dart:collection';

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
import 'package:ruoyi_plus_flutter/code/extras/user/repository/remote/user_api.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../base/ui/vd/list_data_component.dart';
import '../../../../base/ui/vd/list_data_vm_box.dart';
import '../../../../base/ui/vd/refresh/content_empty.dart';
import '../../../../extras/component/tree/entity/slc_tree_nav.dart';
import '../../../../extras/user/entity/dept.dart';

class DeptListBrowserPage extends AppBaseStatelessWidget<_DeptListBrowserVm> {
  static const String routeName = '/dept_list_browser';

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
        return Scaffold(
            appBar: AppBar(title: Text(title)),
            //图标滚动使用固定大小来解决
            body: Column(children: [
              Selector<_DeptListBrowserVm, List<SlcTreeNav>>(builder: (context, value, child) {
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
                            onTap: () {}));
                  },
                );
              })))
            ]));
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
          navWidget.add(Row(children: [
            Icon(Icons.arrow_right, color: SlcColors.getTextColorSecondaryByTheme(themeData)),
            Text(value.treeName, style: TextStyle(color: SlcColors.getTextColorSecondaryByTheme(themeData)))
          ]));
        }
      }
    }
    return navWidget;
  }
}

class TreeFastBaseListDataVmBox<T> extends FastBaseListDataVmBox<T> {
  //部门栈堆数据
  final Map<dynamic, List<T>> treeStacksDataMap = Map.identity();

  //部门栈堆
  final List<SlcTreeNav> treeNacStacks = List.empty(growable: true);

  void next(SlcTreeNav treeNav, {bool notify = false}) {
    treeNacStacks.add(treeNav);
    if (notify) {
      sendRefreshEvent();
    }
  }

  void previous(dynamic treeId) {
    bool arriveTargetTreeId = false;
    List<SlcTreeNav> awaitRemoveNavList = List.empty(growable: true);
    //遍历得到需要移除的导航列表
    for (var item in treeNacStacks) {
      if (arriveTargetTreeId) {
        awaitRemoveNavList.add(item);
      }
      if (item.id == treeId) {
        arriveTargetTreeId = true;
      }
    }
    //移除需要移除的
    for (var item in awaitRemoveNavList) {
      treeNacStacks.remove(item);
      treeStacksDataMap.remove(item.id);
    }
    //设置当前的数据
    List<T>? treStackData = treeStacksDataMap[treeId] ?? List.empty(growable: true);
    onSucceed(treStackData);
  }

  @override
  void onSucceed(List<T> dataList) {
    super.onSucceed(dataList);
    SlcTreeNav slcTreeNav = treeNacStacks.last;
    treeStacksDataMap[slcTreeNav.id] = dataList;
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
    next(slcTreeNav, notify: true);
  }

  void next(SlcTreeNav treeNav, {bool notify = true}) {
    _currentSearch.parentId = treeNav.id;
    listVmBox.next(treeNav, notify: notify);
    notifyListeners();
  }

  void previous(dynamic treeId) {
    _currentSearch.parentId = treeId;
    listVmBox.previous(treeId);
    notifyListeners();
  }
}
