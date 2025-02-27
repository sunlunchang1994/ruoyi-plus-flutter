import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_menu_tree.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_menu_vo.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/repository/local/local_dict_lib.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../res/styles.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/component/tree/vmbox/tree_data_list_vm_vox.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import 'package:dio/dio.dart';

import '../../repository/remote/menu_api.dart';

///@author slc
///菜单树列表
class MenuTreePageWidget {
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
      MenuTreeListDataVmSub listVmSub,
      Widget Function(SysMenuTree currentItem) buildTrailing) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysMenuTree listItem = listVmSub.dataList[index];
          return getDataListItem(
              themeData, listVmSub, buildTrailing, index, listItem);
        },
        separatorBuilder: (context, index) {
          return AppStyles.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
    ThemeData themeData,
    ListenerItemClick<dynamic> listenerItemClick,
    Widget? Function(SysMenuTree currentItem) buildTrailing,
    int index,
    SysMenuTree listItem,
  ) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.label),
        trailing: buildTrailing.call(listItem),
        visualDensity: VisualDensity.compact,
        //根据card规则实现
        onTap: () {
          listenerItemClick.onItemClick(index, listItem);
          //getVm().nextByDept(listItem);
        });
  }
}

///菜单树数据VmSub
class MenuTreeListDataVmSub extends TreeFastBaseListDataVmSub<SysMenuTree> {
  final FastVm fastVm;

  final int? roleId;

  final List<int>? checkedIds;

  final SysMenuVo _currentDeptSearch = SysMenuVo();

  SysMenuVo get currentSearch => _currentDeptSearch;

  SysMenuTree? currentClickItem;

  List<SysMenuTree>? _allTreeList;

  List<SysMenuTree>? get allTreeList => _allTreeList;

  void Function(SysMenuTree data)? onSuffixClick;

  MenuTreeListDataVmSub(this.fastVm, {this.roleId, this.checkedIds}) {
    //设置刷新方法主体
    setRefresh(() async {
      //大致逻辑：
      //1、首次进来获取网络数据
      //2、后续通过点击当前列表，根据当前列表和点击的item获取点击的item的子节点
      //查找上一个树节点id
      int? previousTreeId = getPreviousTreeId();
      //上一个树节点id不是空时
      if (previousTreeId != null) {
        //获取目标战队的数据列表
        List<SysMenuTree>? previousTreeStacksData =
            treeStacksDataMap[previousTreeId];
        if (previousTreeStacksData != null) {
          //数据不为空时通过lastTreeId查找目标数据，lastTreeId就是当前点击的item的id;

          int? lastTreeId = getLastTreeId();

          SysMenuTree menuTreeByTreeId =
              previousTreeStacksData.firstWhere((itemData) {
            return itemData.id == lastTreeId;
          });
          //获取目标数据的子节点
          DataWrapper<List<SysMenuTree>> dateWrapper =
              DataWrapper.createSuccess(
                  menuTreeByTreeId.children ?? List.empty());
          return dateWrapper;
        }
      }
      try {
        //此处的parentId就是创建cancelToken所需的treeId;
        CancelToken cancelToken =
            createCancelTokenByTreeId(_currentDeptSearch.parentId);
        IntensifyEntity<List<SysMenuTree>> intensifyEntity;
        //定义填充CheckedIds的Map
        fillCheckedIdsMap(IntensifyEntity<List<SysMenuTree>> event) {
          //填充传输过来的数据
          SelectUtils.fillSelect(event.data, checkedIds,
              predicate: (src, beCompared) {
                return src!.id == beCompared;
              }, maintain: false, penetrate: true);
          return event;
        }
        if (roleId != null) {
          intensifyEntity =
              await MenuRepository.roleMenuTreeselect(roleId, cancelToken)
                  .asStream()
                  .map(fillCheckedIdsMap).single;
        } else {
          intensifyEntity =
              await MenuRepository.treeselect(_currentDeptSearch, cancelToken)
                  .asStream()
                  .map(fillCheckedIdsMap).single;
        }
        DataWrapper<List<SysMenuTree>> dateWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        _allTreeList = dateWrapper.data;
        return dateWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DataWrapper.createFailed(
            code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      //当菜单类型为目录或菜单时可跳转到下一级
      if (LocalDictLib.KEY_MENU_TYPE_MULU == data.menuType ||
          LocalDictLib.KEY_MENU_TYPE_CAIDAN == data.menuType) {
        currentClickItem = data;
        nextByDept(data);
      } else {
        AppToastBridge.showToast(msg: S.current.user_label_menu_down_donot);
      }
    });
  }

  ///根据部门信息获取下一个节点
  void nextByDept(SysMenuTree dept) {
    SlcTreeNav slcTreeNav = SlcTreeNav(dept.id, dept.label);
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

  @override
  void sendRefreshEvent({CallRefreshParams? callRefreshParams}) {
    super.sendRefreshEvent(
        callRefreshParams: callRefreshParams ??
            CallRefreshParams(overOffset: 0, duration: Duration.zero));
  }
}
