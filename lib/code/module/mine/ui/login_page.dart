//登录

import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scaffold_single/code/base/api/base_dio.dart';
import 'package:flutter_scaffold_single/code/extras/user/entity/login_result.dart';
import 'package:flutter_scaffold_single/code/extras/user/repository/remote/user_public_api.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/images.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../base/api/result_entity.dart';
import '../../../base/ui/app_mvvm.dart';
import '../../../base/ui/utils/bar_utils.dart';
import '../../../base/utils/app_toast.dart';
import '../repository/local/sp_user_config.dart';
import '../repository/remote/user_api.dart';

class LoginPage extends AppBaseStatelessWidget<_LoginModel> {
  final String title = S.current.app_name;

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BarUtils.showEnabledSystemUI(true);
    return ChangeNotifierProvider(
      create: (loginModel) => _LoginModel(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        var loginModel = Provider.of<_LoginModel>(context, listen: false);
        return Scaffold(
            backgroundColor: themeData.colorScheme.background,
            appBar: AppBar(
              /*brightness: Brightness.dark,*/
              title: Text(title),
              //titleSpacing: 0,
            ),
            body: Column(
              children: [
                const Expanded(
                    flex: 2,
                    child: Center(
                        child: Image(
                            image: AssetImage("assets/images/ic_launcher.png"),
                            width: 72,
                            height: 72))),
                Expanded(
                    flex: 6,
                    child: Padding(
                        padding: EdgeInsets.all(SlcDimens.appDimens24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens8),
                            //此处暂时用material样式
                            /*Text(S.of(context).user_label_account,
                                style:
                                    SlcStyles.getTextColorSecondaryStyleByTheme(
                                        Theme.of(context))),*/
                            Container(
                              margin:
                                  EdgeInsets.only(top: SlcDimens.appDimens8),
                              decoration: SlcImages.getBgBoxDecoration(
                                  color: themeData.cardColor, radius: 4),
                              child: TextField(
                                  controller: TextEditingController(
                                      text: loginModel.userName),
                                  decoration: InputDecoration(
                                      //isDense: true,
                                      contentPadding:
                                          EdgeInsets.all(SlcDimens.appDimens8),
                                      labelText: S.of(context).user_label_account,
                                      hintText: S.of(context).user_label_input_account,
                                      border:
                                          const OutlineInputBorder() /*border: InputBorder.none*/),
                                  onChanged: (value) =>
                                      loginModel.userName = value),
                            ),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens8),
                            //此处暂时用material样式
                            /*Text(S.of(context).user_label_password,
                                style:
                                    SlcStyles.getTextColorSecondaryStyleByTheme(
                                        Theme.of(context))),*/
                            Container(
                                margin:
                                    EdgeInsets.only(top: SlcDimens.appDimens8),
                                decoration: SlcImages.getBgBoxDecoration(
                                    color: themeData.cardColor, radius: 4),
                                child: TextField(
                                    obscureText: true,
                                    controller: TextEditingController(
                                        text: loginModel.password),
                                    decoration: InputDecoration(
                                        //isDense: true,
                                        contentPadding: EdgeInsets.all(
                                            SlcDimens.appDimens8),
                                        labelText: S.of(context).user_label_password,
                                        hintText: S.of(context).user_label_input_password,
                                        border:
                                            const OutlineInputBorder() /*border: InputBorder.none*/),
                                    onChanged: (value) =>
                                        loginModel.password = value)),
                            SlcStyles.getSizedBox(height: SlcDimens.appDimens8),
                            Row(
                              children: [
                                Selector<_LoginModel, bool>(
                                  builder: (context, value, child) {
                                    return Checkbox(
                                        value: value,
                                        onChanged: (bool? isCheck) {
                                          loginModel.setIsSavePassword(
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
                                          loginModel
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
                                height: SlcDimens.appDimens24),
                            SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                    onPressed: () {
                                      loginModel.login();
                                    },
                                    child: Text(S.of(context).user_label_login,
                                        style: themeData
                                            .primaryTextTheme.titleMedium)))
                          ],
                        )))
              ],
            ));
      },
    );
  }
}

class _LoginModel extends AppBaseVm {
  final CancelToken cancelToken = CancelToken();
  String? userName = SpUserConfig.getAccount();
  String? password = SpUserConfig.getPassword();
  bool _isSavePassword = SpUserConfig.isSavePassword();
  bool _isAutoLogin = SpUserConfig.isAutoLogin();

  bool get isSavePassword => _isSavePassword;

  bool get isAutoLogin => _isAutoLogin;

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
    showLoading(title: S.current.user_label_logging_in);
    UserPublicServiceRepository.login(userName!, password!, cancelToken)
        .then((IntensifyEntity<LoginResult> value) {
      dismissLoading();
      if (value.isSuccess()) {
        if (_isSavePassword) {
          _saveLoginStatus();
        }
        AppToastBridge.showToast(
            msg: S.current.user_toast_login_login_successful);
        //startByPage(MainPage(), finish: true);
      } else if (!cancelToken.isCancelled) {
        AppToastBridge.showToast(msg: value.getMsg());
      }
    }, onError: (e) {
      dismissLoading();
      if (!cancelToken.isCancelled) {
        AppToastBridge.showToast(msg: BaseDio.getInstance().getErrorMsg(e));
      }
    });
  }

  ///保存登录状态
  void _saveLoginStatus() {
    SpUserConfig.saveIsSavePassword(_isSavePassword);
    SpUserConfig.saveIsAutoLogin(_isAutoLogin);
    SpUserConfig.saveAccount(userName);
    SpUserConfig.savePassword(password);
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
