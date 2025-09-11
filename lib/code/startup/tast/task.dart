import 'package:flutter/cupertino.dart';

/// @author sunlunchang
/// app启动时执行的任务，如初始化第三方sdk等
abstract class Task {
  Future<void> run({BuildContext? context});
}
