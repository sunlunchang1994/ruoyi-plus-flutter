import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/component/tree/vmbox/tree_data_list_vm_vox.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import '../../repository/remote/dept_api.dart';
import 'package:dio/dio.dart';

class DeptListPageWidget {
  ///获取导航视图
  static Widget getNavWidget(ThemeData themeData, List<SlcTreeNav> treeNavList,
      void Function(SlcTreeNav currentItem)? onTap) {
    //最后一个
    SlcTreeNav lastItem = treeNavList.last;
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.only(left: SlcDimens.appDimens16),
            child: SvgPicture.asset("assets/images/slc/user_ic_folder.svg",
                height: 16, color: themeData.primaryColor)),
        Expanded(
            child: SizedBox(
                height: 32,
                child: ListView.builder(
                    itemCount: treeNavList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      SlcTreeNav currentItem = treeNavList[index];
                      if (lastItem == currentItem) {
                        return Row(children: [
                          Icon(Icons.arrow_right,
                              color: themeData.primaryColor),
                          Text(currentItem.treeName,
                              style: TextStyle(color: themeData.primaryColor))
                        ]);
                      } else {
                        return GestureDetector(
                            onTap: () {
                              onTap?.call(currentItem);
                            },
                            //getVm().previous(currentItem.id)
                            child: Row(children: [
                              Icon(Icons.arrow_right,
                                  color: SlcColors.getTextColorSecondaryByTheme(
                                      themeData)),
                              Text(currentItem.treeName,
                                  style: TextStyle(
                                      color: SlcColors
                                          .getTextColorSecondaryByTheme(
                                              themeData)))
                            ]));
                      }
                    })))
      ],
    );
  }

  ///数据列表控件
  static Widget getDataListWidget(
      ThemeData themeData,
      DeptTreeListDataVmSub listVmSub,
      Widget Function(Dept currentItem) buildTrailing) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          Dept listItem = listVmSub.dataList[index];
          return Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: ListTile(
                  contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
                  title: Text(listItem.deptNameVo()),
                  trailing: buildTrailing.call(listItem),
                  visualDensity: VisualDensity.compact,
                  tileColor: SlcColors.getCardColorByTheme(themeData),
                  //根据card规则实现
                  onTap: () {
                    listVmSub.onItemClick(index, listItem);
                    //getVm().nextByDept(listItem);
                  }));
        });
  }
}

///部门树数据VmSub
class DeptTreeListDataVmSub extends TreeFastBaseListDataVmSub<Dept> {
  final FastVm fastVm;
  final Dept _currentDeptSearch = Dept(parentId: ConstantBase.VALUE_PARENT_ID_DEF);

  Dept get currentSearch => _currentDeptSearch;

  void Function(Dept data)? onSuffixClick;

  DeptTreeListDataVmSub(this.fastVm) {
    //设置刷新方法主体
    setRefresh(() async {
      try {
        //此处的parentId就是创建cancelToken所需的treeId;
        CancelToken cancelToken =
            createCancelTokenByTreeId(_currentDeptSearch.parentId);
        IntensifyEntity<List<Dept>> intensifyEntity =
            await DeptRepository.list(_currentDeptSearch, cancelToken);
        DataWrapper<List<Dept>> dateWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dateWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DataWrapper.createFailed(
            code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      nextByDept(data);
    });
  }

  ///根据部门信息获取下一个节点
  void nextByDept(Dept dept) {
    SlcTreeNav slcTreeNav = SlcTreeNav(dept.deptId, dept.deptName!);
    next(slcTreeNav, notify: true);
  }

  ///下一个节点
  void next(SlcTreeNav treeNav, {bool notify = true}) {
    _currentDeptSearch.parentId = treeNav.id;
    _currentDeptSearch.parentName = treeNav.treeName;
    super.next(treeNav, notify: notify);
    if (notify) {
      fastVm.notifyListeners();
    }
  }

  ///自动上一级
  void autoPrevious() {
    dynamic previousTreeId = getPreviousTreeId();
    if (previousTreeId != null) {
      previous(previousTreeId);
    }
  }

  ///跳转到指定的上一级
  void previous(dynamic treeId) {
    _currentDeptSearch.parentId = treeId;
    super.previous(treeId);
    fastVm.notifyListeners();
  }

  ///可以直接pop吗
  bool canPop() {
    return !canPrevious();
  }
}
