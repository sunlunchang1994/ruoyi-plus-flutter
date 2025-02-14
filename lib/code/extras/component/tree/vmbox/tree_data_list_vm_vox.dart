import '../../../../base/ui/vd/list_data_vm_sub.dart';
import '../entity/slc_tree_nav.dart';

class TreeFastBaseListDataVmSub<T> extends FastBaseListDataVmSub<T> {
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

  dynamic getPreviousTreeId() {
    if (canPrevious()) {
      return treeNacStacks[treeNacStacks.length - 2].id;
    }
    return null;
  }

  //自动上一级
  void previousAuto() {
    dynamic previousTreeId = getPreviousTreeId();
    if (previousTreeId != null) {
      previous(previousTreeId);
    }
  }

  void previous(dynamic treeId) {
    //当arriveTargetTreeId为true时，后续节点则添加到移除列表内
    bool arriveTargetTreeId = false;
    List<SlcTreeNav> awaitRemoveNavList = List.empty(growable: true);
    //遍历得到需要移除的导航列表
    for (var item in treeNacStacks) {
      if (arriveTargetTreeId) {
        awaitRemoveNavList.add(item);
        continue;
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

  //是否可以返回
  bool canPrevious() {
    return treeNacStacks.isNotEmpty && treeNacStacks.length > 1;
  }

  @override
  void onSucceed(List<T> dataList) {
    super.onSucceed(dataList);
    SlcTreeNav slcTreeNav = treeNacStacks.last;
    treeStacksDataMap[slcTreeNav.id] = dataList;
  }
}
