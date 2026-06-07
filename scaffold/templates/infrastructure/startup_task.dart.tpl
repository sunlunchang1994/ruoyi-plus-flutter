import 'package:base/base/startup/task.dart';
import 'package:flutter/widgets.dart';

class {{Feature}}StartupTask extends Task {
  @override
  Future<void> run({BuildContext? context}) async {
    // 初始化必须幂等；不要假设 context 一定非空。
  }
}
