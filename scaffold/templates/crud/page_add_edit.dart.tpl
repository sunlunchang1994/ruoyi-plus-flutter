import 'package:base/base/api/base_dio.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:boxes_flutter/flutter/slc/mvvm/status_widget.dart';
import 'package:fast/fast/utils/app_toast.dart';
import 'package:fast/fast/vd/request_token_manager.dart';
import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_extra/form/fast_form_builder_text_field.dart';
import 'package:form_extra/form/form_operate_with_provider.dart';
import 'package:provider/provider.dart';

import '../entity/{{feature}}.dart';
import '../repository/remote/{{feature}}_api.dart';

class {{Feature}}AddEditPage extends AppBaseStatelessWidget<_{{Feature}}AddEditVm> {
  static const String routeName = '{{routeBase}}/add_edit';
  final {{Entity}}? {{entity}};

  {{Feature}}AddEditPage(this.{{entity}}, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _{{Feature}}AddEditVm(),
      builder: (context, child) {
        registerEvent(context);
        getVm().initVm({{entity}});
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
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(FastS.current.label_prompt),
                content: const Text('数据未保存，确定退出？'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getVm().abandonEdit();
                    },
                    child: Text(FastS.current.action_exit),
                  ),
                ],
              ),
            );
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text({{entity}} == null ? '新增{{Feature}}' : '编辑{{Feature}}'),
              actions: [
                IconButton(icon: const Icon(Icons.save), onPressed: getVm().onSave),
              ],
            ),
            body: getStatusBody(context),
          ),
        );
      },
    );
  }

  @override
  Widget getSuccessWidget(BuildContext context, {Map<String, dynamic>? params}) {
    return FormBuilder(
      key: getVm().formOperate.formKey,
      child: Column(
        children: [
          MyFormBuilderTextField(
            name: 'name',
            initialValue: getVm().{{entity}}Info!.name,
            validator: FormBuilderValidators.required(),
            onChanged: (value) {
              getVm().{{entity}}Info!.name = value;
              getVm().applyInfoChange();
            },
          ),
        ],
      ),
    );
  }
}

class _{{Feature}}AddEditVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();
  {{Entity}}? {{entity}}Info;
  bool _infoChange = false;

  void initVm({{Entity}}? {{entity}}) {
    if ({{entity}}Info != null) {
      return;
    }
    if ({{entity}} == null) {
      {{entity}}Info = {{Entity}}();
      setLoadingStatusWithNotify(LoadingStatus.success, notify: false);
      return;
    }
    {{Feature}}Repository.getInfo({{entity}}.id!, defCancelToken).then((result) {
      {{entity}}Info = result.data;
      setLoadingStatus(LoadingStatus.success);
    }, onError: BaseDio.errProxyFunc(onError: (error) {
      if (!error.isUnauthorized()) {
        finish();
      }
    }));
  }

  void applyInfoChange() {
    _infoChange = true;
  }

  bool canPop() => !_infoChange;

  void abandonEdit() {
    _infoChange = false;
    finish();
  }

  void onSave() {
    if (!(formOperate.formBuilderState?.saveAndValidate() ?? false)) {
      return;
    }
    showLoading(text: FastS.current.label_save_ing);
    {{Feature}}Repository.submit({{entity}}Info!, defCancelToken).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: FastS.current.label_submitted_success);
      _infoChange = false;
      finish(result: {{entity}}Info);
    }, onError: BaseDio.errProxyFunc(onError: (error) {
      dismissLoading();
    }));
  }
}
