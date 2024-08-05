import 'dart:developer';

import 'package:auto_route/src/route/page_route_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/dialog/dialog_loading.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/base_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/fast_mvvm.dart';
import 'package:flutter_slc_boxes/flutter/slc/router/router.dart';
import 'package:provider/provider.dart';

abstract class AppBaseStatelessWidget<T extends AppBaseVm>
    extends FastStatelessWidget<T> {
  AppBaseStatelessWidget({super.key});
}

abstract class AppBaseState<W extends StatefulWidget, T extends AppBaseVm>
    extends FastState<W, T> {}

class AppBaseVm extends FastVm {}
