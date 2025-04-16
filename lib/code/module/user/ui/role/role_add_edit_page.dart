import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/fast_form_builder_field_option.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/fast_form_builder_text_field.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/input_decoration_utils.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../base/vm/global_vm.dart';
import '../../../../feature/bizapi/user/config/constant_user_api.dart';
import '../../../../feature/bizapi/user/entity/role.dart';
import '../../../../feature/bizapi/user/entity/select_menu_result.dart';
import '../../../../feature/component/dict/entity/tree_dict.dart';
import '../../../../feature/bizapi/system/repository/local/local_dict_lib.dart';
import '../../../../feature/component/dict/utils/dict_ui_utils.dart';
import '../../../system/config/constant_sys.dart';
import '../../../system/ui/menu/tree/menu_tree_select_multiple_page.dart';
import '../../repository/remote/role_api.dart';

class RoleAddEditPage extends AppBaseStatelessWidget<_PostAddEditVm> {
  static const String routeName = '/system/role/add_edit';

  final Role? role;

  RoleAddEditPage(this.role, {super.key}) {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _PostAddEditVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(role);
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
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(role == null
                        ? S.current.user_label_role_add
                        : S.current.user_label_role_edit),
                    actions: () {
                      List<Widget> actions = [];
                      if (role?.roleId == ConstantUserApi.VALUE_SUPER_ADMIN_ROLE_ID) {
                        return actions;
                      }
                      if ((globalVm.userShareVm.hasPermiAny(["system:role:edit"]) &&
                              role != null) ||
                          (globalVm.userShareVm.hasPermiAny(["system:role:add"]) &&
                              role == null)) {
                        actions.add(IconButton(
                            onPressed: () {
                              getVm().onSave();
                            },
                            icon: Icon(Icons.save)));
                      }
                      if (role != null &&
                          globalVm.userShareVm.hasPermiAny(["system:role:remove"])) {
                        actions.add(PopupMenuButton(itemBuilder: (context) {
                          return [
                            if (globalVm.userShareVm.hasPermiAny(["system:role:remove"]))
                              PopupMenuItem(
                                child: Text(S.current.action_delete),
                                onTap: () {
                                  FastDialogUtils.showDelConfirmDialog(context,
                                      contentText: TextUtil.format(
                                          S.current.user_label_role_del_prompt,
                                          [role?.roleName ?? ""])).then((confirm) {
                                    if (confirm == true) {
                                      getVm().onDelete();
                                    }
                                  });
                                },
                              )
                          ];
                        }));
                      }
                      return actions;
                    }.call(),
                  ),
                  body: getStatusBody(context)));
        });
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
                        name: "roleName",
                        initialValue: getVm().roleInfo!.roleName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(S.current.user_label_role_name),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().roleInfo!.roleName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "roleKey",
                        initialValue: getVm().roleInfo!.roleKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(S.current.user_label_role_key),
                            hintText: S.current.app_label_please_choose,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().roleInfo!.roleKey = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderTextField(
                      name: "roleSort",
                      initialValue: () {
                        int orderNum = getVm().roleInfo!.roleSort!;
                        return orderNum.toString();
                      }.call(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: MyInputDecoration(
                          contentPadding: EdgeInsets.zero,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: InputDecUtils.getRequiredLabel(S.current.app_label_show_sort),
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder()),
                      onChanged: (value) {
                        getVm().applyInfoChange();
                        getVm().roleInfo!.roleSort = value == null ? null : int.tryParse(value);
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ]),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderRadioGroup<OptionVL<String>>(
                        name: "status",
                        initialValue: DictUiUtils.dict2OptionVL(GlobalVm().dictShareVm.findDict(
                            LocalDictLib.CODE_SYS_NORMAL_DISABLE, getVm().roleInfo!.status,
                            defDictKey: LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL)),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(labelText: S.current.app_label_status),
                        options: DictUiUtils.dictList2FromOption(
                            globalVm.dictShareVm.dictMap[LocalDictLib.CODE_SYS_NORMAL_DISABLE]!),
                        onChanged: (value) {
                          //此处需改成选择的
                          getVm().applyInfoChange();
                          getVm().roleInfo!.status = value?.value;
                        }),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderSelect(
                      name: "menuIds",
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: getVm().getMenuTextField(),
                      onTap: () {
                        //选择菜单
                        getVm().onSelectMenu();
                      },
                      decoration: MySelectDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label:
                              InputDecUtils.getRequiredLabel(S.current.user_label_menu_permission),
                          hintText: S.current.app_label_please_choose,
                          border: const UnderlineInputBorder()),
                      onChanged: (value) {
                        getVm().applyInfoChange();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    if (role != null) ...[
                      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                      MyFormBuilderSelect(
                        name: "dataScope",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        initialValue: globalVm.dictShareVm
                            .findDict(LocalDictLib.CODE_ROLE_DATA_PERMISSIONS,
                                getVm().roleInfo!.dataScope,
                                defDictKey: LocalDictLib.KEY_ROLE_ONLY_USER)
                            ?.tdDictLabel,
                        onTap: () {
                          DictUiUtils.showSelectDialog(
                              context, LocalDictLib.CODE_ROLE_DATA_PERMISSIONS, (value) {
                            //选择后设置性别
                            getVm().setDataScope(value);
                          }, title: S.current.user_label_data_permission_select);
                        },
                        decoration: MySelectDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.user_label_data_permission),
                            hintText: S.current.app_label_please_choose,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().applyInfoChange();
                        },
                        textInputAction: TextInputAction.next,
                      )
                    ],
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "remark",
                        initialValue: getVm().roleInfo!.remark,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.app_label_remark,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          //此处需改成选择的
                          getVm().applyInfoChange();
                          getVm().roleInfo!.remark = value;
                        }),
                  ],
                ))));
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

