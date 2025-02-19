import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/list_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/dept_api.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';

///
/// 部门浏览列表
///
class DeptListBrowserPage extends AppBaseStatelessWidget<_DeptListBrowserVm> {
  static const String routeName = '/system/dept';

  final String title;

  DeptListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _DeptListBrowserVm(),
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
                //图标滚动使用固定大小来解决
                floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      getVm().onAddDept();
                    }),
                body: Column(children: [
                  Selector<_DeptListBrowserVm, List<SlcTreeNav>>(
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
                              Consumer<_DeptListBrowserVm>(
                                  builder: (context, vm, child) {
                    return DeptListPageWidget.getDataListWidget(
                        themeData, getVm().listVmSub, (currentItem) {
                      return Ink(
                          child: InkWell(
                              child: Padding(
                                  padding:
                                      EdgeInsets.all(SlcDimens.appDimens12),
                                  child: const Icon(Icons.chevron_right,
                                      size: 24)),
                              onTap: () {
                                //点击更多事件
                                getVm()
                                    .listVmSub
                                    .onSuffixClick
                                    ?.call(currentItem);
                              }));
                    });
                  })))
                ])));
      },
    );
  }
}

//点击列表直接切换数据 存储上级数据列表 返回时直接获取上级加载
class _DeptListBrowserVm extends AppBaseVm {
  late DeptTreeListDataVmSub listVmSub;

  _DeptListBrowserVm() {
    listVmSub = DeptTreeListDataVmSub(this);
  }

  void initVm() {
    registerVmSub(listVmSub);
    listVmSub.onSuffixClick = (Dept data) {
      pushNamed(DeptAddEditPage.routeName,
          arguments: {ConstantUser.KEY_DEPT: data}).then((value) {
        if (value != null) {
          listVmSub.sendRefreshEvent();
        }
      });
    };
    SlcTreeNav slcTreeNav = SlcTreeNav(
        ConstantBase.VALUE_PARENT_ID_DEF, S.current.user_label_top_dept);
    listVmSub.next(slcTreeNav, notify: false);
  }

  ///添加部门事件
  void onAddDept() {
    //此处刚好把_currentSearch作为参数进行赋值传输
    pushNamed(DeptAddEditPage.routeName, arguments: {
      ConstantUser.KEY_PARENT_DEPT: Dept(
          deptId: listVmSub.currentSearch.parentId,
          deptName: listVmSub.currentSearch.parentName)
    }).then((value) {
      if (value != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }
}
