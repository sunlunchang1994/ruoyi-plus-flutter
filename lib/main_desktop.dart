import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'code/base/startup/task_utils.dart';
import 'code/my_app_page.dart';

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia; //这句话很关键

  await TaskUtils.execRunAppBeforeTask();

  runApp(const MyApp());
}
