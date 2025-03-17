import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/api/result_entity.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/config/constant_user_api.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/fast_form_builder_field_option.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/fast_form_builder_text_field.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/input_decoration_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/user_api.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_list_select_single_page.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/role/role_list_select_multiple_page.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../base/vm/global_vm.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';
import '../../../../feature/bizapi/user/entity/post.dart';
import '../../../../feature/bizapi/user/entity/role.dart';
import '../../../../feature/bizapi/user/entity/user.dart';
import '../../../../feature/bizapi/user/entity/user_info_vo.dart';
import '../../../../feature/component/dict/entity/tree_dict.dart';
import '../../../../feature/bizapi/system/repository/local/local_dict_lib.dart';
import '../../../../feature/component/dict/utils/dict_ui_utils.dart';
import '../../../../lib/form/form_builder_flow_tag.dart';
import '../post/post_list_select_multiple_page.dart';

class UserAddEditPage extends AppBaseStatelessWidget<_UserAddEditVm> {
  static const String routeName = '/system/user/add_edit';

  final User? user;

  UserAddEditPage(this.user, {super.key}) {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _UserAddEditVm(),
        builder: (context, child) {
          registerEvent(context);
          getVm().initVm(user);
          return PopScope(
              canPop: false,
              onPopInvokedWithResult: (canPop, result) {
                if (canPop) {
                  return;
                }
                if (getVm().canPop()) {
                  Navigator.pop(context);
                  return;
                }
                //没有保存则显示提示保存对话框
                _showPromptSaveDialog(context);
              },
              child: Scaffold(appBar: getAppBar(), body: getStatusBody(context)));
        });
  }

  AppBar getAppBar() {
    return AppBar(
      title: Text(user == null ? S.current.user_label_user_add : S.current.user_label_user_edit),
      actions: () {
        List<Widget> actionList = List.empty(growable: true);
        if (user?.userId == ConstantUserApi.VALUE_SUPER_ADMIN_ID) {
          return actionList;
        }
        actionList.add(IconButton(
            onPressed: () {
              getVm().onSave();
            },
            icon: Icon(Icons.save)));
        if (user != null) {
          actionList.add(PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text(S.current.action_delete),
                onTap: () {
                  FastDialogUtils.showDelConfirmDialog(context,
                          contentText: TextUtil.format(
                              S.current.user_label_data_del_prompt, [user?.nickName ?? ""]))
                      .then((confirm) {
                    if (confirm == true) {
                      getVm().onDelete();
                    }
                  });
                },
              ),
              PopupMenuItem(
                child: Text(S.current.user_label_reset_password),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        String newPassword = "";
                        return AlertDialog(
                            title: Text(S.current.label_prompt),
                            content: TextField(
                                decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    label: Text(S.current.user_label_new_password_input)),
                                onChanged: (value) {
                                  newPassword = value;
                                }),
                            actions: FastDialogUtils.getCommonlyAction(context, positiveLister: () {
                              if (TextUtil.isEmpty(newPassword)) {
                                AppToastUtil.showToast(
                                    msg: S.current.app_label_required_information_cannot_be_empty);
                                return;
                              }
                              Navigator.pop(context);
                              getVm().onResetPassword(newPassword);
                            }));
                      });
                },
              ),
            ];
          }));
        }
        return actionList;
      }.call(),
    );
  }

  @override
  Widget getSuccessWidget(BuildContext context, {Map<String, dynamic>? params}) {
    ThemeData themeData = Theme.of(context);
    return KeyboardAvoider(
        autoScroll: true,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
            child: FormBuilder(
                key: getVm().formOperate.formKey,
                onChanged: () {
                  //这里要不要应该无所谓，因为本表单的数据存在vm的实例中
                  //getVm()._formKey.currentState?.save();
                },
                child: Column(
                  children: [
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens8),
                    MyFormBuilderTextField(
                        name: "nikeName",
                        initialValue: getVm().userInfo!.nickName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(S.current.user_label_nike_name),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().userInfo!.nickName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderSelect(
                        name: "deptName",
                        initialValue: getVm().userInfo!.deptName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () {
                          getVm().onSelectOwnerDept();
                        },
                        decoration: MySelectDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.user_label_user_owner_dept),
                            hintText: S.current.app_label_please_choose,
                            border: const UnderlineInputBorder()),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "phonenumber",
                        initialValue: getVm().userInfo!.phonenumber,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_phone_number,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().userInfo!.phonenumber = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.phoneNumber(checkNullOrEmpty: false),
                        ]),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "email",
                        initialValue: getVm().userInfo!.email,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_mailbox,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().userInfo!.email = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.email(checkNullOrEmpty: false),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "userName",
                        initialValue: getVm().userInfo!.userName,
                        readOnly: getVm().userInfo?.userId != null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: getVm().userInfo?.userId != null
                            ? TextStyle(color: themeData.hintColor)
                            : null,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(S.current.user_label_user_name),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().userInfo!.userName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next),
                    ...() {
                      List<Widget> passwordWidget = List.empty(growable: true);
                      if (getVm().userInfo?.userId == null) {
                        passwordWidget.add(ThemeUtil.getSizedBox(height: SlcDimens.appDimens16));
                        passwordWidget.add(MyFormBuilderTextField(
                            name: "password",
                            initialValue: getVm().userInfo!.password,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            obscureText: true,
                            decoration: MyInputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                label:
                                    InputDecUtils.getRequiredLabel(S.current.user_label_password),
                                hintText: S.current.app_label_please_input,
                                border: const UnderlineInputBorder()),
                            onChanged: (value) {
                              getVm().userInfo!.password = value;
                              getVm().applyInfoChange();
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next));
                      }
                      return passwordWidget;
                    }.call(),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderSelect(
                        name: "sex",
                        initialValue: getVm().userInfo!.sexName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () {
                          DictUiUtils.showSelectDialog(context, LocalDictLib.CODE_SYS_USER_SEX,
                              (value) {
                            //选择后设置性别
                            getVm().setSelectSex(value);
                          }, title: S.current.user_label_sex_select_prompt);
                        },
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_sex,
                            hintText: S.current.app_label_please_choose,
                            border: const UnderlineInputBorder(),
                            suffixIcon: NqSelector<_UserAddEditVm, String?>(
                                builder: (context, value, child) {
                              return InputDecUtils.autoClearSuffixBySelectVal(value, onPressed: () {
                                getVm().setSelectSex(null);
                              });
                            }, selector: (context, vm) {
                              return vm.userInfo!.sex;
                            })),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderRadioGroup<OptionVL<String>>(
                        name: "status",
                        initialValue: DictUiUtils.dict2OptionVL(GlobalVm().dictShareVm.findDict(
                            LocalDictLib.CODE_SYS_NORMAL_DISABLE, getVm().userInfo!.status,
                            defDictKey: LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL)),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(labelText: S.current.app_label_status),
                        options: DictUiUtils.dictList2FromOption(
                            globalVm.dictShareVm.dictMap[LocalDictLib.CODE_SYS_NORMAL_DISABLE]!),
                        onChanged: (value) {
                          //此处需改成选择的
                          getVm().applyInfoChange();
                          getVm().userInfo!.status = value?.value;
                        }),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderFlowTag<Role>(
                        name: "roles",
                        initialValue: getVm().userInfo!.roles,
                        deleteIcon: Icon(Icons.clear),
                        onDeleted: (role) {
                          getVm().remoteSelectRole(role);
                        },
                        builderChipOption: (value) {
                          return FormBuilderChipOption(value: value, child: Text(value.roleName!));
                        },
                        spacing: 10,
                        onTap: () {
                          _showSelectRoleDialog(context);
                        },
                        decoration: MySelectDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(S.current.user_label_role),
                            hintText: S.current.app_label_please_choose,
                            border: UnderlineInputBorder(),
                            suffixIcon: InputDecUtils.getSuffixAction(InputDecUtils.moreIcon, () {
                              _showSelectRoleDialog(context);
                            }))),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderFlowTag<Post>(
                      name: "posts",
                      initialValue: getVm().userInfo!.posts,
                      deleteIcon: Icon(Icons.clear),
                      onDeleted: (post) {
                        getVm().remoteSelectPost(post);
                      },
                      builderChipOption: (value) {
                        return FormBuilderChipOption(value: value, child: Text(value.postName!));
                      },
                      spacing: 10,
                      onTap: () {
                        _showSelectPostDialog(context);
                      },
                      decoration: MySelectDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: Text(S.current.user_label_post),
                          hintText: S.current.app_label_please_choose,
                          border: UnderlineInputBorder(),
                          suffixIcon: InputDecUtils.getSuffixAction(InputDecUtils.moreIcon, () {
                            _showSelectPostDialog(context);
                          })),
                    ),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "remark",
                        initialValue: getVm().userInfo!.remark,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.app_label_remark,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          //此处需改成选择的
                          getVm().applyInfoChange();
                          getVm().userInfo!.remark = value;
                        }),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  ],
                ))));
  }

  void _showSelectRoleDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return RoleListMultipleSelectDialog.getRoleListSelectDialog(
              selectDataIds: Role.toRoleIdList(getVm().userInfo!.roles),
              dataSrc: getVm().userInfoVo!.roles);
        }).then((result) {
      if (result != null) {
        getVm().setSelectRole(result);
      }
    });
  }

  void _showSelectPostDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return PostListMultipleSelectDialog.getPostListSelectDialog(
              selectDataIds: Post.toPostIdList(getVm().userInfo!.posts),
              dataSrc: getVm().userInfoVo!.posts);
        }).then((result) {
      if (result != null) {
        getVm().setSelectPost(result);
      }
    });
  }

  ///显示提示保存对话框
  void _showPromptSaveDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(S.current.label_prompt),
              content: Text(S.current.app_label_data_save_prompt),
              actions: FastDialogUtils.getCommonlyAction(context,
                  positiveText: S.current.action_exit, positiveLister: () {
                Navigator.pop(context);
                getVm().abandonEdit();
              }));
        });
  }
}

