import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../lib/fast/vd/list_data_vm_sub.dart';
import '../entity/slc_tree_nav.dart';
import 'package:dio/dio.dart';

///
/// @author sunlunchang
class TreeNavVd{

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
}

/// 树级列表VmSub
class TreeFastBaseListDataVmSub<T> extends FastBaseListDataVmSub<T> {
  //部门栈堆数据
  final Map<dynamic, List<T>> treeStacksDataMap = Map.identity();

  //取消token栈堆数据
  final Map<dynamic, CancelToken> treeStacksCancelTokenMap = Map.identity();

  //部门栈堆
  final List<SlcTreeNav> treeNacStacks = List.empty(growable: true);

  void next(SlcTreeNav treeNav, {bool notify = false}) {
    treeNacStacks.add(treeNav);
    if (notify) {
      sendRefreshEvent();
    }
  }

  //从栈堆获取上一个树节点id
  dynamic getPreviousTreeId() {
    if (canPrevious()) {
      return treeNacStacks[treeNacStacks.length - 2].id;
    }
    return null;
  }

  //获取最后一个节点id
  dynamic getLastTreeId() {
    if (treeNacStacks.isEmpty) {
      return null;
    }
    return treeNacStacks.last.id;
  }

  //自动上一级
  void previousAuto() {
    dynamic previousTreeId = getPreviousTreeId();
    if (previousTreeId != null) {
      previous(previousTreeId);
    }
  }

  void previous(dynamic targetTreeId) {
    //返回时取消最后一个token TODO 此处案例说是要取消targetTreeId到最后一个之间所有的CancelToken的，暂时先这么写
    execCancelToken(getLastTreeId());
    //当arriveTargetTreeId为true时，后续节点则添加到移除列表内
    bool arriveTargetTreeId = false;
    List<SlcTreeNav> awaitRemoveNavList = List.empty(growable: true);
    //遍历得到需要移除的导航列表
    for (var item in treeNacStacks) {
      if (arriveTargetTreeId) {
        awaitRemoveNavList.add(item);
        continue;
      }
      if (item.id == targetTreeId) {
        arriveTargetTreeId = true;
      }
    }
    //移除需要移除的
    for (var item in awaitRemoveNavList) {
      treeNacStacks.remove(item);
      treeStacksDataMap.remove(item.id);
    }
    //设置当前的数据
    List<T>? treStackData =
        treeStacksDataMap[targetTreeId] ?? List.empty(growable: true);
    onSucceed(treStackData);
  }

  //是否可以返回
  bool canPrevious() {
    return treeNacStacks.isNotEmpty && treeNacStacks.length > 1;
  }

  //根据treeId创建CancelToken
  CancelToken createCancelTokenByTreeId(dynamic treeId) {
    CancelToken cancelToken = CancelToken();
    execCancelToken(treeId);
    treeStacksCancelTokenMap[treeId] = cancelToken;
    return cancelToken;
  }

  //执行取消
  void execCancelToken(dynamic treeId, {bool remove = true}) {
    //此处获取CancelToken使用remove，意味着取消后就可以甩掉了，没用
    CancelToken? oldCancelToken;
    if (remove) {
      oldCancelToken = treeStacksCancelTokenMap.remove(treeId);
    } else {
      oldCancelToken = treeStacksCancelTokenMap[treeId];
    }
    if (oldCancelToken != null && !oldCancelToken.isCancelled) {
      oldCancelToken.cancel("pop");
    }
  }

  @override
  void onSucceed(List<T> dataList) {
    super.onSucceed(dataList);
    SlcTreeNav slcTreeNav = treeNacStacks.last;
    treeStacksDataMap[slcTreeNav.id] = dataList;
  }

  @override
  void onCleared() {
    treeStacksCancelTokenMap.forEach((key, value) {
      execCancelToken(key, remove: false);
    });
    super.onCleared();
  }
}