class _PostAddEditVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  Role? roleInfo;

  bool _infoChange = false;

  void initVm(Role? role) {
    if (roleInfo != null) {
      return;
    }
    if (role == null) {
      role = Role();
      ITreeDict<dynamic> treeDict = GlobalVm().dictShareVm.findDict(
          LocalDictLib.CODE_SYS_NORMAL_DISABLE, LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL)!;
      role.status = treeDict.tdDictValue;
      role.statusName = treeDict.tdDictLabel;
      role.roleSort = 0;
      roleInfo = role;
      setLoadingStatusWithNotify(LoadingStatus.success, notify: false);
    } else {
      RoleRepository.getInfo(role.roleId!, defCancelToken).asStream().single.then(
          (intensifyEntity) {
        roleInfo = intensifyEntity.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: BaseDio.errProxyFunc(onError: (error) {
        if (error.isUnauthorized()) {
          return;
        }
        finish();
      }));
    }
  }

  void onSelectMenu() {
    pushNamed(RoleMenuTreeSelectMultiplePage.routeName, arguments: {
      ConstantBase.KEY_INTENT_TITLE: S.current.user_label_menu_permission_select,
      ConstantSys.KEY_MENU_ID: roleInfo!.roleId,
      ConstantBase.KEY_INTENT_SELECT_DATA: roleInfo!.menuIds,
    }).then((result) {
      if (result != null && result is SelectMenuResult) {
        roleInfo?.menuIds = result.menuIds;
        formOperate.patchField("menuIds", getMenuTextField());
      }
    });
  }

  String getMenuTextField() {
    if (roleInfo?.menuIds?.isEmpty ?? true) {
      return "";
    } else {
      //return S.current.user_label_menu_permission_select_result.replaceAll("%s", roleInfo!.menuIds!.length.toString());
      return S.current.user_label_menu_permission_select_result2;
    }
  }

  void setDataScope(ITreeDict<dynamic>? treeDict) {
    roleInfo!.dataScope = treeDict?.tdDictValue;
    roleInfo!.dataScopeName = treeDict?.tdDictLabel;
    applyInfoChange();
    formOperate.patchField("dataScope", roleInfo!.dataScopeName);
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
    RoleRepository.submit(roleInfo!, defCancelToken).then((value) {
      AppToastUtil.showToast(msg: S.current.label_submitted_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
      finish(result: roleInfo);
    }, onError: BaseDio.errProxyFunc(onError: (error) {
      dismissLoading();
    }));
  }

  //删除角色
  void onDelete() {
    showLoading(text: S.current.label_delete_ing);
    RoleRepository.delete(defCancelToken, roleId: roleInfo!.roleId).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.label_delete_success);
      finish(result: true);
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: S.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}
