import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'code/root_page.dart';
import 'code/startup/task_utils.dart';

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia; //这句话很关键

  await TaskUtils.execRunAppBeforeTask();

  runApp(const RootPage());
}
