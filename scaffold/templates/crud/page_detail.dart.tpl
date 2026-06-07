import 'package:base/base/api/base_dio.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:boxes_flutter/flutter/slc/mvvm/status_widget.dart';
import 'package:fast/fast/vd/request_token_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/{{feature}}.dart';
import '../repository/remote/{{feature}}_api.dart';

class {{Feature}}DetailPage extends AppBaseStatelessWidget<_{{Feature}}DetailVm> {
  static const String routeName = '{{routeBase}}/detail';
  final {{Entity}} {{entity}};

  {{Feature}}DetailPage(this.{{entity}}, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _{{Feature}}DetailVm(),
      builder: (context, child) {
        registerEvent(context);
        getVm().initVm({{entity}});
        return Scaffold(
          appBar: AppBar(title: const Text('{{Feature}}详情')),
          body: getStatusBody(context),
        );
      },
    );
  }

  @override
  Widget getSuccessWidget(BuildContext context, {Map<String, dynamic>? params}) {
    final info = getVm().{{entity}}Info!;
    return ListView(
      children: [
        ListTile(title: const Text('名称'), subtitle: Text(info.name ?? '')),
        ListTile(title: const Text('备注'), subtitle: Text(info.remark ?? '')),
      ],
    );
  }
}

class _{{Feature}}DetailVm extends AppBaseVm with CancelTokenAssist {
  {{Entity}}? {{entity}}Info;

  void initVm({{Entity}} {{entity}}) {
    if ({{entity}}Info != null) {
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
}
