import 'package:dio/dio.dart';
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
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/select_menu_result.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/fast_form_builder_text_field.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/input_decoration_utils.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/config/constant_base.dart';
import '../../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../../base/vm/global_vm.dart';
import '../../../../../feature/component/dict/entity/tree_dict.dart';
import '../../../../../lib/fast/vd/request_token_manager.dart';
import '../../../config/constant_sys.dart';
import '../../../entity/sys_tenant_package.dart';
import '../../../repository/remote/sys_tenant_package_api.dart';
import '../../menu_tree/menu_tree_select_multiple_page.dart';

class TenantPackageAddEditPage extends AppBaseStatelessWidget<_TenantPackageAddEditVm> {
  static const String routeName = '/tenant/tenantPackage/add_edit';

  final SysTenantPackage? sysTenantPackage;

  TenantPackageAddEditPage({super.key, this.sysTenantPackage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _TenantPackageAddEditVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(sysTenantPackage: sysTenantPackage);
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
                    title: Text(sysTenantPackage == null
                        ? S.current.sys_label_sys_tenant_package_add
                        : S.current.sys_label_sys_tenant_package_edit),
                    actions: [
                      IconButton(
                          onPressed: () {
                            getVm().onSave();
                          },
                          icon: Icon(Icons.save)),
                      if (sysTenantPackage != null)
                        PopupMenuButton(itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text(S.current.action_delete),
                              onTap: () {
                                FastDialogUtils.showDelConfirmDialog(context,
                                    contentText: TextUtil.format(
                                        S.current.sys_label_sys_tenant_package_del_prompt,
                                        [sysTenantPackage?.packageName ?? ""])).then((confirm) {
                                  if (confirm == true) {
                                    getVm().onDelete();
                                  }
                                });
                              },
                            )
                          ];
                        })
                    ],
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
                        name: "packageName",
                        initialValue: getVm().sysTenantPackage!.packageName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_sys_tenant_package_name),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenantPackage!.packageName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
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
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "remark",
                        initialValue: getVm().sysTenantPackage!.remark,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_oss_config_remark,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenantPackage!.remark = value;
                          getVm().applyInfoChange();
                        },
                        textInputAction: TextInputAction.next),
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

class _TenantPackageAddEditVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysTenantPackage? sysTenantPackage;

  bool _infoChange = false;

  void initVm({SysTenantPackage? sysTenantPackage}) {
    if (this.sysTenantPackage != null) {
      return;
    }
    if (sysTenantPackage == null) {
      sysTenantPackage = SysTenantPackage();
      ITreeDict<dynamic>? menuCheckStrictlyDict = GlobalVm()
          .dictShareVm
          .findDict(LocalDictLib.CODE_MENU_CHECK_STRICTLY, LocalDictLib.KEY_MENU_CHECK_STRICTLY_Y);
      sysTenantPackage.menuCheckStrictly =
          menuCheckStrictlyDict?.tdDictValue == LocalDictLib.KEY_MENU_CHECK_STRICTLY_Y;
      ITreeDict<dynamic>? statusDict = GlobalVm().dictShareVm.findDict(
          LocalDictLib.CODE_SYS_NORMAL_DISABLE, LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL);
      sysTenantPackage.status = statusDict?.tdDictValue;
      sysTenantPackage.menuIds = List.empty(growable: true);
      this.sysTenantPackage = sysTenantPackage;
      setLoadingStatusWithNotify(LoadingStatus.success, notify: false);
    } else {
      SysTenantPackageRepository.getInfo(sysTenantPackage.packageId!, defCancelToken)
          .asStream()
          .single
          .then((intensifyEntity) {
        this.sysTenantPackage = intensifyEntity.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: (e) {
        BaseDio.handlerError(e);
        finish();
      });
    }
  }

  void onSelectMenu() {
    pushNamed(TenantPackageMenuTreeSelectMultiplePage.routeName, arguments: {
      ConstantBase.KEY_INTENT_TITLE: S.current.user_label_menu_permission_select,
      ConstantSys.KEY_SYS_TENANT_PACKAGE_ID: sysTenantPackage!.packageId,
      ConstantSys.KEY_MENU_LINKAGE_ENABLE: sysTenantPackage!.menuCheckStrictly,
      ConstantBase.KEY_INTENT_SELECT_DATA: sysTenantPackage!.menuIds,
    }).then((result) {
      if (result != null && result is SelectMenuResult) {
        sysTenantPackage?.menuIds = result.menuIds;
        sysTenantPackage?.menuCheckStrictly = result.menuCheckStrictly;
        formOperate.patchField("menuIds", getMenuTextField());
      }
    });
  }

  String getMenuTextField() {
    if (sysTenantPackage?.menuIds?.isEmpty ?? true) {
      return "";
    } else {
      //return S.current.user_label_menu_permission_select_result.replaceAll("%s", roleInfo!.menuIds!.length.toString());
      return S.current.user_label_menu_permission_select_result2;
    }
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
    SysTenantPackageRepository.submit(sysTenantPackage!, defCancelToken).then((value) {
      AppToastUtil.showToast(msg: S.current.label_submitted_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
      finish(result: sysTenantPackage);
    }, onError: (error) {
      dismissLoading();
      BaseDio.handlerError(error);
    });
  }

  //删除字典类型
  void onDelete() {
    showLoading(text: S.current.label_delete_ing);
    SysTenantPackageRepository.delete(defCancelToken, id: sysTenantPackage!.packageId).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.label_delete_success);
      finish(result: true);
    }, onError: (e) {
      dismissLoading();
      BaseDio.handlerError(e);
      AppToastUtil.showToast(msg: S.current.label_delete_failed);
    });
  }
}
