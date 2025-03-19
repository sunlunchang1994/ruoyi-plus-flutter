import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';

import '../../../../lib/fast/vd/list_data_vm_sub.dart';
import '../entity/slc_tree_nav.dart';
import 'package:dio/dio.dart';

///
/// @author sunlunchang
class TreeNavVd {
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
                height: 16, color: themeData.colorScheme.primary)),
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
                          Icon(Icons.arrow_right, color: themeData.colorScheme.primary),
                          Text(currentItem.treeName,
                              style: TextStyle(color: themeData.colorScheme.primary))
                        ]);
                      } else {
                        return GestureDetector(
                            onTap: () {
                              onTap?.call(currentItem);
                            },
                            //getVm().previous(currentItem.id)
                            child: Row(children: [
                              Icon(Icons.arrow_right,
                                  color: themeData.slcTidyUpColor
                                      .getTextColorSecondaryByTheme(themeData)),
                              Text(currentItem.treeName,
                                  style: TextStyle(
                                      color: themeData.slcTidyUpColor
                                          .getTextColorSecondaryByTheme(themeData)))
                            ]));
                      }
                    })))
      ],
    );
  }
}

/// 树级列表VmSub
class TreeFastBaseListDataVmSub<T> extends FastBaseListDataVmSub<T> with CancelTokenAssist {
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

  SlcTreeNav? getPreviousTree() {
    if (canPrevious()) {
      return treeNacStacks[treeNacStacks.length - 2];
    }
    return null;
  }

  //从栈堆获取上一个树节点id
  dynamic getPreviousTreeId() {
    return getPreviousTree()?.id;
  }

  SlcTreeNav? getLastTree() {
    if (treeNacStacks.isEmpty) {
      return null;
    }
    return treeNacStacks.last;
  }

  //获取最后一个节点id
  dynamic getLastTreeId() {
    return getLastTree()?.id;
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
    onFillListFormTarget(targetTreeId);
  }

  /// 根据上一级填充数据
  void onFillListFormTarget(dynamic targetTreeId){
    //设置当前的数据
    List<T>? treStackData = treeStacksDataMap[targetTreeId] ?? List.empty(growable: true);
    onSucceed(treStackData);
  }

  //是否可以返回
  bool canPrevious() {
    return treeNacStacks.isNotEmpty && treeNacStacks.length > 1;
  }

  //根据treeId创建CancelToken
  CancelToken createCancelTokenByTreeId(dynamic treeId) {
    execCancelToken(treeId);
    return getOrCreateCancelToken(treeId);
  }

  //执行取消
  void execCancelToken(dynamic treeId, {bool remove = true}) {
    //此处获取CancelToken使用remove，意味着取消后就可以甩掉了，没用
    cancelTokenByKey(treeId, reason: "pop", remove: remove);
  }

  @override
  void onSucceed(List<T> dataList) {
    super.onSucceed(dataList);
    SlcTreeNav slcTreeNav = treeNacStacks.last;
    treeStacksDataMap[slcTreeNav.id] = dataList;
  }

  //获取pop回调
  PopInvokedWithResultCallback<T> getPopInvokedWithTree(
      {bool Function(bool didPop, T? result)? handlerFirst, Function(bool didPop, T? result)? handlerLast}) {
    return (didPop, result) {
      //处理过了且拦截了
      if(handlerFirst?.call(didPop,result)??false){
        return;
      }
      if (didPop) {
        return;
      }
      if (canPrevious()) {
        previousAuto();
        return;
      }
      handlerLast?.call(didPop,result);
    };
  }
}
