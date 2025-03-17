import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/config/constant_user_api.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/module/user/config/constant_user.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/user/user_add_edit_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/user/user_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../feature/bizapi/user/entity/user.dart';
import '../../../../lib/fast/utils/bar_utils.dart';
import '../../../../lib/fast/utils/widget_utils.dart';

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
        return PopScope(
            canPop: false,
            onPopInvokedWithResult: (canPop, result) {
              if (canPop) {
                return;
              }
              if (!getVm().listVmSub.selectModelIsRun) {
                Navigator.pop(context);
                return;
              }
              getVm().listVmSub.selectModelIsRun = false;
            },
            child: Scaffold(
                appBar: AppBar(
                  leading: NqSelector<_UserListBrowserVm, bool>(builder: (context, value, child) {
                    return WidgetUtils.getAnimCrossFade(const CloseButton(), const BackButton(),
                        showOne: value);
                  }, selector: (context, vm) {
                    return vm.listVmSub.selectModelIsRun;
                  }),
                  title: Text(title),
                  actions: [
                    NqSelector<_UserListBrowserVm, bool>(builder: (context, value, child) {
                      return AnimatedSize(
                          duration: WidgetUtils.adminDurationNormal,
                          child: Row(
                            children: [
                              ...() {
                                List<Widget> actions = [];
                                if (value) {
                                  actions.addAll(WidgetUtils.getDeleteFamilyAction(onDelete: () {
                                    getVm().listVmSub.onDelete(confirmHandler: (nickNameList) {
                                      return FastDialogUtils.showDelConfirmDialog(context,
                                          contentText: TextUtil.format(
                                              S.current.user_label_data_del_prompt,
                                              [nickNameList.join(TextUtil.COMMA)]));
                                    });
                                  }, onSelectAll: () {
                                    getVm().listVmSub.onSelectAll(true);
                                  }, onDeselect: () {
                                    getVm().listVmSub.onSelectAll(false);
                                  }));
                                } else {
                                  actions.add(Builder(builder: (context) {
                                    return IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: () {
                                        WidgetUtils.autoHandlerSearchDrawer(context);
                                      },
                                    );
                                  }));
                                }
                                return actions;
                              }.call()
                            ],
                          ));
                    }, selector: (context, vm) {
                      return vm.listVmSub.selectModelIsRun;
                    }),
                  ],
                ),
                floatingActionButton:
                    NqSelector<_UserListBrowserVm, bool>(builder: (context, value, child) {
                  return WidgetUtils.getAnimVisibility(
                      !value,
                      FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            getVm().onAddUser();
                          }));
                }, selector: (context, vm) {
                  return vm.listVmSub.selectModelIsRun;
                }),
                endDrawer: UserListPageVd.getSearchEndDrawer<_UserListBrowserVm>(
                    context, themeData, getVm().listVmSub),
                body: PageDataVd(getVm().listVmSub, getVm(),
                    refreshOnStart: true,
                    child: NqSelector<_UserListBrowserVm, int>(builder: (context, vm, child) {
                      return UserListPageVd.getUserListWidget(
                        themeData,
                        getVm().listVmSub,
                      );
                    }, selector: (context, vm) {
                      return vm.listVmSub.shouldSetState.version;
                    }))));
      },
    );
  }
}

class _UserListBrowserVm extends AppBaseVm {
  late UserPageDataVmSub listVmSub;

  _UserListBrowserVm() {
    listVmSub = UserPageDataVmSub();
    listVmSub.setItemClick((index, item) {
      if (item.userId == ConstantUserApi.VALUE_SUPER_ADMIN_ID) {
        AppToastUtil.showToast(msg: S.current.user_toast_user_super_edit_refuse);
        return;
      }
      pushNamed(UserAddEditPage.routeName, arguments: {ConstantUser.KEY_USER: item}).then((result) {
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
