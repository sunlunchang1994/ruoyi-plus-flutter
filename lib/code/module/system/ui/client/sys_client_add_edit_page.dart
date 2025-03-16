import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/slc_num_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/entity/tree_dict.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/fast_form_builder_text_field.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/form_builder_flow_tag.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/input_decoration_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_client.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../feature/component/dict/utils/dict_ui_utils.dart';
import '../../../../lib/fast/widget/form/fast_form_builder_field_option.dart';
import '../../repository/remote/sys_client_api.dart';
import '../dict/data/dict_data_list_multiple_choices_dialog.dart';

class SysClientAddEditPage extends AppBaseStatelessWidget<_SysClientAddEditVm> {
  static const String routeName = '/system/client/add_edit';

  final SysClient? sysClient;

  SysClientAddEditPage({super.key, this.sysClient});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _SysClientAddEditVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(sysClient: sysClient);
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
                _showPromptSaveDialog(context);
              },
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(sysClient == null
                        ? S.current.sys_label_sys_client_add
                        : S.current.sys_label_sys_client_edit),
                    actions: [
                      IconButton(
                          onPressed: () {
                            getVm().onSave();
                          },
                          icon: Icon(Icons.save))
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
                onChanged: () {},
                child: Column(
                  children: [
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens8),
                    MyFormBuilderTextField(
                        name: "clientKey",
                        initialValue: getVm().sysClient!.clientKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_sys_client_client_key),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysClient!.clientKey = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "clientSecret",
                        initialValue: getVm().sysClient!.clientSecret,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_sys_client_client_secret),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysClient!.clientSecret = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderFlowTag<String>(
                        name: "grantType",
                        initialValue: getVm().sysClient!.grantTypeList,
                        deleteIcon: Icon(Icons.clear),
                        onDeleted: (item) {
                          getVm().remoteSelectGrantType(item);
                        },
                        builderChipOption: (value) {
                          return FormBuilderChipOption(
                              value: value,
                              child: Text(
                                  DictUiUtils.findDictByDataList(getVm().grantTypeList, value)
                                          ?.tdDictLabel ??
                                      ""));
                        },
                        spacing: 10,
                        onTap: () {
                          _showSelectGrantTypeDialog(context);
                        },
                        decoration: MySelectDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_sys_client_grant_type),
                            hintText: S.current.app_label_please_choose,
                            border: UnderlineInputBorder(),
                            suffixIcon: InputDecUtils.getSuffixAction(InputDecUtils.moreIcon, () {
                              _showSelectGrantTypeDialog(context);
                            }))),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderFlowTag<String>(
                        name: "deviceType",
                        initialValue: getVm().sysClient!.deviceTypeList,
                        deleteIcon: Icon(Icons.clear),
                        onDeleted: (item) {
                          getVm().remoteSelectDeviceType(item);
                        },
                        builderChipOption: (value) {
                          return FormBuilderChipOption(
                              value: value,
                              child: Text(
                                  DictUiUtils.findDictByDataList(getVm().deviceTypeList, value)
                                          ?.tdDictLabel ??
                                      ""));
                        },
                        spacing: 10,
                        onTap: () {
                          _showSelectDeviceTypeDialog(context);
                        },
                        decoration: MySelectDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.sys_label_sys_client_device_type),
                            hintText: S.current.app_label_please_choose,
                            border: UnderlineInputBorder(),
                            suffixIcon: InputDecUtils.getSuffixAction(InputDecUtils.moreIcon, () {
                              _showSelectDeviceTypeDialog(context);
                            }))),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "activeTimeout",
                        initialValue: getVm().sysClient!.activeTimeout?.toString(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_sys_client_active_timeout,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysClient!.activeTimeout = SlcNumUtil.getIntByValueStr(value);
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.integer(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "timeout",
                        initialValue: getVm().sysClient!.timeout?.toString(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.sys_label_sys_client_timeout,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysClient!.timeout = SlcNumUtil.getIntByValueStr(value);
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.integer(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderRadioGroup<OptionVL<String>>(
                        name: "status",
                        initialValue: DictUiUtils.dict2OptionVL(GlobalVm().dictShareVm.findDict(
                            LocalDictLib.CODE_SYS_NORMAL_DISABLE, getVm().sysClient!.status,
                            defDictKey: LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL)),
                        options: DictUiUtils.dictList2FromOption(
                            globalVm.dictShareVm.dictMap[LocalDictLib.CODE_SYS_NORMAL_DISABLE]!),
                        decoration:
                            MyInputDecoration(labelText: S.current.sys_label_sys_client_status),
                        onChanged: (value) {
                          getVm().applyInfoChange();
                          getVm().sysClient!.status = value?.value;
                          getVm().notifyListeners();
                        }),
                  ],
                ))));
  }

  void _showSelectGrantTypeDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return DictDataListMultipleChoicesDialog.getDictDataSelectDialog(
              S.current.sys_label_sys_client_grant_type_select, LocalDictLib.CODE_SYS_GRANT_TYPE,
              selectedData: getVm().sysClient!.grantTypeList);
        }).then((result) {
      if (result != null) {
        getVm().setSelectGrantType(result);
      }
    });
  }

  void _showSelectDeviceTypeDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return DictDataListMultipleChoicesDialog.getDictDataSelectDialog(
              S.current.sys_label_sys_client_device_type_select, LocalDictLib.CODE_SYS_DEVICE_TYPE,
              selectedData: getVm().sysClient!.deviceTypeList);
        }).then((result) {
      if (result != null) {
        getVm().setSelectDeviceType(result);
      }
    });
  }

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

