import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/user.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/entity/tree_dict.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/user/entity/dept_tree.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/dept_api.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/user_api.dart';
import 'package:dio/dio.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_list_page_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../res/dimens.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../base/vm/global_vm.dart';
import '../../../../feature/bizapi/system/repository/local/local_dict_lib.dart';
import '../../../../feature/component/dict/utils/dict_ui_utils.dart';
import '../../../../feature/component/tree/entity/slc_tree_nav.dart';
import '../../../../feature/component/tree/vd/tree_data_list_vd.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import '../../../../lib/form/fast_form_builder_text_field.dart';
import '../../../../lib/form/form_operate_with_provider.dart';
import '../../../../lib/form/input_decoration_utils.dart';
import '../dept/dept_list_select_single_page.dart';

class UserListPageVd {
  ///部门和用户混合列表
  static Widget getDeptUserListWidget(ThemeData themeData, UserTreeListDataVmSub listVmSub,
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
          if (listItem is DeptTree) {
            return DeptListPageWidget.getDataListItem(
                themeData, listVmSub, index, listItem, buildTrailing);
            /*return Padding(
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
                    }));*/
          }
          if (listItem is User) {
            return getUserListItem(themeData, listVmSub, index, listItem);
          }
          throw Exception("listItem 类型错误");
        });
  }

  ///用户列表
  static Widget getUserListWidget(ThemeData themeData, IListDataVmSub<User> listVmSub,
      {Widget? Function(User currentItem)? buildTrailing}) {
    assert(listVmSub is ListenerItemSelect<dynamic>);
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (context, index) {
          User listItem = listVmSub.dataList[index];
          return UserListPageVd.getUserListItem(
              themeData, listVmSub as ListenerItemSelect<dynamic>, index, listItem,
              buildTrailing: buildTrailing);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
    /*return ListView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (context, index) {
          User listItem = listVmSub.dataList[index];
          return UserListPageVd.getUserListItem(
              themeData, listVmSub as ListenerItemSelect<dynamic>, index, listItem,
              buildTrailing: (currentItem) {
            return null;
          });
        });*/
  }

  ///用户item
  static Widget getUserListItem(
      ThemeData themeData, ListenerItemSelect<dynamic> listenerItemSelect, int index, User listItem,
      {Widget? Function(User currentItem)? buildTrailing}) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
      leading: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(AppDimens.userItemAvatarRadius)),
          child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: AppDimens.userItemAvatarSize,
              height: AppDimens.userItemAvatarSize,
              imageUrl: listItem.avatar ?? "",
              placeholder: (context, url) {
                return Image.asset("assets/images/base/ic_def_user_head.png",
                    width: AppDimens.userItemAvatarSize, height: AppDimens.userItemAvatarSize);
              },
              errorWidget: (
                context,
                error,
                stackTrace,
              ) {
                return Image.asset("assets/images/base/ic_def_user_head.png",
                    width: AppDimens.userItemAvatarSize, height: AppDimens.userItemAvatarSize);
              })),
      title: Text(listItem.nickName ?? "-"),
      subtitle: Text(listItem.deptName ?? "-"),
      minTileHeight: AppDimens.userItemAvatarSize + SlcDimens.appDimens16,
      trailing: WidgetUtils.getAnimCrossFade(
          Checkbox(
            value: listItem.isBoxChecked(),
            onChanged: (value) {
              listItem.boxChecked = value;
              listenerItemSelect.onItemSelect(index, listItem, value);
            },
          ),
          buildTrailing?.call(listItem) ?? ThemeUtil.getBoxStandard(),
          showOne: listenerItemSelect.selectModelIsRun),
      visualDensity: VisualDensity.compact,
      //根据card规则实现
      onTap: () {
        listenerItemSelect.onItemClick(index, listItem);
        //getVm().nextByDept(listItem);
      },
      onLongPress: () {
        GlobalVm().userShareVm.execPermiEvery(
            ["system:user:remove"], () => listenerItemSelect.onItemLongClick(index, listItem));
      },
    );
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer<A>(
      BuildContext context, ThemeData themeData, UserPageDataVmSub listVmSub,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<User>(builder: (context, value, child) {
          return FormBuilder(
              key: listVmSub.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.user_label_search_user,
                          style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData))),
                  ...formItemSlot?.call("deptName") ??
                      <Widget>[
                        ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                        MyFormBuilderSelect(
                            name: "deptName",
                            initialValue: listVmSub.searchUser.deptName,
                            onTap: () => listVmSub.onSelectDept(),
                            decoration: MySelectDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: S.current.user_label_user_owner_dept,
                              hintText: S.current.app_label_please_choose,
                              border: const UnderlineInputBorder(),
                              suffixIcon:
                                  NqNullSelector<A, String?>(builder: (context, value, child) {
                                return InputDecUtils.autoClearSuffixBySelectVal(
                                    listVmSub.searchUser.deptName, onPressed: () {
                                  listVmSub.setSelectDept(null);
                                });
                              }, selector: (context, vm) {
                                return listVmSub.searchUser.deptName;
                              }),
                            ),
                            textInputAction: TextInputAction.next)
                      ],
                  ...formItemSlot?.call("userName") ??
                      <Widget>[
                        ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                        FormBuilderTextField(
                            name: "userName",
                            initialValue: listVmSub.searchUser.userName,
                            decoration: MyInputDecoration(
                                contentPadding: EdgeInsets.zero,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: S.current.user_label_user_name,
                                hintText: S.current.app_label_please_input,
                                border: const UnderlineInputBorder(),
                                suffixIcon:
                                    NqNullSelector<A, String?>(builder: (context, value, child) {
                                  return InputDecUtils.autoClearSuffixByInputVal(value,
                                      formOperate: listVmSub.formOperate,
                                      formFieldName: "userName");
                                }, selector: (context, vm) {
                                  return listVmSub.searchUser.userName;
                                })),
                            onChanged: (value) {
                              listVmSub.searchUser.userName = value;
                              listVmSub.notifyListeners();
                            },
                            textInputAction: TextInputAction.next)
                      ],
                  ...formItemSlot?.call("phonenumber") ??
                      <Widget>[
                        ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                        FormBuilderTextField(
                            name: "phonenumber",
                            initialValue: listVmSub.searchUser.phonenumber,
                            decoration: MyInputDecoration(
                                contentPadding: EdgeInsets.zero,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: S.current.user_label_phone_number,
                                hintText: S.current.app_label_please_input,
                                border: const UnderlineInputBorder(),
                                suffixIcon:
                                    NqNullSelector<A, String?>(builder: (context, value, child) {
                                  return InputDecUtils.autoClearSuffixByInputVal(value,
                                      formOperate: listVmSub.formOperate,
                                      formFieldName: "phonenumber");
                                }, selector: (context, vm) {
                                  return listVmSub.searchUser.phonenumber;
                                })),
                            onChanged: (value) {
                              listVmSub.searchUser.phonenumber = value;
                              listVmSub.notifyListeners();
                            },
                            textInputAction: TextInputAction.next)
                      ],
                  ...formItemSlot?.call("status") ??
                      <Widget>[
                        ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                        MyFormBuilderSelect(
                            name: "status",
                            initialValue: listVmSub.searchUser.statusName,
                            onTap: () {
                              DictUiUtils.showSelectDialog(
                                  context, LocalDictLib.CODE_SYS_NORMAL_DISABLE, (value) {
                                listVmSub.setSelectStatus(value);
                              });
                            },
                            decoration: MySelectDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: S.current.user_label_status,
                                hintText: S.current.app_label_please_choose,
                                border: const UnderlineInputBorder(),
                                suffixIcon:
                                    NqSelector<A, String?>(builder: (context, value, child) {
                                  return InputDecUtils.autoClearSuffixBySelectVal(
                                    value,
                                    onPressed: () {
                                      listVmSub.setSelectStatus(null);
                                    },
                                  );
                                }, selector: (context, vm) {
                                  return listVmSub.searchUser.statusName;
                                })),
                            textInputAction: TextInputAction.next)
                      ],
                  Expanded(child: Builder(builder: (context) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  listVmSub.onResetSearch();
                                },
                                child: Text(S.current.action_reset))),
                        ThemeUtil.getSizedBox(width: SlcDimens.appDimens16),
                        Expanded(
                            child: FilledButton(
                                onPressed: () {
                                  WidgetUtils.autoHandlerSearchDrawer(context);
                                  listVmSub.onSearch();
                                },
                                child: Text(S.current.action_search)))
                      ],
                    );
                  }))
                ],
              ));
        }, selector: (context) {
          return listVmSub.searchUser;
        }, shouldRebuild: (oldVal, newVal) {
          return false;
        }));
  }
}

