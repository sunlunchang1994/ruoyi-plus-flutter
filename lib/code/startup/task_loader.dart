import 'package:base/base/startup/task.dart';
import 'package:ruoyi_plus_flutter/code/startup/tast/run_app_after_task.dart';
import 'package:ruoyi_plus_flutter/code/startup/tast/run_app_before_task.dart';
import 'package:ruoyi_plus_flutter/code/startup/tast/slc_task.dart';

/// @author sunlunchang
class TaskLoader {
  static void loadTasks() {
    TaskManager().runAppBeforeTask = RunAppBeforeTask();
    TaskManager().runAppAfterTask = RunAppAfterTask();
    TaskManager().slcTask = SlcTask();
  }
}
