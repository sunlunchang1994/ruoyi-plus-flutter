import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/dialog/dialog_loading.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/base_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/router/router.dart';

abstract class AppBaseStatelessWidget<T extends AppBaseVm>
    extends MvvmStatelessWidget<T> with LoadingDialogWidget, RouterWidget {
  AppBaseStatelessWidget({Key? key}) : super(key: key);

  ///注册事件
  @override
  void registerEvent(BuildContext context) {
    super.registerEvent(context);
  }

  @override
  void registerEventByVm(context, T vm) {
    super.registerEventByVm(context, vm);
    registerDialogEvent(context, vm);
    registerRouterEvent(context, vm);
  }
}

abstract class AppBaseState<W extends StatefulWidget, T extends AppBaseVm>
    extends MvvmState<W, T> with LoadingDialogWidget, RouterWidget {
  AppBaseState();

  T? vm;

  T getVm() {
    return vm!;
  }

  ///注册事件
  @override
  void registerEvent(BuildContext context) {
    super.registerEvent(context);
  }

  @override
  void registerEventByVm(context, T vm) {
    super.registerEventByVm(context, vm);
    this.vm = vm;
    registerDialogEvent(context, vm);
    registerRouterEvent(context, vm);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AppBaseVm extends BaseVm with LoadingDialogVm, RouterVm {}
