import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_page_vd.dart';

import '../../../../../generated/l10n.dart';

///
/// @author slc
/// 角色列表
class RoleListBrowserPage extends AppBaseStatelessWidget<_RoleListBrowserVm> {
  static const String routeName = '/system/role';
  final String title;

  RoleListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _RoleListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return Scaffold(
              appBar: AppBar(title: Text(title), actions: [
                Builder(builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      WidgetUtils.autoHandlerSearchDrawer(context);
                    },
                  );
                })
              ]),
              endDrawer: RoleListPageVd.getSearchEndDrawer<_RoleListBrowserVm>(
                  context, themeData, getVm().listVmSub),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    getVm().onAddRole();
                  }),
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_RoleListBrowserVm, int>(
                      builder: (context, vm, child) {
                    return RoleListPageVd.getUserListWidget(
                        themeData, getVm().listVmSub);
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }
}

class _RoleListBrowserVm extends AppBaseVm {
  late RolePageDataVmSub listVmSub;

  _RoleListBrowserVm();

  void initVm() {
    listVmSub = RolePageDataVmSub();
    registerVmSub(listVmSub);
    listVmSub.setItemClick((index, role) {
      if (role.roleId == ConstantUser.VALUE_ROLE_SUPER_ADMIN) {
        //是超管则不允许做更改
        AppToastBridge.showToast(msg: S.current.user_toast_menu_super_edit_refuse);
        return;
      }
      pushNamed(RoleAddEditPage.routeName,
          arguments: {ConstantUser.KEY_ROLE: role}).then((result) {
        if (result != null) {
          listVmSub.sendRefreshEvent();
        }
      });
    });
  }

  ///添加角色事件
  void onAddRole() {
    pushNamed(RoleAddEditPage.routeName).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }
}
