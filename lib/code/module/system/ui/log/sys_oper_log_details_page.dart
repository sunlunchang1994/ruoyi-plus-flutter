import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:interactive_json_preview/interactive_json_preview.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_oper_log.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/ui/app_mvvm.dart';
import '../../../../lib/fast/widget/form/fast_form_builder_text_field.dart';

///操作详情
class SysOperLogDetailsPage extends AppBaseStatelessWidget<_SysOperLogDetailsModel> {
  static const String routeName = '/system/oper_log/details';

  final SysOperLog sysOperLog;

  SysOperLogDetailsPage(this.sysOperLog, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _SysOperLogDetailsModel(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm(sysOperLog);
        return Scaffold(
            appBar: AppBar(title: Text(S.current.sys_label_log_details)),
            body: KeyboardAvoider(
                autoScroll: true,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
                    child: FormBuilder(child: Column(children: getFormItem())))));
      },
    );
  }

  //获取表单的item
  List<Widget> getFormItem() {
    List<Widget> formItemArray = List.empty(growable: true);
    formItemArray.addAll(<Widget>{
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens8),
      MyFormBuilderTextField(
          name: "operId",
          initialValue: getVm().sysOperLog!.operId?.toString(),
          readOnly: true,
          decoration: MyInputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.current.sys_label_oper_id,
            hintText: S.current.app_label_not_completed,
            border: const UnderlineInputBorder(),
          )),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
        name: "statusName",
        initialValue: getVm().sysOperLog!.statusName,
        readOnly: true,
        decoration: MyInputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: S.current.sys_label_oper_status,
          border: const UnderlineInputBorder(),
        ),
      ),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
        name: "loginInfo",
        initialValue:
            "${getVm().sysOperLog!.operName} / ${getVm().sysOperLog!.deptName} / ${getVm().sysOperLog!.operIp} / ${getVm().sysOperLog!.operLocation} ",
        readOnly: true,
        decoration: MyInputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: S.current.sys_label_oper_login_info,
          border: const UnderlineInputBorder(),
        ),
      ),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
        name: "requestParams",
        initialValue: "${getVm().sysOperLog!.requestMethod} / ${getVm().sysOperLog!.operUrl}",
        readOnly: true,
        decoration: MyInputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: S.current.sys_label_oper_request_params,
          border: const UnderlineInputBorder(),
        ),
      ),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
        name: "operModule",
        initialValue: "${getVm().sysOperLog!.title} / ${getVm().sysOperLog!.businessTypeName}",
        readOnly: true,
        decoration: MyInputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: S.current.sys_label_oper_module,
          border: const UnderlineInputBorder(),
        ),
      ),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      /*FormBuilderTextField(
        name: "operMethod",
        initialValue: getVm().sysOperLog!.method,
        readOnly: true,
        decoration: MyInputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: S.current.sys_label_oper_method,
          border: const UnderlineInputBorder(),
        ),
      ),*/
      FormBuilderFieldDecoration<String>(
          name: "operMethod",
          initialValue: getVm().sysOperLog!.method,
          decoration: MyInputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.current.sys_label_oper_method,
            border: const UnderlineInputBorder(),
          ),
          builder: (field) {
            FormBuilderFieldDecorationState<dynamic, String> decorationState =
                field as FormBuilderFieldDecorationState<dynamic, String>;
            return InputDecorator(
              decoration: field.decoration,
              child: MarkdownBody(data: "`${decorationState.value as String}`"),
            );
          }),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderFieldDecoration<String>(
          name: "requestInfo",
          initialValue: getVm().sysOperLog!.operParam,
          decoration: MyInputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.current.sys_label_oper_request_info,
            border: const UnderlineInputBorder(),
          ),
          builder: (field) {
            FormBuilderFieldDecorationState<dynamic, String> decorationState =
                field as FormBuilderFieldDecorationState<dynamic, String>;
            return InputDecorator(
              decoration: field.decoration,
              //child: MarkdownBody(data: "`${prettyPrintJson(decorationState.value as String)}`"),
              child: SizedBox(
                  height: 240,
                  child: InteractiveJsonPreview(data: decorationState.value as String)),
            );
          }),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderFieldDecoration<String>(
          name: "jsonResult",
          initialValue: getVm().sysOperLog!.jsonResult,
          decoration: MyInputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.current.sys_label_oper_result,
            border: const UnderlineInputBorder(),
          ),
          builder: (field) {
            FormBuilderFieldDecorationState<dynamic, String> decorationState =
                field as FormBuilderFieldDecorationState<dynamic, String>;
            return InputDecorator(
              decoration: field.decoration,
              //child: MarkdownBody(data: "`${prettyPrintJson(decorationState.value as String)}`"),
              child: SizedBox(
                  height: 96, child: InteractiveJsonPreview(data: decorationState.value as String)),
            );
          }),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
        name: "costTime",
        initialValue: "${getVm().sysOperLog!.costTime?.toString()}ms",
        readOnly: true,
        decoration: MyInputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: S.current.sys_label_oper_cost_time,
          border: const UnderlineInputBorder(),
        ),
      ),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      FormBuilderTextField(
        name: "operTime",
        initialValue: getVm().sysOperLog!.operTime,
        readOnly: true,
        decoration: MyInputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: S.current.sys_label_oper_time,
          border: const UnderlineInputBorder(),
        ),
      ),
    });
    return formItemArray;
  }
}

class _SysOperLogDetailsModel extends AppBaseVm {
  SysOperLog? sysOperLog;

  void initVm(SysOperLog sysOperLog) {
    this.sysOperLog = sysOperLog;
  }
}
