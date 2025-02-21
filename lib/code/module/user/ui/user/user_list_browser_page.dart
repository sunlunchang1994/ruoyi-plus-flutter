import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/user/user_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/user/user_list_page_vd.dart';

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
            appBar: AppBar(
              title: Text(title),
              actions: [
                Builder(builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      UserListPageVd.autoHandlerSearchDrawer(context);
                    },
                  );
                })
              ],
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  getVm().onAddUser();
                }),
            endDrawer: UserListPageVd.getSearchEndDrawer<_UserListBrowserVm>(
                context, themeData, getVm().listVmSub),
            body: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
                child:
                    Consumer<_UserListBrowserVm>(builder: (context, vm, child) {
              return UserListPageVd.getUserListWidget(
                  themeData, getVm().listVmSub);
            })));
      },
    );
  }
}

class _UserListBrowserVm extends AppBaseVm {
  late UserPageDataVmSub listVmSub;

  _UserListBrowserVm() {
    listVmSub = UserPageDataVmSub();
    listVmSub.setItemClick((index, item) {
      pushNamed(UserAddEditPage.routeName,
          arguments: {ConstantUser.KEY_USER: item}).then((result) {
        if (result != null) {
          listVmSub.sendRefreshEvent();
        }
      });
    });
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  ///添加用户事件
  void onAddUser() {
    pushNamed(UserAddEditPage.routeName).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }
}
