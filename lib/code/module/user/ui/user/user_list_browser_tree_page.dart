import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/list_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_list_page_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/user/user_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';

///
/// 用户浏览列表：通讯录的形势
///
class UserListBrowserPage2 extends AppBaseStatelessWidget<_UserListBrowserVm> {
  static const String routeName = '/system/user2';

  final String title;

  UserListBrowserPage2(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _UserListBrowserVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm();
        return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }
              if (getVm().listVmSub.canPop()) {
                Navigator.pop(context);
                return;
              }
              getVm().listVmSub.autoPrevious();
            },
            child: Scaffold(
                appBar: AppBar(title: Text(title)),
                floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      getVm().onAddUser();
                    }),
                body: Column(children: [
                  Selector<_UserListBrowserVm, List<SlcTreeNav>>(
                      builder: (context, value, child) {
                    return DeptListPageWidget.getNavWidget(themeData, value,
                        (currentItem) {
                      getVm().listVmSub.previous(currentItem.id);
                    });
                  }, selector: (context, vm) {
                    return vm.listVmSub.treeNacStacks;
                  }, shouldRebuild: (oldVal, newVal) {
                    return true;
                  }),
                  Expanded(
                      child: ListDataVd(getVm().listVmSub, getVm(),
                          refreshOnStart: true, child:
                              Consumer<_UserListBrowserVm>(
                                  builder: (context, vm, child) {
                    return UserListPageVd.getDeptUserListWidget(
                        themeData, getVm().listVmSub, (currentItem) {
                      if (currentItem is Dept) {
                        //此处部门只需要更多图表，不需要事件
                        return Padding(
                            padding:
                            EdgeInsets.all(SlcDimens.appDimens12),
                            child: const Icon(Icons.chevron_right,
                                size: 24));
                      }
                      return null;
                    });
                  })))
                ])));
      },
    );
  }
}

//点击列表直接切换数据 存储上级数据列表 返回时直接获取上级加载
class _UserListBrowserVm extends AppBaseVm {
  late UserTreeListDataVmSub listVmSub;

  _UserListBrowserVm() {
    listVmSub = UserTreeListDataVmSub(this);
  }

  void initVm() {
    registerVmSub(listVmSub);
    listVmSub.onSuffixClick = (dynamic data) {
      //选择更多按钮事件
    };
    SlcTreeNav slcTreeNav = SlcTreeNav(
        ConstantBase.VALUE_PARENT_ID_DEF, S.current.user_label_top_dept);
    listVmSub.next(slcTreeNav, notify: false);
  }

  ///添加用户事件
  void onAddUser() {}
}
