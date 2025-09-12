import 'package:base/base/startup/task.dart';
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'code/root_page.dart';
import 'code/startup/task_loader.dart';

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia; //这句话很关键

  TaskLoader.loadTasks();
  await TaskManager().execRunAppBeforeTask();

  runApp(const RootPage());
}