class _SysClientAddEditVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysClient? sysClient;

  bool _infoChange = false;

  //字典数据
  List<ITreeDict<dynamic>>? grantTypeList =
      GlobalVm().dictShareVm.dictMap[LocalDictLib.CODE_SYS_GRANT_TYPE];
  List<ITreeDict<dynamic>>? deviceTypeList =
      GlobalVm().dictShareVm.dictMap[LocalDictLib.CODE_SYS_DEVICE_TYPE];

  void initVm({SysClient? sysClient}) {
    if (this.sysClient != null) {
      return;
    }
    if (sysClient == null) {
      sysClient = SysClient();
      sysClient.status = LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL;
      this.sysClient = sysClient;
      setLoadingStatusWithNotify(LoadingStatus.success, notify: false);
    } else {
      SysClientRepository.getInfo(sysClient.id!, defCancelToken).asStream().single.then(
          (intensifyEntity) {
        this.sysClient = intensifyEntity.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: (e) {
        BaseDio.handlerError(e);
        finish();
      });
    }
  }

  //移除某个类型
  void remoteSelectGrantType(String value) {
    List<String>? grantTypeValues = sysClient!.grantTypeList;
    grantTypeValues?.remove(value);
    sysClient!.grantTypeList = grantTypeValues;
    formOperate.patchField("grantType", sysClient!.grantTypeList);
    applyInfoChange();
  }

  //设置类型
  void setSelectGrantType(List<ITreeDict<dynamic>> dictList) {
    sysClient!.grantType = dictList.map((item) {
      return item.tdDictValue;
    }).join(TextUtil.COMMA);
    formOperate.patchField("grantType", sysClient!.grantTypeList);
    applyInfoChange();
  }

  //移除某个设备类型
  void remoteSelectDeviceType(String value) {
    List<String>? deviceTypeValues = sysClient!.deviceTypeList;
    deviceTypeValues?.remove(value);
    sysClient!.deviceTypeList = deviceTypeValues;
    formOperate.patchField("deviceType", sysClient!.deviceTypeList);
    applyInfoChange();
  }

  //设置设备类型
  void setSelectDeviceType(List<ITreeDict<dynamic>> dictList) {
    sysClient!.deviceType = dictList.map((item) {
      return item.tdDictValue;
    }).join(TextUtil.COMMA);
    formOperate.patchField("deviceType", sysClient!.deviceTypeList);
    applyInfoChange();
  }

  void applyInfoChange() {
    _infoChange = true;
  }

  void abandonEdit() {
    _infoChange = false;
    finish();
  }

  bool canPop() {
    return !_infoChange;
  }

  bool _checkSaveParams() {
    return formOperate.formBuilderState?.saveAndValidate() ?? false;
  }

  void onSave() {
    if (!_checkSaveParams()) {
      AppToastUtil.showToast(msg: S.current.app_label_form_check_hint);
      return;
    }
    showLoading(text: S.current.label_save_ing);
    SysClientRepository.submit(sysClient!, defCancelToken).then((value) {
      AppToastUtil.showToast(msg: S.current.label_submitted_success);
      dismissLoading();
      _infoChange = false;
      finish(result: sysClient);
    }, onError: (error) {
      dismissLoading();
      BaseDio.handlerError(error);
    });
  }
}
