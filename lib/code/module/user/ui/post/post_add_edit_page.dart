import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/constant_base.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/fast_form_builder_field_option.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/fast_form_builder_text_field.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/form_operate_with_provider.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/input_decoration_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/user_api.dart';
import 'package:ruoyi_plus_flutter/code/module/user/ui/dept/dept_list_select_single_page.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../feature/bizapi/user/entity/dept.dart';
import '../../../../feature/bizapi/user/entity/post.dart';
import '../../../../feature/component/dict/entity/tree_dict.dart';
import '../../../../feature/component/dict/repository/local/local_dict_lib.dart';
import '../../../../feature/component/dict/utils/dict_ui_utils.dart';
import '../../repository/remote/post_api.dart';

class PostAddEditPage extends AppBaseStatelessWidget<_PostAddEditVm> {
  static const String routeName = '/system/post/add_edit';

  final Post? post;

  PostAddEditPage(this.post, {super.key}) {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _PostAddEditVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(post);
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
                    title: Text(post == null
                        ? S.current.user_label_post_add
                        : S.current.user_label_post_edit),
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
  Widget getSuccessWidget(BuildContext context,
      {Map<String, dynamic>? params}) {
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
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens8),
                    MyFormBuilderTextField(
                        name: "postName",
                        initialValue: getVm().postInfo!.postName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.user_label_post_name),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().postInfo!.postName = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderSelect(
                        name: "deptName",
                        initialValue: getVm().postInfo!.deptName,
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
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "postCode",
                        initialValue: getVm().postInfo!.postCode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(
                                S.current.user_label_post_code),
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().postInfo!.postCode = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "postCategory",
                        initialValue: getVm().postInfo!.postCategory,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: S.current.user_label_mailbox,
                            hintText: S.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().postInfo!.postCategory = value;
                          getVm().applyInfoChange();
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderRadioGroup<OptionVL<String>>(
                        name: "status",
                        initialValue: DictUiUtils.dict2OptionVL(
                            LocalDictLib.findDictByCodeKey(
                                LocalDictLib.CODE_SYS_NORMAL_DISABLE,
                                getVm().postInfo!.status,
                                defDictKey: LocalDictLib
                                    .KEY_SYS_NORMAL_DISABLE_NORMAL)),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            labelText: S.current.app_label_status),
                        options: DictUiUtils.dictList2FromOption(LocalDictLib
                            .DICT_MAP[LocalDictLib.CODE_SYS_NORMAL_DISABLE]!),
                        onChanged: (value) {
                          //此处需改成选择的
                          getVm().applyInfoChange();
                          getVm().postInfo!.status = value?.value;
                        }),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderTextField(
                      name: "orderNum",
                      initialValue: () {
                        int orderNum = getVm().postInfo!.postSort!;
                        return orderNum.toString();
                      }.call(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: MyInputDecoration(
                          contentPadding: EdgeInsets.zero,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: InputDecUtils.getRequiredLabel(
                              S.current.app_label_show_sort),
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder()),
                      onChanged: (value) {
                        getVm().applyInfoChange();
                        getVm().postInfo!.postSort =
                            value == null ? null : int.tryParse(value);
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ]),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderTextField(
                        name: "remark",
                        initialValue: getVm().postInfo!.remark,
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
                          getVm().postInfo!.remark = value;
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

class _PostAddEditVm extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();

  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  Post? postInfo;

  bool _infoChange = false;

  void initVm(Post? post) {
    if (postInfo != null) {
      return;
    }
    if (post == null) {
      post = Post();
      ITreeDict<dynamic> treeDict = LocalDictLib.findDictByCodeKey(
          LocalDictLib.CODE_SYS_NORMAL_DISABLE,
          LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL)!;
      post.status = treeDict.tdDictValue;
      post.statusName = treeDict.tdDictLabel;
      post.postSort = 0;
      postInfo = post;
      setLoadingStatus(LoadingStatus.success);
    } else {
      PostRepository.getInfo(post.postId!, cancelToken).asStream().single.then(
          (intensifyEntity) {
        postInfo = intensifyEntity.data;
        setLoadingStatus(LoadingStatus.success);
      }, onError: (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        AppToastBridge.showToast(msg: resultEntity.msg);
        finish();
      });
    }
  }

  void onSelectOwnerDept() {
    pushNamed(DeptListSingleSelectPage.routeName, arguments: <String, dynamic>{
      ConstantBase.KEY_INTENT_TITLE: S.current.user_label_post_owner_dept_select
    }).then((result) {
      if (result != null) {
        setOwnerDept(result);
      }
    });
  }

  void setOwnerDept(Dept? dept) {
    postInfo!.deptId = dept?.deptId;
    postInfo!.deptName = dept?.deptName;
    formOperate.patchField("deptName", postInfo!.deptName);
    applyInfoChange();
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
      AppToastBridge.showToast(msg: S.current.app_label_form_check_hint);
      return;
    }
    showLoading(text: S.current.label_save_ing);
    PostRepository.submit(postInfo!, cancelToken).then((value) {
      AppToastBridge.showToast(msg: S.current.toast_edit_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
      finish(result: postInfo);
    }, onError: (error) {
      dismissLoading();
      AppToastBridge.showToast(msg: BaseDio.getError(error).msg);
    });
  }
}
