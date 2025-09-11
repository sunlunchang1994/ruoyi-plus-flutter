import 'package:fast/fast/vd/request_token_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/mvvm/fast_mvvm.dart';

import '../vm/global_vm.dart';

/// @author sunlunchang
/// 程序的mvvm设计模式基础类，基础信息在此拓展
abstract class AppBaseStatelessWidget<T extends AppBaseVm>
    extends FastStatelessWidget<T> {
  final GlobalVm globalVm = GlobalVm();

  AppBaseStatelessWidget({super.key});
}

abstract class AppBaseState<W extends StatefulWidget, T extends AppBaseVm>
    extends FastState<W, T> {
  final GlobalVm globalVm = GlobalVm();
}

class AppBaseVm extends FastVm {
  final GlobalVm globalVm = GlobalVm();

  @override
  void dispose() {
    CancelTokenAssist.cancelAllIf(this, "Vm dispose");
    super.dispose();
  }
}
