import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/dept_api.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/user_api.dart';
import 'package:dio/dio.dart';

import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/component/tree/vmbox/tree_data_list_vm_vox.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';

class UserListPageVd {
  static Widget getUserListWidget(
      ThemeData themeData,
      UserTreeListDataVmSub listVmSub,
      Widget? Function(dynamic currentItem) buildTrailing) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (context, index) {
          dynamic listItem = listVmSub.dataList[index];
          if (listItem is Dept) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: ListTile(
                    contentPadding:
                        EdgeInsets.only(left: SlcDimens.appDimens16),
                    title: Text(listItem.deptNameVo()),
                    trailing: buildTrailing.call(listItem),
                    visualDensity: VisualDensity.compact,
                    tileColor: SlcColors.getCardColorByTheme(themeData),
                    //根据card规则实现
                    onTap: () {
                      listVmSub.onItemClick(index, listItem);
                      //getVm().nextByDept(listItem);
                    }));
          }
          if (listItem is User) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: ListTile(
                    contentPadding:
                        EdgeInsets.only(left: SlcDimens.appDimens16),
                    //leading: CachedNetworkImage(imageUrl: listItem.avatar ?? ""),
                    title: Text(listItem.nickName ?? "?"),
                    trailing: buildTrailing.call(listItem),
                    visualDensity: VisualDensity.compact,
                    tileColor: SlcColors.getCardColorByTheme(themeData),
                    //根据card规则实现
                    onTap: () {
                      listVmSub.onItemClick(index, listItem);
                      //getVm().nextByDept(listItem);
                    }));
          }
          throw Exception("listItem 类型错误");
        });
  }
}

class UserTreeListDataVmSub extends TreeFastBaseListDataVmSub<dynamic> {
  late FastVm fastVm;

  final Dept _currentDeptSearch =
      Dept(parentId: ConstantBase.VALUE_PARENT_ID_DEF);

  final User _searchUser = User();

  User get searchUser => _searchUser;

  void Function(dynamic data)? onSuffixClick;

  void Function(User data)? onUserClick;

  UserTreeListDataVmSub(this.fastVm) {
    _searchUser.deptId = _currentDeptSearch.parentId;
    setRefresh(() async {
      try {
        //此处的parentId就是创建cancelToken所需的treeId;
        CancelToken cancelToken = createCancelTokenByTreeId(_currentDeptSearch.parentId);
        //获取部门列表
        IntensifyEntity<List<Dept>> deptIntensifyEntity =
            await DeptRepository.list(_currentDeptSearch, cancelToken);
        //填充查询用户的参数
        _searchUser.deptId = _currentDeptSearch.parentId;
        IntensifyEntity<List<User>>? userIntensifyEntity;
        if (deptIntensifyEntity.isSuccess()) {
          //获取该部门下的用户列表
          userIntensifyEntity =
              await UserServiceRepository.queryNoPage(_searchUser, cancelToken);
        }
        //创建动态返回类型并添加部门信息
        IntensifyEntity<List<dynamic>> intensifyEntity =
            IntensifyEntity<List<dynamic>>(
                succeedEntity: deptIntensifyEntity.isSuccess(),
                data: List.of(deptIntensifyEntity.data, growable: true));
        List<dynamic> allList = intensifyEntity.data;
        //合并用户
        if (userIntensifyEntity?.data != null) {
          allList.addAll(userIntensifyEntity!.data!);
        }
        //返回数据结构
        DataWrapper<List<dynamic>> dateWrapper =
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
      if (data is Dept) {
        nextByDept(data);
        return;
      }
      onUserClick?.call(data);
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
