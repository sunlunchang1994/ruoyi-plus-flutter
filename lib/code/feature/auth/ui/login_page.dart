//登录

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:ruoyi_plus_flutter/code/base/config/env_config.dart';
import 'package:ruoyi_plus_flutter/code/feature/auth/repository/remote/auth_api.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/remote/menu_api.dart';
import '../../../base/api/base_dio.dart';
import '../../../lib/fast/widget/form/fast_form_builder_text_field.dart';
import '../../../module/user/repository/local/user_config.dart';
import '../entity/captcha.dart';
import '../../bizapi/system/entity/router_vo.dart';
import '../../bizapi/system/entity/tenant_list_vo.dart';
import '../../bizapi/user/repository/remote/user_api.dart';
import '../../../module/biz_main/ui/main_page.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../base/api/result_entity.dart';
import '../../../base/ui/app_mvvm.dart';
import '../../../lib/fast/utils/bar_utils.dart';
import '../../../base/utils/app_toast.dart';
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
                                image:
                                    AssetImage("assets/images/ic_launcher.png"),
                                width: 72,
                                height: 72))),
                    Padding(
                        padding: EdgeInsets.all(SlcDimens.appDimens24),
                        child: FormBuilder(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SlcStyles.getSizedBox(
                                height: SlcDimens.appDimens16),
                            Visibility(
                                visible: EnvConfig.getEnvConfig().tenantEnable,
                                child: Selector<_LoginModel, String?>(
                                    builder: (context, value, child) {
                                  return MyFormBuilderSelect(
                                      name: "tenantName",
                                      controller:
                                          TextEditingController(text: value),
                                      onTap: () =>
                                          _showSelectTenantDialog(context),
                                      decoration: MySelectDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          labelText:
                                              S.of(context).user_label_tenant,
                                          hintText: S
                                              .of(context)
                                              .user_label_select_tenant,
                                          border:
                                              const UnderlineInputBorder() /*border: InputBorder.none*/));
                                }, selector: (context, vm) {
                                  return vm.tenantName;
                                }, shouldRebuild: (oldVal, newVal) {
                                  return oldVal != newVal;
                                })),
                            SlcStyles.getSizedBox(
                                height: SlcDimens.appDimens16),
                            Selector<_LoginModel, String?>(
                                builder: (context, value, child) {
                              return FormBuilderTextField(
                                  name: "userName",
                                  focusNode: getVm().userNameInputFocus,
                                  controller:
                                      TextEditingController(text: value),
                                  decoration: MyInputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText:
                                          S.of(context).user_label_account,
                                      hintText: S
                                          .of(context)
                                          .user_label_input_account,
                                      border:
                                          const UnderlineInputBorder() /*border: InputBorder.none*/),
                                  onChanged: (value) =>
                                      getVm().userName = value);
                            }, selector: (context, vm) {
                              return vm.userName;
                            }, shouldRebuild: (oldVal, newVal) {
                              return oldVal != newVal;
                            }),
                            SlcStyles.getSizedBox(
                                height: SlcDimens.appDimens16),
                            Selector<_LoginModel, String?>(
                                builder: (context, value, child) {
                              return FormBuilderTextField(
                                  name: "password",
                                  focusNode: getVm().passwordInputFocus,
                                  obscureText: true,
                                  controller:
                                      TextEditingController(text: value),
                                  decoration: MyInputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelText:
                                          S.of(context).user_label_password,
                                      hintText: S
                                          .of(context)
                                          .user_label_input_password,
                                      border:
                                          const UnderlineInputBorder() /*border: InputBorder.none*/),
                                  onChanged: (value) =>
                                      getVm().password = value);
                            }, selector: (context, vm) {
                              return vm.password;
                            }, shouldRebuild: (oldVal, newVal) {
                              return oldVal != newVal;
                            }),
                            SlcStyles.getSizedBox(
                                height: SlcDimens.appDimens16),
                            Row(children: [
                              Expanded(
                                  child: FormBuilderTextField(
                                      name: "captchaCode",
                                      focusNode: getVm().captchaInputFocus,
                                      controller: TextEditingController(
                                          text: getVm().codeResult),
                                      decoration: MyInputDecoration(
                                          //isDense: true,
                                          labelText: S
                                              .of(context)
                                              .user_label_captcha_code,
                                          hintText: S
                                              .of(context)
                                              .user_label_input_captcha_code,
                                          border:
                                              const UnderlineInputBorder() /*border: InputBorder.none*/),
                                      onChanged: (value) {
                                        getVm().codeResult = value;
                                      })),
                              SlcStyles.getSizedBox(
                                  width: SlcDimens.appDimens16),
                              Selector<_LoginModel, Captcha?>(
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
                                              base64Decode(value?.img ?? ""),
                                              errorBuilder: (
                                            BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace,
                                          ) {
                                            return const Center(
                                                child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 3),
                                            ));
                                          })),
                                    );
                                  },
                                  selector: (context, vm) {
                                    return vm.captcha;
                                  },
                                  shouldRebuild: (oldVal, newVal) =>
                                      oldVal != newVal),
                            ]),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens8),
                            Row(
                              children: [
                                Selector<_LoginModel, bool>(
                                  builder: (context, value, child) {
                                    return Checkbox(
                                        value: value,
                                        onChanged: (bool? isCheck) {
                                          getVm().setIsSavePassword(
                                              isCheck ?? false);
                                        },
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap);
                                  },
                                  selector: (context, value) {
                                    return value._isSavePassword;
                                  },
                                  shouldRebuild: (previous, next) {
                                    return previous != next;
                                  },
                                ),
                                Text(S.of(context).user_label_save_password),
                                SlcStyles.getSizedBox(
                                    width: SlcDimens.appDimens12),
                                Selector<_LoginModel, bool>(
                                  builder: (context, value, child) {
                                    return Checkbox(
                                        value: value,
                                        onChanged: (bool? isCheck) {
                                          getVm()
                                              .setIsAutoLogin(isCheck ?? false);
                                        },
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap);
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
                            SlcStyles.getSizedBox(
                                height: SlcDimens.appDimens36),
                            SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                    onPressed: () {
                                      getVm().login();
                                    },
                                    child: Text(S.of(context).user_label_login,
                                        style: themeData
                                            .primaryTextTheme.titleMedium)))
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
          List<TenantListVo>? tenantList = getVm().loginTenant?.voList;
          List<SimpleDialogOption> dialogItem =
              List.generate(tenantList?.length ?? 0, (index) {
            TenantListVo tenantItem = tenantList![index];
            return SimpleDialogOption(
              child: Text(tenantItem.companyName!),
              onPressed: () {
                getVm().onSelectTenant(tenantItem);
                Navigator.of(context).pop();
              },
            );
          });
          return SimpleDialog(
              title: Text(S.current.user_label_tenant_select),
              children: dialogItem);
        });
  }
}

