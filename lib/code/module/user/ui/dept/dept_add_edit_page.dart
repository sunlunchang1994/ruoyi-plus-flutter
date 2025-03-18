import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/utils/fast_dialog_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/user.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/utils/dict_ui_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/fast_form_builder_field_option.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/dept_api.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_list_select_single_page.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/ui/app_mvvm.dart';
import '../../../../base/vm/global_vm.dart';
import '../../../../lib/form/fast_form_builder_text_field.dart';
import '../../../../lib/form/input_decoration_utils.dart';
import '../../config/constant_user.dart';
import '../user/user_list_select_by_dept_page.dart';
import '../user/user_list_select_single_page.dart';

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
                            getVm().onSave();
                          },
                          icon: Icon(Icons.save)),
                      if (deptInfo != null)
                        PopupMenuButton(itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text(S.current.action_delete),
                              onTap: () {
                                FastDialogUtils.showDelConfirmDialog(context,
                                    contentText: TextUtil.format(
                                        S.current.user_label_dept_del_prompt,
                                        [deptInfo?.deptName ?? ""])).then((confirm) {
                                  if (confirm == true) {
                                    getVm().onDelete();
                                  }
                                });
                              },
                            )
                          ];
                        })
                    ]),
                body: getStatusBody(context)));
      },
    );
  }

  @override
  Widget getSuccessWidget(BuildContext context, {Map<String, dynamic>? params}) {
    return KeyboardAvoider(
        autoScroll: true,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
            child: FormBuilder(
                key: getVm()._formKey,
                onChanged: () {
                  //这里要不要应该无所谓，因为本表单的数据存在vm的实例中
                  //getVm()._formKey.currentState?.save();
                },
                child: Column(
                  children: getFormItem(),
                ))));
  }

  //获取表单的item
  List<Widget> getFormItem() {
    List<Widget> formItemArray = List.empty(growable: true);
    formItemArray.add(ThemeUtil.getSizedBox(height: SlcDimens.appDimens8));
    //父节点id不是顶级父节点则展示选择父节点控件
    if (ConstantBase.VALUE_PARENT_ID_DEF != getVm().deptInfo?.parentId) {
      formItemArray.add(MyFormBuilderSelect(
          name: "parentName",
          initialValue: getVm().deptInfo!.parentName,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: () => getVm().onSelectTopDept(),
          decoration: MySelectDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: InputDecUtils.getRequiredLabel(S.current.user_label_dept_parent_name),
              hintText: S.current.app_label_please_choose,
              border: const UnderlineInputBorder()),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
          textInputAction: TextInputAction.next));
      formItemArray.add(ThemeUtil.getSizedBox(height: SlcDimens.appDimens16));
    }
    formItemArray.addAll(<Widget>{
      FormBuilderTextField(
          name: "deptName",
          initialValue: getVm().deptInfo!.deptName,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: MyInputDecoration(
              contentPadding: EdgeInsets.zero,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: InputDecUtils.getRequiredLabel(S.current.user_label_dept_name),
              hintText: S.current.app_label_please_input,
              border: const UnderlineInputBorder()),
          onChanged: (value) {
            getVm().applyInfoChange();
            getVm().deptInfo!.deptName = value;
          },
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ]),
          textInputAction: TextInputAction.next),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
          name: "deptCategory",
          initialValue: getVm().deptInfo!.deptCategory,
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
          textInputAction: TextInputAction.next),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
        name: "orderNum",
        initialValue: () {
          int? orderNum = getVm().deptInfo!.orderNum;
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
          getVm().deptInfo!.orderNum = SlcNumUtil.getIntByValueStr(value, defValue: null);
        },
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.numeric(),
        ]),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
      ),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      MyFormBuilderSelect(
          name: "leaderName",
          initialValue: getVm().deptInfo!.leaderName,
          onTap: () => getVm().onSelectLeaderUser(),
          decoration: MySelectDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.current.user_label_dept_leader,
            hintText: S.current.app_label_please_choose,
            border: const UnderlineInputBorder(),
            suffixIcon: InputDecUtils.autoClearSuffixBySelect(
                TextUtil.isNotEmpty(getVm().deptInfo!.leaderName), onPressed: () {
              getVm().deptInfo?.leader = null;
              getVm().deptInfo?.leaderName = null;
              getVm().notifyListeners();
            }),
          ),
          textInputAction: TextInputAction.next),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
          name: "phone",
          initialValue: getVm().deptInfo!.phone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
          textInputAction: TextInputAction.next),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
          name: "email",
          initialValue: getVm().deptInfo!.email,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
          textInputAction: TextInputAction.next),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderRadioGroup<OptionVL<String>>(
        decoration: MyInputDecoration(labelText: S.current.user_label_dept_status),
        name: "status",
        initialValue: DictUiUtils.dict2OptionVL(GlobalVm().dictShareVm.findDict(
            LocalDictLib.CODE_SYS_NORMAL_DISABLE, getVm().deptInfo!.status,
            defDictKey: LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL)),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        options: DictUiUtils.dictList2FromOption(
            globalVm.dictShareVm.dictMap[LocalDictLib.CODE_SYS_NORMAL_DISABLE]!),
        onChanged: (value) {
          //此处需改成选择的
          getVm().applyInfoChange();
          getVm().deptInfo!.status = value?.value;
        },
        /*separator: const VerticalDivider(
            width: 10,
            thickness: 5,
            color: Colors.red,
          ),*/
        validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
      )
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

