import 'package:flutter/material.dart';

import 'code/root_page.dart';
import 'code/startup/task_utils.dart';

void main() async {
  //runApp之前执行一个任务，确保基础条件
  await TaskUtils.execRunAppBeforeTask();
  runApp(const RootPage());
}
