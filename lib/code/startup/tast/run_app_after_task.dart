import 'package:base/base/api/api_config.dart';
import 'package:base/base/repository/local/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:boxes_flutter/flutter/slc/common/log_util.dart';
import 'package:boxes_flutter/flutter/slc/common/screen_util.dart';
import 'package:base/base/startup/task.dart';
import 'package:component/component/attachment/repository/local//attachment_config.dart';
import 'package:bizapi/user/repository/local/user_config.dart';

import '../../env_config.dart';

/// @author sunlunchang
/// 执行runApp之后执行的任务
class RunAppAfterTask extends Task {
  @override
  Future<void> run({BuildContext? context}) async {
    LogUtil.init(isDebug: !EnvConfig.getEnvConfig().isRelease);
    ScreenUtil.getInstance();
    LogUtil.d("初始化SpUtil成功", tag: "FirstTask");
    ApiConfig().setServiceApiAddress(EnvConfig.getEnvConfig().apiUrl);
    ApiConfig().setClientId(EnvConfig.getEnvConfig().clientId);
    AttachmentConfig().setDownloadIpPort(ApiConfig().getServiceApiAddress());
    AttachmentConfig().setDownloadApiPart("");
    UserConfig().tenantEnable = EnvConfig.getEnvConfig().tenantEnable;
    UserConfig().defTenantId = EnvConfig.getEnvConfig().defTenantId;
  }
}
