import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/repository/remote/user_api.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/menu/menu_grid.dart';

import '../../../../generated/l10n.dart';

class WorkbenchPage extends StatefulWidget {
  const WorkbenchPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WorkbenchState();
  }
}

class _WorkbenchState extends AppBaseState<WorkbenchPage, _WorkbenchVm> with AutomaticKeepAliveClientMixin {
  final String title = S.current.main_label_workbench;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      return _WorkbenchVm();
    }, builder: (context, child) {
      ThemeData themeData = Theme.of(context);
      registerEvent(context);
      getVm().initVm();
      return Scaffold(
          appBar: AppBar(title: Text(title)),
          //图标滚动使用固定大小来解决
          body: MenuGrid(GlobalVm().userShareVm.routerVoOf.value ?? [], null));
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class _WorkbenchVm extends AppBaseVm {
  void initVm() {
  }
}
