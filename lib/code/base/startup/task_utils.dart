import 'package:flutter/cupertino.dart';
import 'package:ruoyi_plus_flutter/code/base/startup/tast/run_app_after_task.dart';
import 'package:ruoyi_plus_flutter/code/base/startup/tast/run_app_before_task.dart';
import 'package:ruoyi_plus_flutter/code/base/startup/tast/slc_task.dart';

class TaskUtils {
  static Future<void> execRunAppBeforeTask({BuildContext? context}) async {
    return await RunAppBeforeTask().run(context: context);
  }

  static Future<void> execRunAppAfterTask({BuildContext? context}) async {
    return await RunAppAfterTask().run(context: context);
  }

  static Future<void> execOtherTask({BuildContext? context}) async {
    return await SlcTask().run(context: context);
  }
}
