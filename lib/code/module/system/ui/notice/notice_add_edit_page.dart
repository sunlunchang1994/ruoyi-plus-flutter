import 'package:dio/dio.dart';
import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:boxes_flutter/flutter/slc/mvvm/status_widget.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_util.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/utils/dict_ui_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/webview/web_view_util.dart';
import 'package:fast/fast/utils/app_toast.dart';
import 'package:fast/fast/vd/request_token_manager.dart';
import 'package:form_extra/form/fast_form_builder_field_option.dart';
import 'package:form_extra/form/fast_form_builder_text_field.dart';
import 'package:form_extra/form/form_operate_with_provider.dart';
import 'package:form_extra/form/input_decoration_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_notice.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../../gen/app_l10n.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/ui/utils/fast_dialog_utils.dart';
import 'package:base/base/vm/global_vm.dart';
import '../../../../feature/bizapi/user/vm/user_share_vm.dart';
import '../../../../feature/component/dict/entity/tree_dict.dart';
import '../../../../feature/component/dict/vm/dict_share_vm.dart';
import '../../repository/remote/sys_notice_api.dart';

class NoticeAddEditPage extends AppBaseStatelessWidget<_NoticeAddEditVm> {
  static const String routeName = '/system/notice/add_edit';

  final SysNotice? sysNotice;

  NoticeAddEditPage({super.key, this.sysNotice});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _NoticeAddEditVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(sysNotice: sysNotice);
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
                    title: Text(sysNotice == null
                        ? S.current.sys_label_notice_add
                        : S.current.sys_label_notice_edit),
                    actions: [
                      if ((UserShareVm().hasPermiAny(["system:notice:edit"]) &&
                              sysNotice != null) ||
                          (UserShareVm().hasPermiAny(["system:notice:add"]) &&
                              sysNotice == null))
                        IconButton(
                            onPressed: () {
                              getVm().onSave();
                            },
                            icon: Icon(Icons.save)),
                      if (sysNotice != null &&
                          UserShareVm().hasPermiAny(["system:notice:remove"]))
                        PopupMenuButton(itemBuilder: (context) {
                          return [
                            if (UserShareVm().hasPermiAny(["system:notice:remove"]))
                              PopupMenuItem(
                                child: Text(FastS.current.action_delete),
                                onTap: () {
                                  FastDialogUtils.showDelConfirmDialog(context,
                                      contentText: TextUtil.format(
                                          S.current.sys_label_notice_del_prompt,
                                          [sysNotice?.noticeTitle ?? ""])).then((confirm) {
                                    if (confirm == true) {
                                      getVm().onDelete();
                                    }
                                  });
                                },
                              )
                          ];
                        })
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
                onChanged: () {
                  //这里要不要应该无所谓，因为本表单的数据存在vm的实例中
                  //getVm()._formKey.currentState?.save();
                },
                child: Column(
                  children: [
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens8),
                    MyFormBuilderTextField(
                        name: "noticeTitle",
                        initialValue: getVm().sysNotice!.noticeTitle,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: MyInputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(S.current.sys_label_notice_title),
                            hintText: FastS.current.app_label_please_input,
                            border: const UnderlineInputBorder()),
                        onChanged: (value) {
                          getVm().sysNotice!.noticeTitle = value;
                          getVm().applyInfoChange();
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    MyFormBuilderSelect(
                        name: "noticeTypeName",
                        initialValue: getVm().sysNotice!.noticeTypeName,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () {
                          /*DictUiUtils.showSelectDialog(
                              context, LocalDictLib.CODE_NOTICE_TYPE, (value) {
                            getVm().setSelectNoticeType(value);
                          }, title: S.current.sys_label_notice_type_select);*/
                        },
                        decoration: MySelectDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: InputDecUtils.getRequiredLabel(S.current.sys_label_config_type),
                            hintText: FastS.current.app_label_please_choose,
                            border: const UnderlineInputBorder()),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        textInputAction: TextInputAction.next),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderRadioGroup<OptionVL<String>>(
                        name: "status",
                        enabled: false,
                        initialValue: DictUiUtils.dict2OptionVL(DictShareVm().findDict(
                            LocalDictLib.CODE_SYS_NORMAL_DISABLE, getVm().sysNotice!.status,
                            defDictKey: LocalDictLib.KEY_SYS_NORMAL_DISABLE_NORMAL)),
                        options: DictUiUtils.dictList2FromOption(
                            DictShareVm().dictMap[LocalDictLib.CODE_SYS_NORMAL_DISABLE]!),
                        decoration: MyInputDecoration(labelText: S.current.sys_label_notice_status),
                        onChanged: (value) {
                          getVm().applyInfoChange();
                          getVm().sysNotice!.status = value?.value;
                          getVm().notifyListeners();
                        }),
                    ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                    FormBuilderFieldDecoration<String>(
                        decoration:
                            MyInputDecoration(labelText: S.current.sys_label_notice_context),
                        name: "name",
                        builder: (field) {
                          return InputDecorator(
                              decoration: (field as FormBuilderFieldDecorationState).decoration,
                              child: Padding(
                                  padding: EdgeInsets.only(top: SlcDimens.appDimens6),
                                  child: SizedBox(
                                      height: 540,
                                      child: WebViewUtil.newCompatWebView(
                                          controller: getVm().controller))));
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
              title: Text(FastS.current.label_prompt),
              content: Text(FastS.current.app_label_data_save_prompt),
              actions: FastDialogUtils.getCommonlyAction(context,
                  positiveText: FastS.current.action_exit, positiveLister: () {
                Navigator.pop(context);
                getVm().abandonEdit();
              }));
        });
  }
}

