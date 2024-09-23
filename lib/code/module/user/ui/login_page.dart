//登录

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:ruoyi_plus_flutter/code/extras/system/repository/remote/sys_public_api.dart';
import '../../../base/api/base_dio.dart';
import '../../../base/ui/widget/my_form_builder_text_field.dart';
import '../../../extras/system/entity/captcha.dart';
import '../../../extras/user/entity/login_result.dart';
import '../../../extras/user/repository/remote/user_public_api.dart';
import '../../biz_main/ui/main_page.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../base/api/result_entity.dart';
import '../../../base/ui/app_mvvm.dart';
import '../../../base/ui/utils/bar_utils.dart';
import '../../../base/utils/app_toast.dart';
import '../repository/local/sp_user_config.dart';

class LoginPage extends AppBaseStatelessWidget<_LoginModel> {
  static const String routeName = '/login';

  final String title = S.current.app_name;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    BarUtils.showEnabledSystemUI(true);
    return ChangeNotifierProvider(
      create: (context) => _LoginModel(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        var loginModel = Provider.of<_LoginModel>(context, listen: false);
        loginModel.initVm();
        return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: KeyboardAvoider(
                autoScroll: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                        height: 160,
                        child: Center(
                            child: Image(
                                image: AssetImage("assets/images/ic_launcher.png"),
                                width: 72,
                                height: 72))),
                    Padding(
                        padding: EdgeInsets.all(SlcDimens.appDimens24),
                        child: FormBuilder(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                            MyFormBuilderSelect(
                                name: "tenantName",
                                controller: TextEditingController(text: loginModel.tenantName),
                                decoration: MyInputDecoration(
                                    suffixIcon: const Icon(Icons.chevron_right),
                                    suffixIconConstraints: const BoxConstraints(minWidth: 24,maxHeight: 24),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.of(context).user_label_tenant,
                                    hintText: S.of(context).user_label_select_tenant,
                                    border: const UnderlineInputBorder() /*border: InputBorder.none*/),
                                onChanged: (value) => loginModel.tenantName = value),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                            FormBuilderTextField(
                                name: "userName",
                                focusNode: loginModel.userNameInputFocus,
                                controller: TextEditingController(text: loginModel.userName),
                                decoration: MyInputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.of(context).user_label_account,
                                    hintText: S.of(context).user_label_input_account,
                                    border: const UnderlineInputBorder() /*border: InputBorder.none*/),
                                onChanged: (value) => loginModel.userName = value),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                            FormBuilderTextField(
                                name: "password",
                                focusNode: loginModel.passwordInputFocus,
                                obscureText: true,
                                controller: TextEditingController(text: loginModel.password),
                                decoration: MyInputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.of(context).user_label_password,
                                    hintText: S.of(context).user_label_input_password,
                                    border: const UnderlineInputBorder() /*border: InputBorder.none*/),
                                onChanged: (value) => loginModel.password = value),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                            Row(children: [
                              Expanded(
                                  child: FormBuilderTextField(
                                      name: "captchaCode",
                                      focusNode: loginModel.captchaInputFocus,
                                      controller: TextEditingController(text: loginModel.codeResult),
                                      decoration: MyInputDecoration(
                                          //isDense: true,
                                          labelText: S.of(context).user_label_captcha_code,
                                          hintText: S.of(context).user_label_input_captcha_code,
                                          border:
                                              const UnderlineInputBorder() /*border: InputBorder.none*/),
                                      onChanged: (value) => loginModel.codeResult = value)),
                              SlcStyles.getSizedBox(width: SlcDimens.appDimens16),
                              Selector<_LoginModel, Captcha?>(
                                  builder: (context, value, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        loginModel.refreshCaptcha();
                                      },
                                      child: SizedBox(
                                          height: 48,
                                          width: 120,
                                          child: Image.memory(
                                              gaplessPlayback: true,
                                              base64Decode(value?.img ?? ""), errorBuilder: (
                                            BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace,
                                          ) {
                                            return const Center(
                                                child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(strokeWidth: 3),
                                            ));
                                          })),
                                    );
                                  },
                                  selector: (context, vm) {
                                    return vm.captcha;
                                  },
                                  shouldRebuild: (oldVal, newVal) => oldVal != newVal),
                            ]),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens8),
                            Row(
                              children: [
                                Selector<_LoginModel, bool>(
                                  builder: (context, value, child) {
                                    return Checkbox(
                                        value: value,
                                        onChanged: (bool? isCheck) {
                                          loginModel.setIsSavePassword(isCheck ?? false);
                                        },
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap);
                                  },
                                  selector: (context, value) {
                                    return value._isSavePassword;
                                  },
                                  shouldRebuild: (previous, next) {
                                    return previous != next;
                                  },
                                ),
                                Text(S.of(context).user_label_save_password),
                                SlcStyles.getSizedBox(width: SlcDimens.appDimens12),
                                Selector<_LoginModel, bool>(
                                  builder: (context, value, child) {
                                    return Checkbox(
                                        value: value,
                                        onChanged: (bool? isCheck) {
                                          loginModel.setIsAutoLogin(isCheck ?? false);
                                        },
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap);
                                  },
                                  selector: (context, value) {
                                    return value._isAutoLogin;
                                  },
                                  shouldRebuild: (previous, next) {
                                    return previous != next;
                                  },
                                ),
                                Text(S.of(context).user_label_auto_login)
                              ],
                            ),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens36),
                            SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                    onPressed: () {
                                      loginModel.login();
                                    },
                                    child: Text(S.of(context).user_label_login,
                                        style: themeData.primaryTextTheme.titleMedium)))
                          ],
                        ))),
                    const SizedBox(height: 200)
                  ],
                )));
      },
    );
  }
}

