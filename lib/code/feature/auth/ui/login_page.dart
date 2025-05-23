//登录

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:ruoyi_plus_flutter/code/env_config.dart';
import 'package:ruoyi_plus_flutter/code/feature/auth/repository/remote/auth_api.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/remote/pub_menu_api.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/lib/form/form_operate_with_provider.dart';
import '../../../base/api/base_dio.dart';
import '../../../lib/fast/provider/fast_select.dart';
import '../../../lib/form/fast_form_builder_text_field.dart';
import '../../bizapi/system/repository/remote/pub_dict_data_api.dart';
import '../../bizapi/user/repository/local/user_config.dart';
import '../entity/captcha.dart';
import '../../bizapi/system/entity/router_vo.dart';
import '../../bizapi/system/entity/sys_tenant.dart';
import '../../bizapi/user/repository/remote/pub_user_api.dart';
import '../../../module/biz_main/ui/main_page.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../base/api/result_entity.dart';
import '../../../base/ui/app_mvvm.dart';
import '../../../lib/fast/utils/bar_utils.dart';
import '../../../lib/fast/utils/app_toast.dart';
import '../entity/login_tenant_vo.dart';

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
        getVm().initVm();
        return Scaffold(
            appBar: AppBar(title: Text(title), titleSpacing: NavigationToolbar.kMiddleSpacing),
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
                            key: getVm().formOperate.formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                                Visibility(
                                    visible: EnvConfig.getEnvConfig().tenantEnable,
                                    child: MyFormBuilderSelect(
                                        name: "tenantName",
                                        initialValue: getVm().tenantName,
                                        onTap: () => _showSelectTenantDialog(context),
                                        decoration: MySelectDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            labelText: S.current.user_label_tenant,
                                            hintText: S.current.user_label_select_tenant,
                                            border: const UnderlineInputBorder()),
                                        textInputAction: TextInputAction.next)),
                                ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                                FormBuilderTextField(
                                    name: "userName",
                                    initialValue: getVm().userName,
                                    focusNode: getVm().userNameInputFocus,
                                    decoration: MyInputDecoration(
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        labelText: S.current.user_label_account,
                                        hintText: S.current.user_label_input_account,
                                        border: const UnderlineInputBorder()),
                                    onChanged: (value) => getVm().userName = value,
                                    textInputAction: TextInputAction.next),
                                ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                                FormBuilderTextField(
                                    name: "password",
                                    initialValue: getVm().password,
                                    focusNode: getVm().passwordInputFocus,
                                    obscureText: true,
                                    decoration: MyInputDecoration(
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        labelText: S.current.user_label_password,
                                        hintText: S.current.user_label_input_password,
                                        border: const UnderlineInputBorder()),
                                    onChanged: (value) => getVm().password = value,
                                    textInputAction: TextInputAction.next),
                                ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                                Row(children: [
                                  Expanded(
                                      child: FormBuilderTextField(
                                          name: "captchaCode",
                                          initialValue: getVm().codeResult,
                                          focusNode: getVm().captchaInputFocus,
                                          decoration: MyInputDecoration(
                                              //isDense: true,
                                              labelText: S.current.user_label_captcha_code,
                                              hintText: S.current.user_label_input_captcha_code,
                                              border:
                                                  const UnderlineInputBorder() /*border: InputBorder.none*/),
                                          onChanged: (value) {
                                            getVm().codeResult = value;
                                          },
                                          textInputAction: TextInputAction.next)),
                                  ThemeUtil.getSizedBox(width: SlcDimens.appDimens16),
                                  NqSelector<_LoginModel, Captcha?>(
                                      builder: (context, value, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        getVm().refreshCaptcha();
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
                                  }, selector: (context, vm) {
                                    return vm.captcha;
                                  }),
                                ]),
                                ThemeUtil.getSizedBox(height: SlcDimens.appDimens8),
                                Row(
                                  children: [
                                    NqSelector<_LoginModel, bool>(
                                      builder: (context, value, child) {
                                        return Checkbox(
                                            value: value,
                                            onChanged: (bool? isCheck) {
                                              getVm().setIsSavePassword(isCheck ?? false);
                                            },
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap);
                                      },
                                      selector: (context, value) {
                                        return value._isSavePassword;
                                      },
                                    ),
                                    Text(S.current.user_label_save_password),
                                    ThemeUtil.getSizedBox(width: SlcDimens.appDimens12),
                                    NqSelector<_LoginModel, bool>(
                                      builder: (context, value, child) {
                                        return Checkbox(
                                            value: value,
                                            onChanged: (bool? isCheck) {
                                              getVm().setIsAutoLogin(isCheck ?? false);
                                            },
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap);
                                      },
                                      selector: (context, value) {
                                        return value._isAutoLogin;
                                      },
                                    ),
                                    Text(S.current.user_label_auto_login)
                                  ],
                                ),
                                ThemeUtil.getSizedBox(height: SlcDimens.appDimens36),
                                SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                        onPressed: () {
                                          getVm().login();
                                        },
                                        child: Text(S.current.user_label_login)))
                              ],
                            ))),
                    const SizedBox(height: 200)
                  ],
                )));
      },
    );
  }

  ///显示选择租户对话框
  void _showSelectTenantDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          List<SysTenant>? tenantList = getVm().loginTenant?.voList;
          List<SimpleDialogOption> dialogItem = List.generate(tenantList?.length ?? 0, (index) {
            SysTenant tenantItem = tenantList![index];
            return SimpleDialogOption(
              child: Text(tenantItem.companyName!),
              onPressed: () {
                getVm().onSelectTenant(tenantItem);
                Navigator.of(context).pop();
              },
            );
          });
          return SimpleDialog(
              title: Text(S.current.user_label_select_tenant), children: dialogItem);
        });
  }
}

