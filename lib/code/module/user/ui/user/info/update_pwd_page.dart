import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/repository/remote/pub_user_profile_api.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/form_operate_with_provider.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../lib/form/fast_form_builder_text_field.dart';
import 'package:provider/provider.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../base/ui/app_mvvm.dart';

//用户修改密码
class UpdatePwdPage extends AppBaseStatelessWidget<_UpdatePwdVm> {
  static const String routeName = '/profile/updatePwd';

  UpdatePwdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _UpdatePwdVm(),
      builder: (context, child) {
        registerEvent(context);
        getVm().initVm();
        return Scaffold(
            appBar: AppBar(title: Text(S.current.user_label_edit_pass_word), actions: [
              IconButton(
                  onPressed: () {
                    getVm()._submitPwd();
                  },
                  icon: const Icon(Icons.save))
            ]),
            body: KeyboardAvoider(
                autoScroll: true,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
                    child: FormBuilder(
                        key: getVm().formOperate.formKey,
                        child: Column(
                          children: [
                            ThemeUtil.getSizedBox(height: SlcDimens.appDimens8),
                            MyFormBuilderTextField(
                                name: "oldPassword",
                                initialValue: getVm().oldPassword,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                decoration: MyInputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.current.user_label_old_password,
                                    hintText: S.current.app_label_please_input,
                                    border: const UnderlineInputBorder()),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                onChanged: (value) {
                                  getVm().oldPassword = value;
                                }),
                            ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                            MyFormBuilderTextField(
                                name: "newPassword",
                                initialValue: getVm().newPassword,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                decoration: MyInputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.current.user_label_new_password,
                                    hintText: S.current.app_label_please_input,
                                    border: const UnderlineInputBorder()),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                onChanged: (value) {
                                  getVm().newPassword = value;
                                }),
                            ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                            MyFormBuilderTextField(
                                name: "confirmNewPassword",
                                initialValue: getVm().confirmNewPassword,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: true,
                                decoration: MyInputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.current.user_label_verify_new_password,
                                    hintText: S.current.app_label_please_input,
                                    border: const UnderlineInputBorder()),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                onChanged: (value) {
                                  getVm().confirmNewPassword = value;
                                }),
                          ],
                        )))));
      },
    );
  }
}

///用户修改密码Vm
class _UpdatePwdVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  String? oldPassword = "";

  String? newPassword = "";

  String? confirmNewPassword = "";

  void initVm() {}

  //检查保存参数
  bool _checkSaveParams() {
    return formOperate.formBuilderState?.saveAndValidate() ?? false;
  }

  void _submitPwd() {
    if (!_checkSaveParams()) {
      AppToastUtil.showToast(msg: S.current.app_label_form_check_hint);
      return;
    }
    if (newPassword != confirmNewPassword) {
      AppToastUtil.showToast(msg: S.current.user_label_verify_new_password_error);
      return;
    }
    //提交保存密码
    showLoading(text: S.current.label_submit_ing);
    PubUserProfileRepository.updatePwd(oldPassword!, newPassword!).then((result) {
      //更新成功了把当前的值设置给全局（此处应该重新调用获取用户信息的接口重新赋值，暂时先这么写）
      AppToastUtil.showToast(msg: S.current.toast_edit_success);
      dismissLoading();
    }, onError: (e) {
      BaseDio.handlerErr(e);
      dismissLoading();
    });
  }
}
