import 'package:dio/dio.dart';
import 'package:fast/gen/fast_l10n.dart' as fast_l10n;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:boxes_flutter/flutter/slc/mvvm/status_widget.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/styles.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_util.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:bizapi/system/repository/local/local_dict_lib.dart';
import 'package:component/component/dict/utils/dict_ui_utils.dart';
import 'package:fast/fast/utils/app_toast.dart';
import 'package:fast/fast/vd/request_token_manager.dart';
import 'package:form_extra/form/fast_form_builder_field_option.dart';
import 'package:form_extra/form/fast_form_builder_text_field.dart';
import 'package:form_extra/form/form_operate_with_provider.dart';
import 'package:form_extra/form/input_decoration_utils.dart';
import 'package:system/gen/sys_l10n.dart';
import 'package:system/system/entity/sys_oss_config.dart';
import 'package:system/system/repository/remote/sys_oss_config_api.dart';

import 'package:base/base/api/base_dio.dart';
import 'package:base/base/ui/utils/fast_dialog_utils.dart';
import 'package:base/gen/base_l10n.dart' as base_l10n;
import 'package:bizapi/user/vm/user_share_vm.dart';
import 'package:component/component/dict/entity/tree_dict.dart';
import 'package:component/component/dict/vm/dict_share_vm.dart';

class OssConfigAddEditPage extends AppBaseStatelessWidget<_OssConfigAddEditVm> {
  static const String routeName = '/system/oss/config/add_edit';

  final SysOssConfig? sysOssConfig;

  OssConfigAddEditPage({super.key, this.sysOssConfig});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _OssConfigAddEditVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(sysOssConfig: sysOssConfig);
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
                    title: Text(sysOssConfig == null
                        ? S.current.sys_label_oss_config_add
                        : S.current.sys_label_oss_config_edit),
                    actions: [
                      if ((UserShareVm().hasPermiAny(["system:ossConfig:edit"]) &&
                              sysOssConfig != null) ||
                          (UserShareVm().hasPermiAny(["system:ossConfig:add"]) &&
                              sysOssConfig == null))
                        IconButton(
                            onPressed: () {
                              getVm().onSave();
                            },
                            icon: Icon(Icons.save)),
                      if (sysOssConfig != null &&
                          UserShareVm().hasPermiAny(["system:ossConfig:remove"]))
                        PopupMenuButton(itemBuilder: (context) {
                          return [
                            if (UserShareVm().hasPermiAny(["system:ossConfig:remove"]))
                              PopupMenuItem(
                                child: Text(fast_l10n.FastS.current.action_delete),
                                onTap: () {
                                  FastDialogUtils.showDelConfirmDialog(context,
                                      contentText: TextUtil.format(
                                          S.current.sys_label_oss_config_del_prompt,
                                          [sysOssConfig!.configKey])).then((confirm) {
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
                        name: "configKey",
                        initialValue: getVm().sysOssConfig!.configKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label:
                                InputDecUtils.getRequiredLabel(S.current.sys_label_oss_config_key),
                            hintText: base_l10n.BaseS.current.ab_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysOssConfig!.configKey = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "endpoint",
                        initialValue: getVm().sysOssConfig!.endpoint,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_oss_config_visit_site),
                            hintText: base_l10n.BaseS.current.ab_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysOssConfig!.endpoint = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "domain",
                        initialValue: getVm().sysOssConfig!.domain,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_oss_config_custom_domain,
                            hintText: base_l10n.BaseS.current.ab_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysOssConfig!.domain = value;
                          getVm().applyInfoChange();
                        },
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "accessKey",
                        initialValue: getVm().sysOssConfig!.accessKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_oss_config_access_key),
                            hintText: base_l10n.BaseS.current.ab_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysOssConfig!.accessKey = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "secretKey",
                        initialValue: getVm().sysOssConfig!.secretKey,
                        minLines: 1,
                        maxLines: 5,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_oss_config_secret_key),
                            hintText: base_l10n.BaseS.current.ab_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysOssConfig!.secretKey = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "bucketName",
                        initialValue: getVm().sysOssConfig!.bucketName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_oss_config_bucket_name),
                            hintText: base_l10n.BaseS.current.ab_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysOssConfig!.bucketName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "prefix",
                        initialValue: getVm().sysOssConfig!.prefix,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_oss_config_prefix,
                            hintText: base_l10n.BaseS.current.ab_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysOssConfig!.prefix = value;
                          getVm().applyInfoChange();
                        },
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderRadioGroup<OptionVL<String>>(
                        name: "isHttps",
                        initialValue: DictUiUtils.dict2OptionVL(DictShareVm().findDict(
                            LocalDictLib.CODE_SYS_YES_NO, getVm().sysOssConfig!.isHttps,
                            defDictKey: LocalDictLib.KEY_SYS_YES_NO_N)),
                        options: DictUiUtils.dictList2FromOption(
                            DictShareVm().dictMap[LocalDictLib.CODE_SYS_YES_NO]!),
                        decoration:
                            MyInputDecoration(labelText: S.current.sys_label_oss_config_is_https),
                        onChanged: (value) {
                          getVm().applyInfoChange();
                          getVm().sysOssConfig!.isHttps = value?.value;
                          getVm().notifyListeners();
                        }),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderRadioGroup<OptionVL<String>>(
                        name: "accessPolicy",
                        initialValue: DictUiUtils.dict2OptionVL(DictShareVm().findDict(
                            LocalDictLib.CODE_ACCESS_POLICY_TYPE,
                            getVm().sysOssConfig!.accessPolicy,
                            defDictKey: LocalDictLib.KEY_ACCESS_POLICY_TYPE_PUBLIC)),
                        options: DictUiUtils.dictList2FromOption(
                            DictShareVm().dictMap[LocalDictLib.CODE_ACCESS_POLICY_TYPE]!),
                        decoration: MyInputDecoration(
                            labelText: S.current.sys_label_oss_config_bucket_permissions_name),
                        onChanged: (value) {
                          getVm().applyInfoChange();
                          getVm().sysOssConfig!.accessPolicy = value?.value;
                          getVm().notifyListeners();
                        }),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "region",
                        initialValue: getVm().sysOssConfig!.region,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_oss_config_region,
                            hintText: base_l10n.BaseS.current.ab_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysOssConfig!.region = value;
                          getVm().applyInfoChange();
                        },
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "remark",
                        initialValue: getVm().sysOssConfig!.remark,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_oss_config_remark,
                            hintText: base_l10n.BaseS.current.ab_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysOssConfig!.remark = value;
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
              title: Text(fast_l10n.FastS.current.label_prompt),
              content: Text(base_l10n.BaseS.current.ab_label_data_save_prompt),
              actions: FastDialogUtils.getCommonlyAction(context,
                  positiveText: fast_l10n.FastS.current.action_exit, positiveLister: () {
                Navigator.pop(context);
                getVm().abandonEdit();
              }));
        });
  }
}

