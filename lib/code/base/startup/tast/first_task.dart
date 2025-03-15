import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/sp_cache_util.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/local/app_config.dart';
import 'package:ruoyi_plus_flutter/code/base/startup/tast/task.dart';

import '../../config/env_config.dart';
import '../../vm/global_vm.dart';

class FirstTask extends Task {
  @override
  Future<void> run({BuildContext? context}) async {
    LogUtil.init(isDebug: !EnvConfig.getEnvConfig().isRelease);

    SpCacheUtil? spCacheUtil = await SpCacheUtil.getInstance();
    //获取到SpCacheUtil马上开始更新主题

    updateThemeMode();
    ScreenUtil.getInstance();
    LogUtil.d("初始化SpUtil成功", tag: "FirstTask");
  }

  void updateThemeMode(){
    GlobalVm().switchThemeMode(AppConfig().getThemeMode());
  }
}