class _LoginModel extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();
  String? tenantId = SpUserConfig.getTenantId();
  String? tenantName = SpUserConfig.getTenantName();
  String? userName = SpUserConfig.getAccount();
  String? password = SpUserConfig.getPassword();
  String? codeResult;
  FocusNode userNameInputFocus = FocusNode();
  FocusNode passwordInputFocus = FocusNode();
  FocusNode captchaInputFocus = FocusNode();
  bool _isSavePassword = SpUserConfig.isSavePassword();
  bool _isAutoLogin = SpUserConfig.isAutoLogin();

  bool get isSavePassword => _isSavePassword;

  bool get isAutoLogin => _isAutoLogin;

  Captcha? captcha;

  void initVm() {
    refreshCaptcha();
  }

  ///刷新验证码
  void refreshCaptcha() {
    SysPublicServiceRepository.getCode().then((result) {
      captcha = result.data;
      notifyListeners();
    }, onError: (e) {
      ResultEntity resultEntity = BaseDio.getError(e);
      AppToastBridge.showToast(msg: resultEntity.msg);
    });
  }

  void setIsSavePassword(bool value) {
    _isSavePassword = value;
    if (!_isSavePassword) {
      _isAutoLogin = false;
    }
    notifyListeners();
  }

  void setIsAutoLogin(bool value) {
    _isAutoLogin = value;
    if (_isAutoLogin) {
      _isSavePassword = true;
    }
    notifyListeners();
  }

  ///登录
  void login() {
    userNameInputFocus.unfocus();
    passwordInputFocus.unfocus();
    captchaInputFocus.unfocus();
    if (TextUtil.isEmpty(tenantId)) {
      AppToastBridge.showToast(msg: S.current.user_label_tenant_not_empty_hint);
      return;
    }
    if (TextUtil.isEmpty(userName)) {
      AppToastBridge.showToast(msg: S.current.user_label_account_not_empty_hint);
      return;
    }
    if (TextUtil.isEmpty(password)) {
      AppToastBridge.showToast(msg: S.current.user_label_password_bot_empty_hint);
      return;
    }
    showLoading(text: S.current.user_label_logging_in);
    UserPublicServiceRepository.login(
            tenantId!, userName!, password!, codeResult!, captcha?.uuid, cancelToken)
        .then((IntensifyEntity<LoginResult> value) {
      dismissLoading();
      if (value.isSuccess()) {
        if (_isSavePassword) {
          _saveLoginStatus();
        }
        AppToastBridge.showToast(msg: S.current.user_toast_login_login_successful);
        pushReplacementPage(MainPage());
      } else if (!cancelToken.isCancelled) {
        AppToastBridge.showToast(msg: value.getMsg());
      }
    }, onError: (e) {
      dismissLoading();
      if (!cancelToken.isCancelled) {
        AppToastBridge.showToast(msg: BaseDio.getErrorMsg(e));
        //失败则刷新验证码
        refreshCaptcha();
      }
    });
  }

  ///保存登录状态
  void _saveLoginStatus() {
    SpUserConfig.saveIsSavePassword(_isSavePassword);
    SpUserConfig.saveIsAutoLogin(_isAutoLogin);
    SpUserConfig.saveTenantId(tenantId);
    SpUserConfig.saveTenantName(tenantName);
    SpUserConfig.saveAccount(userName);
    SpUserConfig.savePassword(password);
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
