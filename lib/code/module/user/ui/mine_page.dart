import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import '../../../base/ui/app_mvvm.dart';
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
              return Column(children: [
                Card(
                  margin: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
                  child: Padding(
                      padding: EdgeInsets.all(SlcDimens.appDimens16),
                      child: Row(children: [
                        Expanded(child: Column(children: [Text("")])),
                        FadeInImage(
                            width: 80,
                            height: 80,
                            placeholder: const AssetImage("assets/images/slc/app_ic_def_user_head.png"),
                            image: NetworkImage(GlobalVm().userVmBox.userInfoOf.value?.user?.avatar ?? ""),
                            imageErrorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Image.asset("assets/images/slc/app_ic_def_user_head.png",
                                  width: 80, height: 80);
                            })
                      ])),
                )
              ]);
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
