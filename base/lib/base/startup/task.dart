import 'package:flutter/cupertino.dart';

/// @author sunlunchang
/// app启动时执行的任务，如初始化第三方sdk等
abstract class Task {
  Future<void> run({BuildContext? context});
}

class TaskManager {
  static final TaskManager _instance = TaskManager._internal();

  factory TaskManager() => _instance;

  TaskManager._internal();

  Task? runAppBeforeTask;
  Task? runAppAfterTask;
  Task? slcTask;

  void init(Task runAppBeforeTask, Task runAppAfterTask, Task slcTask) {
    this.runAppBeforeTask = runAppBeforeTask;
    this.runAppAfterTask = runAppAfterTask;
    this.slcTask = slcTask;
  }

  Future<void> execRunAppBeforeTask({BuildContext? context}) async {
    return await runAppBeforeTask?.run(context: context);
  }

  Future<void> execRunAppAfterTask({BuildContext? context}) async {
    return await runAppAfterTask?.run(context: context);
  }

  Future<void> execSlcTask({BuildContext? context}) async {
    return await slcTask?.run(context: context);
  }
}
