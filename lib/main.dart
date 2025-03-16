import 'package:flutter/material.dart';

import 'code/base/startup/task_utils.dart';
import 'code/root_page.dart';

void main() async {
  await TaskUtils.execRunAppBeforeTask();
  runApp(const RootPage());
}
