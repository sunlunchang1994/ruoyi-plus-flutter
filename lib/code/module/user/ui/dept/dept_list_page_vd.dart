import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/object_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';

import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../base/vm/global_vm.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/component/tree/vd/tree_data_list_vd.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import '../../entity/dept_tree.dart';
import '../../repository/remote/dept_api.dart';
import 'package:dio/dio.dart';

import '../../repository/remote/user_api.dart';

class DeptListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, DeptTreeListDataVmSub listVmSub,
      Widget? Function(DeptTree currentItem) buildTrailing) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          DeptTree listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, index, listItem, buildTrailing);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
    ThemeData themeData,
    ListenerItemSelect<dynamic> listenerItemSelect,
    int index,
    DeptTree listItem,
    Widget? Function(DeptTree currentItem) buildTrailing,
  ) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.label),
        trailing: WidgetUtils.getAnimCrossFade(
            Checkbox(
              value: listItem.isBoxChecked(),
              onChanged: (value) {
                listItem.boxChecked = value;
                listenerItemSelect.onItemSelect(index, listItem, value);
              },
            ),
            buildTrailing.call(listItem) ?? ThemeUtil.getBoxStandard(),
            showOne: listenerItemSelect.selectModelIsRun),
        visualDensity: VisualDensity.compact,
        //tileColor: SlcColors.getCardColorByTheme(themeData),
        onTap: () {
          listenerItemSelect.onItemClick(index, listItem);
        },
        onLongPress: () {
          GlobalVm().userShareVm.execPermiEvery(
              ["system:dept:remove"], () => listenerItemSelect.onItemLongClick(index, listItem));
        });
  }
}

///部门树数据VmSub
class DeptTreeListDataVmSub extends TreeFastBaseListDataVmSub<DeptTree> {
  final FastVm fastVm;
  final Dept _currentSearch = Dept(parentId: ConstantBase.VALUE_PARENT_ID_DEF);

  List<DeptTree>? _allTreeList;

  List<DeptTree>? get allTreeList => _allTreeList;

  void Function(DeptTree data)? onSuffixClick;

  DeptTreeListDataVmSub(this.fastVm) {
    //设置刷新方法主体
    setRefresh(() async {
      //大致逻辑：
      //1、首次进来获取网络数据
      //2、后续通过点击当前列表，根据当前列表和点击的item获取点击的item的子节点
      //查找上一个树节点id
      SlcTreeNav? previousTree = getPreviousTree();
      int? previousTreeId = previousTree?.id;
      //上一个树节点id不是空时
      if (previousTreeId != null) {
        //获取目标栈堆的数据列表
        List<DeptTree>? previousTreeStacksData = treeStacksDataMap[previousTreeId];
        if (previousTreeStacksData != null) {
          //数据不为空时通过lastTreeId查找目标数据，lastTreeId就是当前点击的item的id;

          int? lastTreeId = getLastTreeId();

          List<DeptTree>? resultList = _allTreeList?.where((item) {
            return lastTreeId == item.parentId;
          }).toList();
          //获取目标数据的子节点
          DataWrapper<List<DeptTree>> dataWrapper =
              DataWrapper.createSuccess(resultList ?? List.empty());
          return dataWrapper;
        }
      }
      try {
        //此处的parentId就是创建cancelToken所需的treeId;
        CancelToken cancelToken = createCancelTokenByTreeId(_currentSearch.parentId);
        IntensifyEntity<List<DeptTree>> intensifyEntity = await UserServiceRepository.deptTree(
                _currentSearch, cancelToken,
                removeParentId: true)
            .asStream()
            .single;
        //获取到数据之后直接配置默认的顶级数据
        treeStacksDataMap[ConstantBase.VALUE_PARENT_ID_DEF] =
            intensifyEntity.data ?? List.empty(growable: true);
        //平铺数据
        _allTreeList = List.empty(growable: true);
        DeptTree.deptTree2Tile(intensifyEntity.data, _allTreeList!);
        //构建结果
        DataWrapper<List<DeptTree>> dataWrapper =
            DataTransformUtils.entity2LDWrapperShell(intensifyEntity,
                data: () {
                  List<DeptTree>? treeList = _allTreeList?.where((item) {
                    return getLastTreeId() == item.parentId;
                  }).toList();
                  //此处如果是空且为默认的父ID，则设置为原始数据
                  if (ObjectUtil.isEmpty(treeList) &&
                      getLastTreeId() == ConstantBase.VALUE_PARENT_ID_DEF) {
                    treeList = treeStacksDataMap[ConstantBase.VALUE_PARENT_ID_DEF];
                  }
                  return treeList;
                }.call());
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      nextByDept(data);
    });
  }

  ///根据部门信息获取下一个节点
  void nextByDept(DeptTree dept) {
    SlcTreeNav slcTreeNav = SlcTreeNav(dept.id, dept.label);
    next(slcTreeNav, notify: true);
  }

  ///下一个节点
  void next(SlcTreeNav treeNav, {bool notify = true}) {
    _currentSearch.parentId = treeNav.id;
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
    super.previous(treeId);
    SlcTreeNav? slcTreeNav = getLastTree();
    _currentSearch.parentId = slcTreeNav?.id ?? ConstantBase.VALUE_PARENT_ID_DEF;
    fastVm.notifyListeners();
  }

  @override
  void onFillListFormTarget(targetTreeId) {
    if (targetTreeId == ConstantBase.VALUE_PARENT_ID_DEF) {
      super.onFillListFormTarget(targetTreeId);
      return;
    }
    List<DeptTree> resultList = _allTreeList?.where((item) {
          return targetTreeId == item.parentId;
        }).toList() ??
        List.empty(growable: true);
    onSucceed(resultList);
    //super.onFillListFormPrevious(targetTreeId);
  }

  @override
  void sendRefreshEvent({CallRefreshParams? callRefreshParams}) {
    super.sendRefreshEvent(
        callRefreshParams:
            callRefreshParams ?? CallRefreshParams(overOffset: 0, duration: Duration.zero));
  }

  ///刷新并清空树栈堆数据，主要用于当前列表进行增删改后使用
  void refreshAndClearTreeStacks() {
    treeStacksDataMap.clear();
    sendRefreshEvent();
  }
}
