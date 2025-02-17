import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/utils/fast_dialog_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/utils/dict_ui_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/fast_form_builder_field_option.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/dept_api.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/ui/app_mvvm.dart';
import '../../../../lib/fast/widget/form/fast_form_builder_text_field.dart';

///部门信息新增修改
class DeptAddEditPage extends AppBaseStatelessWidget<_DeptAddEditModel> {
  static const String routeName = '/system/dept/add_edit';

  final Dept? deptInfo;
  final Dept? parentDept;

  DeptAddEditPage({super.key, this.deptInfo, this.parentDept});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _DeptAddEditModel(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm(deptInfo, parentDept);
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
                    title: Text(deptInfo == null
                        ? S.current.user_label_dept_add
                        : S.current.user_label_dept_edit),
                    actions: [
                      IconButton(
                          onPressed: () {
                            getVm().save();
                          },
                          icon: const Icon(Icons.save))
                    ]),
                body: getStatusBody(context)));
      },
    );
  }

  @override
  Widget getSuccessWidget(BuildContext context,
      {Map<String, dynamic>? params}) {
    return KeyboardAvoider(
        autoScroll: true,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
            child: FormBuilder(
                child: Column(
              children: getFormItem(),
            ))));
  }

  //获取表单的item
  List<Widget> getFormItem() {
    List<Widget> formItemArray = List.empty(growable: true);
    //父节点id不是顶级父节点则展示选择父节点控件
    if (ConstantBase.VALUE_PARENT_ID_DEF != getVm().deptInfo?.parentId) {
      formItemArray.add(Selector<_DeptAddEditModel, String?>(
          builder: (context, value, child) {
        return MyFormBuilderSelect(
            name: "parentName",
            controller: TextEditingController(text: value),
            onTap: () => getVm()._onSelectTopDept(),
            decoration: MySelectDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: S.current.user_label_dept_parent_name,
                hintText: S.current.app_label_please_choose,
                border:
                    const UnderlineInputBorder() /*border: InputBorder.none*/),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            textInputAction: TextInputAction.next);
      }, selector: (context, vm) {
        return vm.deptInfo!.parentName;
      }, shouldRebuild: (oldVal, newVal) {
        return oldVal != newVal;
      }));
      formItemArray.add(SlcStyles.getSizedBox(height: SlcDimens.appDimens16));
    }
    formItemArray.addAll(<Widget>{
      Selector<_DeptAddEditModel, String?>(builder: (context, value, child) {
        return FormBuilderTextField(
            name: "deptName",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: TextEditingController(text: value),
            decoration: MyInputDecoration(
                contentPadding: EdgeInsets.zero,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: S.current.user_label_nike_name,
                hintText: S.current.app_label_please_input,
                border: const UnderlineInputBorder()),
            onChanged: (value) {
              getVm().applyInfoChange();
              getVm().deptInfo!.deptName = value;
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
            textInputAction: TextInputAction.next);
      }, selector: (context, vm) {
        return vm.deptInfo!.deptName;
      }, shouldRebuild: (oldVal, newVal) {
        return oldVal != newVal;
      }),
      SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
      Selector<_DeptAddEditModel, String?>(builder: (context, value, child) {
        return FormBuilderTextField(
            name: "deptCategory",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: TextEditingController(text: value),
            decoration: MyInputDecoration(
                contentPadding: EdgeInsets.zero,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: S.current.user_label_dept_category,
                hintText: S.current.app_label_please_input,
                border: const UnderlineInputBorder()),
            onChanged: (value) {
              getVm().applyInfoChange();
              getVm().deptInfo!.deptCategory = value;
            },
            textInputAction: TextInputAction.next);
      }, selector: (context, vm) {
        return vm.deptInfo!.deptCategory;
      }, shouldRebuild: (oldVal, newVal) {
        return oldVal != newVal;
      }),
      SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
      Selector<_DeptAddEditModel, String?>(builder: (context, value, child) {
        return FormBuilderTextField(
          name: "orderNum",
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: TextEditingController(text: value),
          decoration: MyInputDecoration(
              contentPadding: EdgeInsets.zero,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: S.current.user_label_dept_show_sort,
              hintText: S.current.app_label_please_input,
              border: const UnderlineInputBorder()),
          onChanged: (value) {
            getVm().applyInfoChange();
            getVm().deptInfo!.orderNum =
                value == null ? null : int.tryParse(value);
          },
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ]),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        );
      }, selector: (context, vm) {
        int? orderNum = vm.deptInfo!.orderNum;
        return orderNum == null ? "0" : orderNum.toString();
      }, shouldRebuild: (oldVal, newVal) {
        return oldVal != newVal;
      }),
      SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
      Selector<_DeptAddEditModel, String?>(builder: (context, value, child) {
        return MyFormBuilderSelect(
            name: "leaderName",
            controller: TextEditingController(text: value),
            onTap: () => getVm()._onSelectTopDept(),
            decoration: MySelectDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: S.current.user_label_dept_leader,
              hintText: S.current.app_label_please_choose,
              border: const UnderlineInputBorder(),
              suffixIcon: TextUtil.isNotEmpty(getVm().deptInfo!.leaderName)
                  ? IconButton(
                      constraints: BoxConstraints(),
                      visualDensity: VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity),
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        //TODO 清除
                      },
                    )
                  : const Icon(Icons.chevron_right),
            ),
            textInputAction: TextInputAction.next);
      }, selector: (context, vm) {
        return vm.deptInfo!.leaderName;
      }, shouldRebuild: (oldVal, newVal) {
        return oldVal != newVal;
      }),
      SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
      Selector<_DeptAddEditModel, String?>(builder: (context, value, child) {
        return FormBuilderTextField(
            name: "phone",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: TextEditingController(text: value),
            decoration: MyInputDecoration(
                contentPadding: EdgeInsets.zero,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: S.current.user_label_dept_contact_number,
                hintText: S.current.app_label_please_input,
                border: const UnderlineInputBorder()),
            onChanged: (value) {
              //此处需改成选择的
              getVm().applyInfoChange();
              getVm().deptInfo!.phone = value;
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.phoneNumber(checkNullOrEmpty: false),
            ]),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next);
      }, selector: (context, vm) {
        return vm.deptInfo!.phone;
      }, shouldRebuild: (oldVal, newVal) {
        return oldVal != newVal;
      }),
      SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
      Selector<_DeptAddEditModel, String?>(builder: (context, value, child) {
        return FormBuilderTextField(
            name: "email",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: TextEditingController(text: value),
            decoration: MyInputDecoration(
                contentPadding: EdgeInsets.zero,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: S.current.user_label_dept_contact_email,
                hintText: S.current.app_label_please_input,
                border: const UnderlineInputBorder()),
            onChanged: (value) {
              //此处需改成选择的
              getVm().applyInfoChange();
              getVm().deptInfo!.email = value;
            },
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.email(checkNullOrEmpty: false),
            ]),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next);
      }, selector: (context, vm) {
        return vm.deptInfo!.email;
      }, shouldRebuild: (oldVal, newVal) {
        return oldVal != newVal;
      }),
      SlcStyles.getSizedBox(height: SlcDimens.appDimens8),
      Selector<_DeptAddEditModel, String?>(builder: (context, value, child) {
        return FormBuilderRadioGroup<OptionVL<String>>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration:
              InputDecoration(labelText: S.current.user_label_dept_status),
          name: "status",
          // initialValue: const ['Dart'],
          options: DictUiUtils.dict2FromOption(context, LocalDictLib.DICT_MAP[LocalDictLib.CODE_SYS_NORMAL_DISABLE]!),
          onChanged: (value) {
            //此处需改成选择的
            getVm().applyInfoChange();
            getVm().deptInfo!.status = value?.label;
          },
          /*separator: const VerticalDivider(
            width: 10,
            thickness: 5,
            color: Colors.red,
          ),*/
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required()
          ]),
        );
      }, selector: (context, vm) {
        return vm.deptInfo!.status;
      }, shouldRebuild: (oldVal, newVal) {
        return oldVal != newVal;
      })
    });
    return formItemArray;
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

