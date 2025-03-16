import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/sp_cache_util.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/local/app_config.dart';
import 'package:ruoyi_plus_flutter/code/base/startup/tast/task.dart';

import '../../../env_config.dart';
import '../../vm/global_vm.dart';

class RunAppAfterTask extends Task {
  @override
  Future<void> run({BuildContext? context}) async {
    LogUtil.init(isDebug: !EnvConfig.getEnvConfig().isRelease);
    ScreenUtil.getInstance();
    LogUtil.d("初始化SpUtil成功", tag: "FirstTask");
  }

}
