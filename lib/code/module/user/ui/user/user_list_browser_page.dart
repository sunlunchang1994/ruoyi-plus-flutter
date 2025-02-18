import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/input_decoration_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/user/user_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../feature/bizapi/user/entity/user.dart';
import '../../../../feature/component/dict/repository/local/local_dict_lib.dart';
import '../../../../feature/component/dict/utils/dict_ui_utils.dart';
import '../../../../lib/fast/widget/form/fast_form_builder_text_field.dart';

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
                      _autoHandlerDrawer(context);
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
            endDrawer: getEndDrawer(themeData),
            body: PageDataVd(getVm().listVmSub, getVm(), refreshOnStart: true,
                child: Consumer<_UserListBrowserVm>(builder: (context, vm, child) {
              return ListView.builder(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  itemCount: getVm().listVmSub.dataList.length,
                  itemBuilder: (context, index) {
                    User listItem = getVm().listVmSub.dataList[index];
                    return UserListPageVd.getUserListItem(themeData, getVm().listVmSub, (currentItem) {
                      //后缀视图
                      return null;
                    }, index, listItem);
                  });
            })));
      },
    );
  }

  //侧滑栏视图
  Widget getEndDrawer(ThemeData themeData) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: FormBuilder(
            key: getVm().listVmSub.formOperate.formKey,
            child: Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    height: themeData.appBarTheme.toolbarHeight,
                    child: Text(S.current.user_label_search_user,
                        style: SlcStyles.getTitleTextStyle(themeData))),
                SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                Selector<_UserListBrowserVm, String?>(builder: (context, value, child) {
                  //getVm().listVmSub.formOperate.patchValue("deptName", value);
                  return MyFormBuilderSelect(
                      name: "deptName",
                      initialValue: value,
                      onTap: () => getVm().listVmSub.onSelectDept(),
                      decoration: MySelectDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: S.current.user_label_user_owner_dept,
                        hintText: S.current.app_label_please_choose,
                        border: const UnderlineInputBorder(),
                        suffixIcon: InputDecorationUtils.autoClearSuffixBySelectVal(value, onPressed: () {
                          getVm().listVmSub.setSelectDept(null);
                        }),
                      ),
                      textInputAction: TextInputAction.next);
                }, selector: (context, vm) {
                  return vm.listVmSub.searchUser.deptName;
                }, shouldRebuild: (oldVal, newVal) {
                  return oldVal != newVal;
                }),
                SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                Selector<_UserListBrowserVm, String?>(builder: (context, value, child) {
                  return FormBuilderTextField(
                      name: "userName",
                      initialValue: value,
                      decoration: MyInputDecoration(
                          contentPadding: EdgeInsets.zero,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.user_label_user_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: InputDecorationUtils.autoClearSuffixByInputVal(value, onPressed: () {
                            //getVm().listVmSub.searchUser.userName = null;
                            getVm().listVmSub.formOperate.clearField("userName");
                          })),
                      onChanged: (value) {
                        getVm().listVmSub.searchUser.userName = value;
                        getVm().notifyListeners();
                      },
                      textInputAction: TextInputAction.next);
                }, selector: (context, vm) {
                  return vm.listVmSub.searchUser.userName;
                }, shouldRebuild: (oldVal, newVal) {
                  return oldVal != newVal;
                }),
                SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                Selector<_UserListBrowserVm, String?>(builder: (context, value, child) {
                  return FormBuilderTextField(
                      name: "phonenumber",
                      initialValue: value,
                      decoration: MyInputDecoration(
                          contentPadding: EdgeInsets.zero,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.user_label_phone_number,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: InputDecorationUtils.autoClearSuffixByInputVal(value, onPressed: () {
                            //getVm().listVmSub.searchUser.userName = null;
                            getVm().listVmSub.formOperate.clearField("phonenumber");
                          })),
                      onChanged: (value) {
                        getVm().listVmSub.searchUser.phonenumber = value;
                        getVm().notifyListeners();
                      },
                      textInputAction: TextInputAction.next);
                }, selector: (context, vm) {
                  return vm.listVmSub.searchUser.phonenumber;
                }, shouldRebuild: (oldVal, newVal) {
                  return oldVal != newVal;
                }),
                SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                Selector<_UserListBrowserVm, String?>(builder: (context, value, child) {
                  //getVm().listVmSub.formOperate.patchValue("status", value);
                  return MyFormBuilderSelect(
                      name: "status",
                      initialValue: value,
                      onTap: () => _onSelectUserStatus(context),
                      decoration: MySelectDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.user_label_status,
                          hintText: S.current.app_label_please_choose,
                          border: const UnderlineInputBorder(),
                          suffixIcon: InputDecorationUtils.autoClearSuffixBySelectVal(value, onPressed: () {
                            getVm().listVmSub.setSelectStatus(null);
                          })),
                      textInputAction: TextInputAction.next);
                }, selector: (context, vm) {
                  return vm.listVmSub.searchUser.statusName;
                }, shouldRebuild: (oldVal, newVal) {
                  return oldVal != newVal;
                }),
                Expanded(child: Builder(builder: (context) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: OutlinedButton(
                              onPressed: () {
                                getVm().listVmSub.onResetSearch();
                              },
                              child: Text(S.current.action_reset))),
                      SlcStyles.getSizedBox(width: SlcDimens.appDimens16),
                      Expanded(
                          child: FilledButton(
                              onPressed: () {
                                _autoHandlerDrawer(context);
                                getVm().listVmSub.onSearch();
                              },
                              child: Text(S.current.action_search)))
                    ],
                  );
                }))
              ],
            )));
  }

  void _onSelectUserStatus(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          List<SimpleDialogOption> dialogItem = DictUiUtils.dictList2DialogItem(
              context, LocalDictLib.DICT_MAP[LocalDictLib.CODE_SYS_NORMAL_DISABLE]!, (value) {
            //选择后设置性别
            getVm().listVmSub.setSelectStatus(value);
          });
          return SimpleDialog(title: Text(S.current.user_label_sex_select_prompt), children: dialogItem);
        });
  }

  //穿入Scaffold下级的context
  void _autoHandlerDrawer(BuildContext context) {
    ScaffoldState scaffoldState = Scaffold.of(context);
    if (scaffoldState.isEndDrawerOpen) {
      scaffoldState.closeEndDrawer();
    } else {
      scaffoldState.openEndDrawer();
    }
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