class _DeptAddEditModel extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();

  Dept? deptInfo;

  bool _infoChange = false;

  void initVm(Dept? deptInfo, Dept? parentDept) {
    if (deptInfo == null && parentDept == null) {
      AppToastBridge.showToast(
          msg: S.current.label_select_parameter_is_missing);
      finish();
      return;
    }
    if (deptInfo == null) {
      this.deptInfo = Dept();
      this.deptInfo!.parentId = parentDept!.deptId;
      this.deptInfo!.parentName = parentDept.deptName;
      setLoadingStatus(LoadingStatus.success);
    } else {
      DeptRepository.getInfo(deptInfo.deptId!, cancelToken).then((result) {
        this.deptInfo = result.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        AppToastBridge.showToast(msg: resultEntity.msg);
        finish();
      });
    }
  }

  //选择父节点
  void _onSelectTopDept() {}

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
    return true;
  }

  void save() {
    if (!_checkSaveParams()) {
      AppToastBridge.showToast(
          msg: S.current.app_label_required_information_cannot_be_empty);
      return;
    }
    showLoading(text: S.current.label_save_ing);
    /*UserProfileServiceRepository.updateProfile(
            userInfo.nickName!, userInfo.email!, userInfo.phonenumber!, userInfo.sex!)
        .then((result) {
      //更新成功了把当前的值设置给全局（此处应该重新调用获取用户信息的接口重新赋值，暂时先这么写）
      GlobalVm().userShareVm.userInfoOf.value!.user = userInfo;
      AppToastBridge.showToast(msg: S.current.toast_edit_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
    }, onError: (e) {
      AppToastBridge.showToast(msg: S.current.toast_edit_failure);
      dismissLoading();
    });*/
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
