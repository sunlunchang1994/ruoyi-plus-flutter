import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/fast_form_builder_field_option.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/fast_form_builder_text_field.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/input_decoration_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/user_api.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_list_single_select_page.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';
import '../../../../feature/bizapi/user/entity/user.dart';
import '../../../../feature/component/dict/entity/tree_dict.dart';
import '../../../../feature/component/dict/repository/local/local_dict_lib.dart';
import '../../../../feature/component/dict/utils/dict_ui_utils.dart';

class UserAddEditPage extends AppBaseStatelessWidget<_UserAddEditVm> {
  static const String routeName = '/system/user/add_edit';

  final User? user;

  UserAddEditPage(this.user, {super.key}) {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _UserAddEditVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
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
              child: Scaffold(
                  appBar: AppBar(
                    title:
                        Text(user == null ? S.current.user_label_user_add : S.current.user_label_user_edit),
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
    return KeyboardAvoider(
        autoScroll: true,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
            child: FormBuilder(
                key: getVm().formOperate.formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                onChanged: () {
                  //这里要不要应该无所谓，因为本表单的数据存在vm的实例中
                  //getVm()._formKey.currentState?.save();
                },
                child: Column(
                  children: [
                    MyFormBuilderTextField(
                        name: "nikeName",
                        initialValue: getVm().userInfo.nickName,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_nike_name,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().userInfo.nickName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderSelect(
                        name: "deptName",
                        initialValue: getVm().userInfo.deptName,
                        onTap: () {
                          getVm().onSelectOwnerDept();
                        },
                        decoration: MySelectDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_user_owner_dept,
                            hintText: S.current.app_label_please_choose,
                            border: const UnderlineInputBorder()),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "phonenumber",
                        initialValue: getVm().userInfo.phonenumber,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_phone_number,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().userInfo.phonenumber = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.phoneNumber(checkNullOrEmpty: false),
                        ]),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "email",
                        initialValue: getVm().userInfo.email,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_mailbox,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().userInfo.email = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.email(checkNullOrEmpty: false),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "userName",
                        initialValue: getVm().userInfo.userName,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_user_name,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().userInfo.userName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "password",
                        initialValue: getVm().userInfo.password,
                        obscureText: true,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_password,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().userInfo.password = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderSelect(
                        name: "sex",
                        initialValue: getVm().userInfo.sex,
                        onTap: () {
                          _showSelectSexDialog(context);
                        },
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_sex,
                            hintText: S.current.app_label_please_choose,
                            border: const UnderlineInputBorder(),
                            suffixIcon:
                                NqSelector<_UserAddEditVm, String?>(builder: (context, value, child) {
                              return InputDecorationUtils.autoClearSuffixBySelectVal(value, onPressed: () {
                                getVm().setSelectSex(null);
                              });
                            }, selector: (context, vm) {
                              return vm.userInfo.sex;
                            })),
                        textInputAction: TextInputAction.next),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderRadioGroup<OptionVL<String>>(
                        name: "status",
                        initialValue: DictUiUtils.dict2OptionVL(LocalDictLib.findDictByCodeKey(
                            LocalDictLib.CODE_SYS_NORMAL_DISABLE, getVm().userInfo.status)),
                        decoration: MyInputDecoration(labelText: S.current.user_label_status),
                        options:
                            DictUiUtils.dictList2FromOption(LocalDictLib.DICT_MAP[LocalDictLib.CODE_SYS_NORMAL_DISABLE]!),
                        onChanged: (value) {
                          //此处需改成选择的
                          getVm().applyInfoChange();
                          getVm().userInfo.status = value?.value;
                        },
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required()])),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "remark",
                        initialValue: getVm().userInfo.remark,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.app_label_remark,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          //此处需改成选择的
                          getVm().applyInfoChange();
                          getVm().userInfo.remark = value;
                        }),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  ],
                ))));
  }

  ///显示选择性别对话框
  void _showSelectSexDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          List<SimpleDialogOption> dialogItem = DictUiUtils.dictList2DialogItem(
              context, LocalDictLib.DICT_MAP[LocalDictLib.CODE_SEX]!, (value) {
            //选择后设置性别
            getVm().setSelectSex(value);
          });
          return SimpleDialog(title: Text(S.current.user_label_sex_select_prompt), children: dialogItem);
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
              actions: FastDialogUtils.getCommonlyAction(context, positiveText: S.current.action_exit,
                  positiveLister: () {
                Navigator.pop(context);
                getVm().abandonEdit();
              }));
        });
  }
}

class _UserAddEditVm extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();

  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  late User userInfo;

  bool _infoChange = false;

  void initVm(User? user) {
    if (TextUtil.isEmpty(user?.deptName)) {
      this.userInfo = User();
      setLoadingStatus(LoadingStatus.success);
    } else {
      UserServiceRepository.getUserById(user!.userId!, cancelToken)
          .asStream()
          .map(DataTransformUtils.checkNullIe)
          .single
          .then((intensifyEntity) {
        this.userInfo = intensifyEntity.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: (e) {
        AppToastBridge.showToast(msg: S.current.user_label_user_info_not_found);
        finish();
      });
    }
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
    userInfo.deptId = dept?.deptId;
    userInfo.deptName = dept?.deptName;
    formOperate.patchField("deptName", userInfo.deptName);
    applyInfoChange();
  }

  //选择性别
  void setSelectSex(ITreeDict<dynamic>? item) {
    userInfo.sex = item?.tdDictValue;
    userInfo.sexName = item?.tdDictLabel;
    formOperate.patchField("sex", userInfo.sexName);
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

  bool canPop() {
    return !_infoChange;
  }

  void onSave() {}
}
