import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/module/deepseek/config/constant_deep_seek.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/router/router_grid.dart';

import '../../../../generated/l10n.dart';
import '../../../feature/component/tree/vd/tree_data_list_vd.dart';
import '../../../lib/deepseek/models.dart';
import '../../../lib/fast/provider/fast_select.dart';
import '../../../lib/fast/vd/list_data_vd.dart';
import '../../../lib/fast/vd/list_data_vm_sub.dart';
import 'chat_page_vd.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}

class _ChatState extends AppBaseState<ChatPage, _ChatStateVm> with AutomaticKeepAliveClientMixin {
  final String title = S.current.main_label_deep_seek;
  final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      return _ChatStateVm();
    }, builder: (context, child) {
      ThemeData themeData = Theme.of(context);
      registerEvent(context);
      getVm().initVm();
      return Scaffold(
          appBar: AppBar(title: Text(title), titleSpacing: NavigationToolbar.kMiddleSpacing),
          //图标滚动使用固定大小来解决
          body: Column(children: [
            Expanded(
                child: ListDataVd(getVm().listVmSub, getVm(),
                    refreshOnStart: true,
                    child: NqSelector<_ChatStateVm, int>(builder: (context, value, child) {
                      return ChatListPageWidget.getDataListWidget(themeData, getVm().listVmSub);
                    }, selector: (context, vm) {
                      return vm.listVmSub.shouldSetState.version;
                    }))),
            Row(children: [
              Expanded(child: TextField(controller: inputController)),
              FilledButton(
                  onPressed: () {
                    if (TextUtil.isEmpty(inputController.text)) {
                      AppToastUtil.showToast(msg: "内容不能为空或空格");
                      return;
                    }
                    getVm().listVmSub.sendChat(inputController.text);
                  },
                  child: Text("发送"))
            ]),
          ]));
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class _ChatStateVm extends AppBaseVm {
  ChatListDataVmSub listVmSub = ChatListDataVmSub();

  void initVm() {
    registerVmSub(listVmSub);
  }
}