class _DeptAddEditModel extends AppBaseVm with CancelTokenAssist {
  final _formKey = GlobalKey<FormBuilderState>();

  Dept? deptInfo;

  bool _infoChange = false;

  void initVm(Dept? deptInfo, Dept? parentDept) {
    if (deptInfo == null && parentDept == null) {
      AppToastUtil.showToast(msg: S.current.label_select_parameter_is_missing);
      finish();
      return;
    }
    if (deptInfo == null) {
      this.deptInfo = Dept();
      //父部门不是跟节点则不赋值，让用户选择
      if (ConstantBase.VALUE_PARENT_ID_DEF != parentDept!.deptId) {
        this.deptInfo!.parentId = parentDept.deptId;
        this.deptInfo!.parentName = parentDept.deptName;
      }
      this.deptInfo!.orderNum = 0;
      this.deptInfo!.status = LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL;
      setLoadingStatusWithNotify(LoadingStatus.success, notify: false);
    } else {
      DeptRepository.getInfo(deptInfo.deptId!, defCancelToken).then((result) {
        this.deptInfo = result.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: (e) {
        BaseDio.handlerError(e);
        finish();
      });
    }
  }

  //选择父节点
  void onSelectTopDept() {
    pushNamed(DeptListSingleSelectPage.routeName, arguments: {
      ConstantBase.KEY_INTENT_TITLE: S.current.user_label_dept_parent_name_select
    }).then((result) {
      if (result != null) {
        Dept parentDept = result;
        deptInfo!.parentId = parentDept.deptId;
        deptInfo!.parentName = parentDept.deptName;
        _formKey.currentState?.patchField("parentName", deptInfo!.parentName);
      }
    });
  }

  void onSelectLeaderUser() {
    pushNamed(UserListSelectByDeptPage.routeName, arguments: {
      ConstantBase.KEY_INTENT_TITLE: S.current.user_label_dept_leader_select,
      ConstantUser.KEY_DEPT: deptInfo?.deptId ?? -1
    }).then((result) {
      if (result != null) {
        User leaderUser = result;
        deptInfo!.leader = leaderUser.userId;
        deptInfo!.leaderName = leaderUser.nickName;
        _formKey.currentState?.patchField("leaderName", deptInfo!.leaderName);
      }
    });
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
    return _formKey.currentState?.validate() ?? false;
  }

  void onSave() {
    if (!_checkSaveParams()) {
      AppToastUtil.showToast(msg: S.current.app_label_form_check_hint);
      return;
    }
    showLoading(text: S.current.label_save_ing);
    DeptRepository.submit(deptInfo!, defCancelToken).then((value) {
      AppToastUtil.showToast(msg: S.current.label_submitted_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
      finish(result: deptInfo);
    }, onError: (error) {
      dismissLoading();
      BaseDio.handlerError(error);
    });
  }

  //删除角色
  void onDelete() {
    showLoading(text: S.current.label_delete_ing);
    DeptRepository.delete(defCancelToken, deptId: deptInfo!.deptId).then((value) {
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
