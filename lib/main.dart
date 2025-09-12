import 'package:base/base/startup/task.dart';
import 'package:flutter/material.dart';
import 'package:ruoyi_plus_flutter/code/startup/task_loader.dart';

import 'code/root_page.dart';

void main() async {
  //runApp之前执行一个任务，确保基础条件
  TaskLoader.loadTasks();
  await TaskManager().execRunAppBeforeTask();
  runApp(const RootPage());
}
