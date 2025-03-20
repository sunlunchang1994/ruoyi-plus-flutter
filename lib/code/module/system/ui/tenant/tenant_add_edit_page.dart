import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/num_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/slc_num_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/fast_form_builder_text_field.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/input_decoration_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_tenant_package.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/tenant/package/tenant_package_select_single_page.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/config/constant_base.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../base/vm/global_vm.dart';
import '../../../../feature/bizapi/system/entity/sys_tenant.dart';
import '../../../../feature/component/dict/entity/tree_dict.dart';
import '../../repository/remote/sys_tenant_api.dart';

class TenantAddEditPage extends AppBaseStatelessWidget<_TenantAddEditVm> {
  static const String routeName = '/tenant/tenant/add_edit';

  final SysTenant? sysTenant;

  TenantAddEditPage({super.key, this.sysTenant});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _TenantAddEditVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(sysTenant: sysTenant);
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
                    title: Text(sysTenant == null
                        ? S.current.sys_label_sys_tenant_add
                        : S.current.sys_label_sys_tenant_edit),
                    actions: [
                      IconButton(
                          onPressed: () {
                            getVm().onSave();
                          },
                          icon: Icon(Icons.save)),
                      if (sysTenant != null)
                        PopupMenuButton<String>(itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text(S.current.action_delete),
                              onTap: () {
                                FastDialogUtils.showDelConfirmDialog(context,
                                    contentText: TextUtil.format(
                                        S.current.sys_label_sys_tenant_del_prompt,
                                        [sysTenant?.companyName])).then((confirm) {
                                  if (confirm == true) {
                                    getVm().onDelete();
                                  }
                                });
                              },
                            ),
                            PopupMenuItem(
                                value: S.current.sys_label_sys_tenant_sync_package,
                                child: Text(S.current.sys_label_sys_tenant_sync_package))
                          ];
                        }, onSelected: (value) {
                          if (value == S.current.sys_label_sys_tenant_sync_package) {
                            //同步套餐
                            getVm().syncTenantPackage();
                          }
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
                        name: "companyName",
                        initialValue: getVm().sysTenant!.companyName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_sys_tenant_company_name),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenant!.companyName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "contactUserName",
                        initialValue: getVm().sysTenant!.contactUserName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_sys_tenant_contact_user_name),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenant!.contactUserName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "contactPhone",
                        initialValue: getVm().sysTenant!.contactPhone,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_sys_tenant_contact_phone),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenant!.contactPhone = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.phoneNumber(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    ...() {
                      List<Widget> addWidgets = List.empty(growable: true);
                      if (sysTenant == null) {
                        addWidgets.addAll([
                          MyFormBuilderTextField(
                              name: "username",
                              initialValue: getVm().sysTenant!.username,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: MyInputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  label: InputDecUtils.getRequiredLabel(
                                      S.current.sys_label_sys_tenant_user_name),
                                  hintText: S.current.app_label_please_input,
                                  border: const UnderlineInputBorder()),
                              onChanged: (value) {
                                getVm().sysTenant!.username = value;
                                getVm().applyInfoChange();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              textInputAction: TextInputAction.next),
                          ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                          MyFormBuilderTextField(
                              name: "password",
                              initialValue: getVm().sysTenant!.password,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              obscureText: true,
                              decoration: MyInputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  label: InputDecUtils.getRequiredLabel(
                                      S.current.sys_label_sys_tenant_user_pw),
                                  hintText: S.current.app_label_please_input,
                                  border: const UnderlineInputBorder()),
                              onChanged: (value) {
                                getVm().sysTenant!.password = value;
                                getVm().applyInfoChange();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              textInputAction: TextInputAction.next),
                          ThemeUtil.getSizedBox(height: SlcDimens.appDimens16)
                        ]);
                      }
                      return addWidgets;
                    }.call(),
                    () {
                      MySelectDecoration decoration = MySelectDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_sys_tenant_package_id,
                          hintText: S.current.app_label_please_choose,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<_TenantAddEditVm, String?>(
                              builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixBySelectVal(
                                getVm().sysTenant!.packageName, onPressed: () {
                              getVm().setPackageInfo(null);
                            });
                          }, selector: (context, vm) {
                            return vm.sysTenant!.packageName;
                          }));
                      if (sysTenant == null) {
                        return MyFormBuilderSelect(
                            name: "packageName",
                            initialValue: getVm().sysTenant!.packageName,
                            onTap: () {
                              //选择套餐
                              getVm().onSelectPackage();
                            },
                            decoration: decoration,
                            textInputAction: TextInputAction.next);
                      } else {
                        //编辑时设置为禁用状态
                        return MyFormBuilderSelect(
                            name: "packageName",
                            initialValue: getVm().sysTenant!.packageName,
                            enabled: false,
                            onTap: () {
                              //选择套餐
                              getVm().onSelectPackage();
                            },
                            decoration: decoration,
                            textInputAction: TextInputAction.next);
                      }
                    }.call(),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "expireTime",
                        initialValue: getVm().sysTenant!.expireTime,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_sys_tenant_expire_time,
                            hintText: S.current.app_label_please_choose,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenant!.expireTime = value;
                          getVm().applyInfoChange();
                        },
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "accountCount",
                        initialValue: getVm().sysTenant!.accountCount?.toString(),
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_sys_tenant_account_count,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenant!.accountCount = SlcNumUtil.getIntByValueStr(value);
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.numeric(checkNullOrEmpty: false),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "domain",
                        initialValue: getVm().sysTenant!.domain,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_sys_tenant_domain,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenant!.domain = value;
                          getVm().applyInfoChange();
                        },
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "address",
                        initialValue: getVm().sysTenant!.address,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_sys_tenant_address,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenant!.address = value;
                          getVm().applyInfoChange();
                        },
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "licenseNumber",
                        initialValue: getVm().sysTenant!.licenseNumber,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_sys_tenant_license_number,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenant!.licenseNumber = value;
                          getVm().applyInfoChange();
                        },
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "intro",
                        initialValue: getVm().sysTenant!.intro,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_sys_tenant_intro,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenant!.intro = value;
                          getVm().applyInfoChange();
                        },
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "remark",
                        initialValue: getVm().sysTenant!.remark,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_oss_config_remark,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysTenant!.remark = value;
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