class _NoticeAddEditVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysNotice? sysNotice;

  bool _infoChange = false;

  late final WebViewController controller;

  _NoticeAddEditVm() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  void initVm({SysNotice? sysNotice}) {
    if (this.sysNotice != null) {
      return;
    }
    if (sysNotice == null) {
      sysNotice = SysNotice();
      this.sysNotice = sysNotice;
      controller.loadHtmlString(WebViewUtil.formatRichText(this.sysNotice?.noticeContent ?? ""));

      setLoadingStatusWithNotify(LoadingStatus.success, notify: false);
    } else {
      SysNoticeRepository.getInfo(sysNotice.noticeId!, defCancelToken).asStream().single.then(
          (intensifyEntity) {
        this.sysNotice = intensifyEntity.data;
        controller.loadHtmlString(WebViewUtil.formatRichText(this.sysNotice?.noticeContent ?? ""));
        setLoadingStatus(LoadingStatus.success);
      }, onError: BaseDio.errProxyFunc(onError: (error) {
        if (error.isUnauthorized()) {
          return;
        }
        finish();
      }));
    }
  }

  void setSelectNoticeType(ITreeDict<dynamic>? data) {
    sysNotice?.noticeType = data?.tdDictValue;
    sysNotice?.noticeTypeName = data?.tdDictLabel;
    formOperate.patchField("noticeTypeName", sysNotice?.noticeTypeName);
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

  //检查保存参数
  bool _checkSaveParams() {
    return formOperate.formBuilderState?.saveAndValidate() ?? false;
  }

  void onSave() {
    if (!_checkSaveParams()) {
      AppToastUtil.showToast(msg: FastS.current.app_label_form_check_hint);
      return;
    }
    showLoading(text: FastS.current.label_save_ing);
    SysNoticeRepository.submit(sysNotice!, defCancelToken).then((value) {
      AppToastUtil.showToast(msg: FastS.current.label_submitted_success);
      dismissLoading();
      //保存成功后要设置
      _infoChange = false;
      finish(result: sysNotice);
    }, onError: BaseDio.errProxyFunc(onError: (error) {
      dismissLoading();
    }));
  }

  //删除字典类型
  void onDelete() {
    showLoading(text: FastS.current.label_delete_ing);
    SysNoticeRepository.delete(defCancelToken, id: sysNotice!.noticeId).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: FastS.current.label_delete_success);
      finish(result: true);
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: FastS.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}
