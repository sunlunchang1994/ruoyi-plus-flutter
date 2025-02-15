import 'package:flutter/cupertino.dart';
import 'package:ruoyi_plus_flutter/code/base/startup/tast/first_task.dart';
import 'package:ruoyi_plus_flutter/code/base/startup/tast/slc_task.dart';

class TaskUtils {
  static Future<void> execFirstTask(BuildContext context) async {
    return await FirstTask().run(context);
  }

  static Future<void> execOtherTask(BuildContext context) async {
    return await SlcTask().run(context);
  }
}