class _TenantAddEditVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysTenant? sysTenant;

  bool _infoChange = false;

  void initVm({SysTenant? sysTenant}) {
    if (this.sysTenant != null) {
      return;
    }
    if (sysTenant == null) {
      sysTenant = SysTenant();
      ITreeDict<dynamic>? statusDict = GlobalVm().dictShareVm.findDict(
          LocalDictLib.CODE_SYS_NORMAL_DISABLE, LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL);
      sysTenant.status = statusDict?.tdDictValue;
      sysTenant.accountCount = 0;
      this.sysTenant = sysTenant;
      setLoadingStatusWithNotify(LoadingStatus.success, notify: false);
    } else {
      SysTenantRepository.getInfo(sysTenant.id!, defCancelToken).asStream().single.then(
          (intensifyEntity) {
        this.sysTenant = intensifyEntity.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: BaseDio.errProxyFunc(onError: (error) {
        if (error.isUnauthorized()) {
          return;
        }
        finish();
      }));
    }
  }

  void onSelectPackage() {
    //选择套餐
    pushNamed(TenantPackageSelectSinglePage.routeName, arguments: {
      ConstantBase.KEY_INTENT_TITLE: S.current.sys_label_sys_tenant_package_select
    }).then((result) {
      if (result != null) {
        setPackageInfo(result);
      }
    });
  }

  void setPackageInfo(SysTenantPackage? tenantPackage) {
    sysTenant!.packageId = tenantPackage?.packageId;
    sysTenant!.packageName = tenantPackage?.packageName;
    formOperate.patchField("packageName", sysTenant!.packageName);
    applyInfoChange();
    notifyListeners();
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

  // 是否可以返回
  bool canPop() {
    return !_infoChange;
  }

  //检查保存参数
  bool _checkSaveParams() {
    return formOperate.formBuilderState?.saveAndValidate() ?? false;
  }

  // 保存
  void onSave() {
    if (!_checkSaveParams()) {
      AppToastUtil.showToast(msg: S.current.app_label_form_check_hint);
      return;
    }
    showLoading(text: S.current.label_save_ing);
    SysTenantRepository.submit(sysTenant!, defCancelToken).then((value) {
      AppToastUtil.showToast(msg: S.current.label_submitted_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
      finish(result: sysTenant);
    }, onError: BaseDio.errProxyFunc(onError: (error) {
      dismissLoading();
    }));
  }

  //同步租户套餐
  void syncTenantPackage() {
    showLoading(text: S.current.sys_label_sys_tenant_sync_package_ing);
    SysTenantRepository.syncTenantPackage(
            sysTenant!.tenantId!, sysTenant!.packageId, defCancelToken)
        .then((result) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.sys_label_sys_tenant_sync_package_succeed);
    }, onError: (e) {
      dismissLoading();
      BaseDio.handlerErr(e, defErrMsg: S.current.sys_label_sys_tenant_sync_package_failed);
    });
  }

  //删除字典类型
  void onDelete() {
    showLoading(text: S.current.label_delete_ing);
    SysTenantRepository.delete(defCancelToken, id: sysTenant!.id).then((value) {
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
