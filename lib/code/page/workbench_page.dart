import 'package:base/base/ui/app_mvvm.dart';
import 'package:bizapi/user/vm/user_share_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system/system/ui/router/router_grid.dart';
import '../../gen/app_l10n.dart';

class WorkbenchPage extends StatefulWidget {
  const WorkbenchPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WorkbenchState();
  }
}

class _WorkbenchState extends AppBaseState<WorkbenchPage, _WorkbenchVm> with AutomaticKeepAliveClientMixin {
  final String title = S.current.app_label_workbench;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider(create: (context) {
      return _WorkbenchVm();
    }, builder: (context, child) {
      ThemeData themeData = Theme.of(context);
      registerEvent(context);
      getVm().initVm();
      return Scaffold(
          appBar: AppBar(title: Text(title),
              automaticallyImplyLeading: false,
              titleSpacing: NavigationToolbar.kMiddleSpacing),
          //图标滚动使用固定大小来解决
          body: MenuGrid(UserShareVm().routerVoOf.value ?? [], null));
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class _WorkbenchVm extends AppBaseVm {
  void initVm() {
  }
}
