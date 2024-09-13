import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../base/ui/app_mvvm.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';

class WorkbenchPage extends StatefulWidget {
  const WorkbenchPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WorkbenchState();
  }
}

class _WorkbenchState extends AppBaseState<WorkbenchPage, _WorkbenchVm> with AutomaticKeepAliveClientMixin {
  final String title = S.current.main_label_mine;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (loginModel) => _WorkbenchVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        final mainVm = Provider.of<_WorkbenchVm>(context, listen: false);
        mainVm.initVm();
        return Scaffold(
            appBar: AppBar(title: Text(title)),
            //图标滚动使用固定大小来解决
            body: Consumer<_WorkbenchVm>(builder: (context, value, child) {
              return Container(
                alignment: Alignment.center,
                child: const Text("工作台"),
              );
            }));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _WorkbenchVm extends AppBaseVm {
  void initVm() {}

  @override
  void dispose() {
    super.dispose();
  }
}