class _OssConfigAddEditVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysOssConfig? sysOssConfig;

  bool _infoChange = false;

  void initVm({SysOssConfig? sysOssConfig}) {
    if (this.sysOssConfig != null) {
      return;
    }
    if (sysOssConfig == null) {
      sysOssConfig = SysOssConfig();
      ITreeDict<dynamic>? statusDict =
          DictShareVm().findDict(LocalDictLib.CODE_SYS_YES_NO, LocalDictLib.KEY_SYS_YES_NO_N);
      sysOssConfig.isHttps = statusDict?.tdDictValue;
      ITreeDict<dynamic>? accessPolicyDict = DictShareVm().findDict(
          LocalDictLib.CODE_ACCESS_POLICY_TYPE, LocalDictLib.KEY_ACCESS_POLICY_TYPE_PUBLIC);
      sysOssConfig.accessPolicy = accessPolicyDict?.tdDictValue;
      this.sysOssConfig = sysOssConfig;

      setLoadingStatusWithNotify(LoadingStatus.success, notify: false);
    } else {
      SysOssConfigRepository.getInfo(sysOssConfig.ossConfigId!, defCancelToken)
          .asStream()
          .single
          .then((intensifyEntity) {
        this.sysOssConfig = intensifyEntity.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: BaseDio.errProxyFunc(onError: (error) {
        if (error.isUnauthorized()) {
          return;
        }
        finish();
      }));
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
      AppToastUtil.showToast(msg: base_l10n.BaseS.current.ab_label_form_check_hint);
      return;
    }
    showLoading(text: fast_l10n.FastS.current.label_save_ing);
    SysOssConfigRepository.submit(sysOssConfig!, defCancelToken).then((value) {
      AppToastUtil.showToast(msg: fast_l10n.FastS.current.label_submitted_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
      finish(result: sysOssConfig);
    }, onError: BaseDio.errProxyFunc(onError: (error) {
      dismissLoading();
    }));
  }

  //删除字典类型
  void onDelete() {
    showLoading(text: fast_l10n.FastS.current.label_delete_ing);
    SysOssConfigRepository.delete(defCancelToken, id: sysOssConfig!.ossConfigId).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: fast_l10n.FastS.current.label_delete_success);
      finish(result: true);
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: fast_l10n.FastS.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}
