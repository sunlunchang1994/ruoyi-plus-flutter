import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:boxes_flutter/flutter/slc/common/log_util.dart';
import 'package:boxes_flutter/flutter/slc/common/screen_util.dart';
import 'package:boxes_flutter/flutter/slc/common/sp_cache_util.dart';
import 'package:ruoyi_plus_flutter/code/startup/tast/task.dart';

/// @author sunlunchang
/// 执行runApp之前执行的任务
class RunAppBeforeTask extends Task {
  @override
  Future<void> run({BuildContext? context}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpCacheUtil.getInstance();
  }
}
