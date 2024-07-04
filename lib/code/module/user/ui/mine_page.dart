import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scaffold_single/code/base/ui/app_mvvm.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MineState();
  }
}

class _MineState extends AppBaseState<MinePage, _MineVm> with AutomaticKeepAliveClientMixin {
  final String title = S.current.main_label_mine;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (loginModel) => _MineVm(),
      builder: (context, child) {
        ThemeData themeData = Theme.of(context);
        registerEvent(context);
        final mainVm = Provider.of<_MineVm>(context, listen: false);
        mainVm.initVm();
        return Scaffold(
            appBar: AppBar(title: Text(title)),
            //图标滚动使用固定大小来解决
            body: Consumer<_MineVm>(builder: (context, value, child) {
              return Container(
                alignment: Alignment.center,
                child: const Text("我的"),
              );
            }));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _MineVm extends AppBaseVm {
  void initVm() {}

  @override
  void dispose() {
    super.dispose();
  }
}