class _LoginModel extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  //租户相关
  String? tenantId = UserConfig().getTenantId();
  String? tenantName = UserConfig().getTenantName();

  //用户名
  String? userName = UserConfig().getAccount();

  //密码
  String? password = UserConfig().getPassword();

  //验证码输入结果
  String? codeResult;

  //聚焦对象
  FocusNode userNameInputFocus = FocusNode();
  FocusNode passwordInputFocus = FocusNode();
  FocusNode captchaInputFocus = FocusNode();

  //是否保存密码和自动登录
  bool _isSavePassword = UserConfig().isSavePassword();
  bool _isAutoLogin = UserConfig().isAutoLogin();

  bool get isSavePassword => _isSavePassword;

  bool get isAutoLogin => _isAutoLogin;

  //获取的验证码对象
  Captcha? captcha;

  LoginTenantVo? loginTenant;

  void initVm() {
    refreshCaptcha();
    AuthRepository.tenantList().then((result) {
      loginTenant = result.data;
      SysTenant? targetTenantItem = loginTenant!.voList?.firstWhere((item) {
        return item.tenantId == tenantId;
      });
      onSelectTenant(targetTenantItem);
    }, onError: (error) {
      BaseDio.handlerErr(error, defErrMsg: S.current.user_label_tenant_get_info_error);
    });
  }

  void onSelectTenant(SysTenant? data) {
    if (data == null) {
      return;
    }
    tenantId = data.tenantId;
    tenantName = data.companyName;
    formOperate.patchField("tenantName", tenantName);
  }

  ///刷新验证码
  void refreshCaptcha() {
    AuthRepository.getCode().then((result) {
      captcha = result.data;
      notifyListeners();
    }, onError: (e) {
      //此处不需要提示获取验证码失败
      //BaseDio.handlerError(e);
      //失败后
      _delayedRefreshCaptcha();
    });
  }

  Timer? _delayedRefreshCaptchaTimer;

  void _delayedRefreshCaptcha() {
    _cancelRefreshCaptchaTimer();
    _delayedRefreshCaptchaTimer = Timer(Duration(milliseconds: 5000), () {
      refreshCaptcha();
    });
  }

  // 取消刷新验证码定时器
  void _cancelRefreshCaptchaTimer() {
    _delayedRefreshCaptchaTimer?.cancel();
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
    if (EnvConfig.getEnvConfig().tenantEnable && TextUtil.isEmpty(tenantId)) {
      AppToastUtil.showToast(msg: S.current.user_label_tenant_not_empty_hint);
      return;
    }
    if (TextUtil.isEmpty(userName)) {
      AppToastUtil.showToast(msg: S.current.user_label_account_not_empty_hint);
      return;
    }
    if (TextUtil.isEmpty(password)) {
      AppToastUtil.showToast(msg: S.current.user_label_password_bot_empty_hint);
      return;
    }
    if (TextUtil.isEmpty(codeResult)) {
      AppToastUtil.showToast(msg: S.current.user_label_captcha_code_empty_hint);
      return;
    }
    showLoading(text: S.current.user_label_logging_in);
    AuthRepository.login(
            tenantId, userName!, password!, codeResult!, captcha?.uuid, defCancelToken)
        .asStream()
        .asyncMap((event) => PubUserRepository.getInfo(defCancelToken))
        .asyncMap((event) => PubMenuPublicRepository.getRouters(defCancelToken))
        .asyncMap((event) => PubDictDataRepository.cacheDict(defCancelToken)
            .asStream()
            .map((cacheDictEvent) => event)
            .single)
        .single
        .then((IntensifyEntity<List<RouterVo>> value) {
      dismissLoading();
      if (value.isSuccess()) {
        if (_isSavePassword) {
          _saveLoginStatus();
        }
        AppToastUtil.showToast(msg: S.current.user_toast_login_login_successful);
        pushReplacementNamed(MainPage.routeName);
      } else if (!defCancelToken.isCancelled) {
        AppToastUtil.showToast(msg: value.getMsg());
      }
    }, onError: (e) {
      dismissLoading();
      if (!defCancelToken.isCancelled) {
        BaseDio.handlerErr(e);
        //失败则刷新验证码
        refreshCaptcha();
      }
    });
  }

  ///保存登录状态
  void _saveLoginStatus() {
    UserConfig().saveIsSavePassword(_isSavePassword);
    UserConfig().saveIsAutoLogin(_isAutoLogin);
    UserConfig().saveTenantId(tenantId);
    UserConfig().saveTenantName(tenantName);
    UserConfig().saveAccount(userName);
    UserConfig().savePassword(password);
  }

  @override
  dispose() {
    _cancelRefreshCaptchaTimer();
    super.dispose();
  }
}
