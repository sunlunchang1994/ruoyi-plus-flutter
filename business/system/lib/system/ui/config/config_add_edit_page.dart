import 'package:dio/dio.dart';
import 'package:fast/fast/utils/app_toast.dart';
import 'package:fast/fast/vd/request_token_manager.dart';
import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:boxes_flutter/flutter/slc/mvvm/status_widget.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/styles.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_util.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_extra/form/fast_form_builder_field_option.dart';
import 'package:form_extra/form/fast_form_builder_text_field.dart';
import 'package:form_extra/form/form_operate_with_provider.dart';
import 'package:form_extra/form/input_decoration_utils.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:base/base/vm/global_vm.dart';
import 'package:bizapi/system/entity/sys_config.dart';
import 'package:bizapi/system/repository/local/local_dict_lib.dart';
import 'package:component/component/dict/utils/dict_ui_utils.dart';

import '../../../../../../gen/app_l10n.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/ui/utils/fast_dialog_utils.dart';
import '../../../../feature/bizapi/user/vm/user_share_vm.dart';
import '../../../../feature/component/dict/vm/dict_share_vm.dart';
import '../../repository/remote/sys_config_api.dart';

class ConfigAddEditPage extends AppBaseStatelessWidget<_ConfigAddEditVm> {
  static const String routeName = '/system/config/add_edit';

  final SysConfig? sysConfig;

  ConfigAddEditPage({super.key, this.sysConfig});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _ConfigAddEditVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(sysConfig: sysConfig);
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
                    title: Text(sysConfig == null
                        ? S.current.sys_label_config_add
                        : S.current.sys_label_config_edit),
                    actions: [
                      if ((UserShareVm().hasPermiAny(["system:config:edit"]) &&
                              sysConfig != null) ||
                          (UserShareVm().hasPermiAny(["system:config:add"]) && sysConfig == null))
                        IconButton(
                            onPressed: () {
                              getVm().onSave();
                            },
                            icon: Icon(Icons.save)),
                      if (sysConfig != null && UserShareVm().hasPermiAny(["system:config:remove"]))
                        PopupMenuButton(itemBuilder: (context) {
                          return [
                            if (UserShareVm().hasPermiAny(["system:config:remove"]))
                              PopupMenuItem(
                                child: Text(FastS.current.action_delete),
                                onTap: () {
                                  FastDialogUtils.showDelConfirmDialog(context,
                                      contentText: TextUtil.format(
                                          S.current.sys_label_config_del_prompt,
                                          [sysConfig?.configName ?? ""])).then((confirm) {
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
                        name: "configName",
                        initialValue: getVm().sysConfig!.configName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(S.current.sys_label_config_name),
                            hintText: FastS.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysConfig!.configName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "configKey",
                        initialValue: getVm().sysConfig!.configKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(S.current.sys_label_config_key),
                            hintText: FastS.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysConfig!.configKey = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "configValue",
                        initialValue: getVm().sysConfig!.configValue,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(S.current.sys_label_config_value),
                            hintText: FastS.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysConfig!.configValue = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderRadioGroup<OptionVL<String>>(
                        name: "configTypeName",
                        initialValue: DictUiUtils.dict2OptionVL(DictShareVm().findDict(
                            LocalDictLib.CODE_SYS_YES_NO, getVm().sysConfig!.configType,
                            defDictKey: LocalDictLib.KEY_SYS_YES_NO_N)),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        options: DictUiUtils.dictList2FromOption(
                            DictShareVm().dictMap[LocalDictLib.CODE_SYS_YES_NO]!),
                        decoration: MyInputDecoration(labelText: S.current.sys_label_config_type),
                        onChanged: (value) {
                          getVm().applyInfoChange();
                          getVm().sysConfig!.configType = value?.value;
                          getVm().notifyListeners();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ])),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "remark",
                        maxLines: 5,
                        minLines: 1,
                        initialValue: getVm().sysConfig!.remark,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: FastS.current.app_label_remark,
                            hintText: FastS.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          //此处需改成选择的
                          getVm().applyInfoChange();
                          getVm().sysConfig!.remark = value;
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
              title: Text(FastS.current.label_prompt),
              content: Text(FastS.current.app_label_data_save_prompt),
              actions: FastDialogUtils.getCommonlyAction(context,
                  positiveText: FastS.current.action_exit, positiveLister: () {
                Navigator.pop(context);
                getVm().abandonEdit();
              }));
        });
  }
}

class _ConfigAddEditVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysConfig? sysConfig;

  bool _infoChange = false;

  void initVm({SysConfig? sysConfig}) {
    if (this.sysConfig != null) {
      return;
    }
    if (sysConfig == null) {
      sysConfig = SysConfig();
      this.sysConfig = sysConfig;
      setLoadingStatusWithNotify(LoadingStatus.success, notify: false);
    } else {
      SysConfigRepository.getInfo(sysConfig.configId!, defCancelToken).asStream().single.then(
          (intensifyEntity) {
        this.sysConfig = intensifyEntity.data;
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
      AppToastUtil.showToast(msg: FastS.current.app_label_form_check_hint);
      return;
    }
    showLoading(text: FastS.current.label_save_ing);
    SysConfigRepository.submit(sysConfig!, defCancelToken).then((value) {
      AppToastUtil.showToast(msg: FastS.current.label_submitted_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
      finish(result: sysConfig);
    }, onError: BaseDio.errProxyFunc(onError: (error) {
      dismissLoading();
    }));
  }

  //删除参数配置
  void onDelete() {
    showLoading(text: FastS.current.label_delete_ing);
    SysConfigRepository.delete(defCancelToken, configId: sysConfig!.configId).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: FastS.current.label_delete_success);
      finish(result: true);
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: FastS.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}