class _LoginModel extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();

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
    AuthServiceRepository.tenantList().then((result) {
      loginTenant = result.data;
      TenantListVo? targetTenantItem = loginTenant!.voList?.firstWhere((item) {
        return item.tenantId == tenantId;
      });
      onSelectTenant(targetTenantItem);
    },
        onError: (error) => {
              AppToastBridge.showToast(
                  msg: S.current.user_label_tenant_get_info_error)
            });
  }

  void onSelectTenant(TenantListVo? data) {
    if (data == null) {
      return;
    }
    tenantId = data.tenantId;
    tenantName = data.companyName;
    notifyListeners();
  }

  ///刷新验证码
  void refreshCaptcha() {
    AuthServiceRepository.getCode().then((result) {
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
    if (EnvConfig.getEnvConfig().tenantEnable && TextUtil.isEmpty(tenantId)) {
      AppToastBridge.showToast(msg: S.current.user_label_tenant_not_empty_hint);
      return;
    }
    if (TextUtil.isEmpty(userName)) {
      AppToastBridge.showToast(
          msg: S.current.user_label_account_not_empty_hint);
      return;
    }
    if (TextUtil.isEmpty(password)) {
      AppToastBridge.showToast(
          msg: S.current.user_label_password_bot_empty_hint);
      return;
    }
    if (TextUtil.isEmpty(codeResult)) {
      AppToastBridge.showToast(
          msg: S.current.user_label_captcha_code_empty_hint);
      return;
    }
    showLoading(text: S.current.user_label_logging_in);
    AuthServiceRepository.login(tenantId, userName!, password!, codeResult!,
            captcha?.uuid, cancelToken)
        .asStream()
        .asyncMap((event) => UserServiceRepository.getInfo(cancelToken))
        .asyncMap((event) => MenuServiceRepository.getRouters(cancelToken))
        .single
        .then((IntensifyEntity<List<RouterVo>> value) {
      dismissLoading();
      if (value.isSuccess()) {
        if (_isSavePassword) {
          _saveLoginStatus();
        }
        AppToastBridge.showToast(
            msg: S.current.user_toast_login_login_successful);
        pushReplacementNamed(MainPage.routeName);
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
    UserConfig().saveIsSavePassword(_isSavePassword);
    UserConfig().saveIsAutoLogin(_isAutoLogin);
    UserConfig().saveTenantId(tenantId);
    UserConfig().saveTenantName(tenantName);
    UserConfig().saveAccount(userName);
    UserConfig().savePassword(password);
  }

  @override
  void dispose() {
    cancelToken.cancel("dispose");
    super.dispose();
  }
}