class _UserAddEditVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  UserInfoVo? userInfoVo;

  User? get userInfo => userInfoVo!.user;

  bool _infoChange = false;

  void initVm(User? user) {
    if (userInfoVo != null) {
      return;
    }
    UserServiceRepository.getUserById(user?.userId, defCancelToken).asStream().single.then(
        (intensifyEntity) {
      userInfoVo = intensifyEntity.data;
      userInfoVo!.user = userInfoVo!.user ?? User();
      setLoadingStatus(LoadingStatus.success);
    }, onError: (e) {
      BaseDio.handlerError(e);
      finish();
    });
  }

  void onSelectOwnerDept() {
    pushNamed(DeptListSingleSelectPage.routeName, arguments: <String, dynamic>{
      ConstantBase.KEY_INTENT_TITLE: S.current.user_label_user_owner_dept_select
    }).then((result) {
      if (result != null) {
        setOwnerDept(result);
      }
    });
  }

  void setOwnerDept(Dept? dept) {
    userInfo!.deptId = dept?.deptId;
    userInfo!.deptName = dept?.deptName;
    formOperate.patchField("deptName", userInfo!.deptName);
    applyInfoChange();
  }

  //选择性别
  void setSelectSex(ITreeDict<dynamic>? item) {
    userInfo!.sex = item?.tdDictValue;
    userInfo!.sexName = item?.tdDictLabel;
    formOperate.patchField("sex", userInfo!.sexName);
    applyInfoChange();
    notifyListeners();
  }

  //移除某个角色
  void remoteSelectRole(Role role) {
    userInfo!.roles?.remove(role);
    setSelectRole(userInfo!.roles!);
  }

  //设置角色
  void setSelectRole(List<Role> roleList) {
    userInfo!.roles = roleList;
    userInfo!.roleIds = Role.toRoleIdList(roleList);
    formOperate.patchField("roles", userInfo!.roles);
    applyInfoChange();
    //notifyListeners();
  }

  //移除某个岗位
  void remoteSelectPost(Post post) {
    userInfo!.posts?.remove(post);
    setSelectPost(userInfo!.posts!);
  }

  //设置岗位
  void setSelectPost(List<Post> postList) {
    userInfo!.posts = postList;
    userInfo!.postIds = Post.toPostIdList(postList);
    formOperate.patchField("posts", userInfo!.posts);
    applyInfoChange();
    //notifyListeners();
  }

  //应用信息更改
  void applyInfoChange() {
    _infoChange = true;
  }

  //放弃修改
  void abandonEdit() {
    _infoChange = false;
    finish();
  }

  bool canPop() {
    return !_infoChange;
  }

  //检查保存参数
  bool _checkSaveParams() {
    return formOperate.formBuilderState?.saveAndValidate() ?? false;
  }

  void onSave() {
    if (!_checkSaveParams()) {
      AppToastUtil.showToast(msg: S.current.app_label_form_check_hint);
      return;
    }
    showLoading(text: S.current.label_save_ing);
    UserServiceRepository.submit(userInfo!, defCancelToken).then((value) {
      AppToastUtil.showToast(msg: S.current.label_submitted_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
      finish(result: userInfo);
    }, onError: (error) {
      dismissLoading();
      BaseDio.handlerError(error);
    });
  }

  void onDelete() {
    showLoading(text: S.current.label_delete_ing);
    UserServiceRepository.delete(defCancelToken, userId: userInfo!.userId).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.label_delete_success);
      finish(result: true);
    }, onError: (e) {
      dismissLoading();
      BaseDio.handlerError(e);
      AppToastUtil.showToast(msg: S.current.label_delete_failed);
    });
  }

  //重置密码
  void onResetPassword(String newPassword) {
    userInfo!.password = newPassword;
    showLoading(text: S.current.label_submit_ing);
    UserServiceRepository.resetPwd(userInfo!, defCancelToken).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.user_label_reset_password_success);
    }, onError: (e) {
      dismissLoading();
      BaseDio.handlerError(e);
      AppToastUtil.showToast(msg: S.current.user_label_reset_password_fail);
    });
  }
}