///用户树数据形势的VmSub
class UserTreeListDataVmSub extends TreeFastBaseListDataVmSub<dynamic> {
  late FastVm fastVm;

  final Dept _currentDeptSearch = Dept(parentId: ConstantBase.VALUE_PARENT_ID_DEF);

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
          userIntensifyEntity = await UserServiceRepository.queryNoPage(_searchUser, cancelToken);
        }
        //创建动态返回类型并添加部门信息
        IntensifyEntity<List<dynamic>> intensifyEntity = IntensifyEntity<List<dynamic>>(
            createSucceed:
                deptIntensifyEntity.isSuccess() ? () => ResultEntity.createSucceedEntity() : null,
            data: List.of(deptIntensifyEntity.data ?? List.empty(growable: true), growable: true));
        List<dynamic> allList = intensifyEntity.data ?? List.empty(growable: true);
        //合并用户
        if (userIntensifyEntity?.data != null) {
          allList.addAll(userIntensifyEntity!.data!);
        }
        //返回数据结构
        DataWrapper<List<dynamic>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
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

///用户分页加载列表
class UserPageDataVmSub extends FastBaseListDataPageVmSub<User> with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  User _searchUser = User();

  User get searchUser => _searchUser;

  UserPageDataVmSub() {
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<User>> result = await UserServiceRepository.list(
            loadMoreFormat.offset, loadMoreFormat.size, searchUser, defCancelToken);
        //返回数据结构
        DataWrapper<PageModel<User>> dataWrapper = DataTransformUtils.entity2LDWrapper(result);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
  }

  //选择部门事件
  void onSelectDept() {
    pushNamed(DeptListSingleSelectPage.routeName,
            arguments: {ConstantBase.KEY_INTENT_TITLE: S.current.user_label_dept_select})
        .then((result) {
      if (result != null) {
        setSelectDept(result);
      }
    });
  }

  //设置选择部门
  void setSelectDept(DeptTree? dept) {
    searchUser.deptId = dept?.id;
    searchUser.deptName = dept?.label;
    formOperate.patchField("deptName", searchUser.deptName);
    notifyListeners();
  }

  //设置选择状态
  void setSelectStatus(ITreeDict<dynamic>? data) {
    searchUser.status = data?.tdDictValue;
    searchUser.statusName = data?.tdDictLabel;
    formOperate.patchField("status", searchUser.statusName);
    notifyListeners();
  }

  //重置
  void onResetSearch() {
    _searchUser = User();
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }
}
