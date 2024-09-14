import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';

abstract class AppBaseStatelessWidget<T extends AppBaseVm>
    extends FastStatelessWidget<T> {
  AppBaseStatelessWidget({super.key});
}

abstract class AppBaseState<W extends StatefulWidget, T extends AppBaseVm>
    extends FastState<W, T> {}

class AppBaseVm extends FastVm {}
