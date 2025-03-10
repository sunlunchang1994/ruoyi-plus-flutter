import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/list_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/user/user_list_page_vd.dart';

import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/bizapi/user/entity/user.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/list_data_vd.dart';
import '../../repository/remote/user_api.dart';

///
/// 用户选择列表：仅展示部门下的
///
class UserListSelectByDeptPage extends AppBaseStatelessWidget<_UserListSingleSelectVm> {
  static const String routeName = '/system/user/select_by_dept';

  final String title;
  final int deptId;

  UserListSelectByDeptPage(this.title, this.deptId, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _UserListSingleSelectVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm(deptId);
        return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: ListDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
                child: Consumer<_UserListSingleSelectVm>(builder: (context, vm, child) {
              return UserListPageVd.getUserListWidget(themeData, getVm().listVmSub);
            })));
      },
    );
  }
}

class _UserListSingleSelectVm extends AppBaseVm {
  late _UserListDataVmSub listVmSub;

  _UserListSingleSelectVm() {
    listVmSub = _UserListDataVmSub();
    listVmSub.setItemClick((index, itemData) {
      finish(result: itemData);
    });
  }

  void initVm(int deptId) {
    listVmSub.deptId = deptId;
    registerVmSub(listVmSub);
  }
}

///用户加载列表
class _UserListDataVmSub extends FastBaseListDataVmSub<User> with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  late int deptId;

  _UserListDataVmSub() {
    setRefresh(() async {
      try {
        IntensifyEntity<List<User>> result =
            await UserServiceRepository.userListByDept(deptId, defCancelToken);
        //返回数据结构
        DataWrapper<List<User>> dataWrapper = DataTransformUtils.entity2LDWrapper(result);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
  }
}
