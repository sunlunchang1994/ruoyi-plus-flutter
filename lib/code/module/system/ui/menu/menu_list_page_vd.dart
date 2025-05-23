import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_menu.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/component/tree/vd/tree_data_list_vd.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import 'package:dio/dio.dart';

import '../../repository/remote/menu_api.dart';

///@author slc
///菜单树列表
class MenuListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, MenuListDataVmSub listVmSub,
      Widget Function(SysMenu currentItem) buildTrailing) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysMenu listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, buildTrailing, index, listItem);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
    ThemeData themeData,
    ListenerItemSelect<dynamic> listenerItemSelect,
    Widget? Function(SysMenu currentItem) buildTrailing,
    int index,
    SysMenu listItem,
  ) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.menuName!),
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
          listenerItemSelect.onItemLongClick(index, listItem);
        });
  }
}

///菜单树数据VmSub
class MenuListDataVmSub extends TreeFastBaseListDataVmSub<SysMenu> {
  final FastVm fastVm;

  final SysMenu _currentSearch = SysMenu();

  SysMenu? currentClickItem;

  List<SysMenu>? _allTreeList;

  List<SysMenu>? get allTreeList => _allTreeList;

  void Function(SysMenu data)? onSuffixClick;

  MenuListDataVmSub(this.fastVm) {
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
        List<SysMenu>? previousTreeStacksData = treeStacksDataMap[previousTreeId];
        if (previousTreeStacksData != null) {
          //数据不为空时通过lastTreeId查找目标数据，lastTreeId就是当前点击的item的id;

          int? lastTreeId = getLastTreeId();

          List<SysMenu>? resultList = _allTreeList?.where((item) {
            return lastTreeId == item.parentId;
          }).toList();
          //获取目标数据的子节点
          DataWrapper<List<SysMenu>> dataWrapper =
              DataWrapper.createSuccess(resultList ?? List.empty());
          return dataWrapper;
        }
      }
      try {
        //此处的parentId就是创建cancelToken所需的treeId;
        CancelToken cancelToken = createCancelTokenByTreeId(_currentSearch.parentId);
        IntensifyEntity<List<SysMenu>> intensifyEntity =
            await MenuRepository.list(_currentSearch, cancelToken).asStream().single;
        _allTreeList = intensifyEntity.data;

        DataWrapper<List<SysMenu>> dataWrapper =
            DataTransformUtils.entity2LDWrapperShell(intensifyEntity,
                data: _allTreeList?.where((item) {
                  return getLastTreeId() == item.parentId;
                }).toList());
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      //当菜单类型为目录或菜单时可跳转到下一级
      if (LocalDictLib.KEY_MENU_TYPE_MULU == data.menuType ||
          LocalDictLib.KEY_MENU_TYPE_CAIDAN == data.menuType) {
        currentClickItem = data;
        nextByTree(data);
      } else {
        AppToastUtil.showToast(msg: S.current.sys_label_menu_down_donot);
      }
    });
  }

  ///根据部门信息获取下一个节点
  void nextByTree(SysMenu treeItem) {
    SlcTreeNav slcTreeNav = SlcTreeNav(treeItem.menuId, treeItem.menuName!);
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
    List<SysMenu> resultList = _allTreeList?.where((item) {
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
