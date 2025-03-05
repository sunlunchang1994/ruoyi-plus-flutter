import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';

/// @author sunlunchang
/// 程序的mvvm风格基础基础类，基础信息在此拓展
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
}
