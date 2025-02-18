import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/list_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/dept_api.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_list_page_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/user/user_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/bizapi/user/entity/user.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/component/tree/vmbox/tree_data_list_vm_vox.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';

///
/// 用户浏览列表
///
class UserListBrowserPage extends AppBaseStatelessWidget<_UserListBrowserVm> {
  static const String routeName = '/system/user';

  final String title;

  UserListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _UserListBrowserVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm();
        return Scaffold(
            appBar: AppBar(title: Text(title)),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  getVm().onAddUser();
                }),
            body: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
                child: Consumer<_UserListBrowserVm>(builder: (context, vm, child) {
              return ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  itemCount: getVm().listVmSub.dataList.length,
                  itemBuilder: (context, index) {
                    User listItem = getVm().listVmSub.dataList[index];
                    return UserListPageVd.getUserListItem(
                        themeData, getVm().listVmSub, (currentItem) {
                          //后缀视图
                          return null;
                    }, index, listItem);
                  });
            })));
      },
    );
  }
}

//点击列表直接切换数据 存储上级数据列表 返回时直接获取上级加载
class _UserListBrowserVm extends AppBaseVm {
  late UserPageDataVmSub listVmSub;

  _UserListBrowserVm() {
    listVmSub = UserPageDataVmSub();
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  ///添加用户事件
  void onAddUser() {}
}
