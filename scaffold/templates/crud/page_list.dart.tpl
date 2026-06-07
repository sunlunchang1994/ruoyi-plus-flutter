import 'package:base/base/ui/app_mvvm.dart';
import 'package:fast/fast/provider/fast_select.dart';
import 'package:fast/fast/utils/widget_utils.dart';
import 'package:fast/fast/vd/page_data_vd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/{{feature}}.dart';
import '{{feature}}_add_edit_page.dart';
import '{{feature}}_page_vd.dart';

class {{Feature}}ListPage extends AppBaseStatelessWidget<_{{Feature}}ListVm> {
  static const String routeName = '{{routeBase}}';

  {{Feature}}ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _{{Feature}}ListVm(),
      builder: (context, child) {
        final themeData = Theme.of(context);
        registerEvent(context);
        getVm().initVm();
        return Scaffold(
          appBar: AppBar(
            title: Text('{{Feature}}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => WidgetUtils.autoHandlerSearchDrawer(context),
              ),
            ],
          ),
          endDrawer: {{Feature}}PageVd.getSearchEndDrawer(context, themeData, getVm().listVmSub),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: getVm().onAdd,
          ),
          body: PageDataVd(
            getVm().listVmSub,
            getVm(),
            refreshOnStart: true,
            child: NqSelector<_{{Feature}}ListVm, int>(
              builder: (context, value, child) {
                return {{Feature}}PageVd.getListWidget(themeData, getVm().listVmSub);
              },
              selector: (context, vm) => vm.listVmSub.shouldSetState.version,
            ),
          ),
        );
      },
    );
  }
}

class _{{Feature}}ListVm extends AppBaseVm {
  late {{Feature}}PageDataVmSub listVmSub;

  _{{Feature}}ListVm() {
    listVmSub = {{Feature}}PageDataVmSub();
    listVmSub.enableSelectModel = true;
    listVmSub.setItemClick((index, item) {
      pushNamed({{Feature}}AddEditPage.routeName, arguments: {'{{entity}}': item}).then((result) {
        if (result != null) {
          listVmSub.sendRefreshEvent();
        }
      });
    });
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  void onAdd() {
    pushNamed({{Feature}}AddEditPage.routeName).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });
  }
}
