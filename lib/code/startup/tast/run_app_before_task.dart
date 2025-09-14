import 'dart:ui';

import 'package:base/base/repository/local/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:boxes_flutter/flutter/slc/common/sp_cache_util.dart';
import 'package:base/base/startup/task.dart';
import 'package:ruoyi_plus_flutter/gen/app_l10n.dart';

/// @author sunlunchang
/// 执行runApp之前执行的任务
class RunAppBeforeTask extends Task {
  @override
  Future<void> run({BuildContext? context}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpCacheUtil.getInstance();

    AppConfig().registerGetAppName(getAppName: () => S.current.app_name);
  }
}
