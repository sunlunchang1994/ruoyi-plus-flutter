import 'package:flutter/material.dart';

import 'code/base/startup/task_utils.dart';
import 'code/root_page.dart';

void main() async {
  //runApp之前执行一个任务，确保基础条件
  await TaskUtils.execRunAppBeforeTask();
  runApp(const RootPage());
}
