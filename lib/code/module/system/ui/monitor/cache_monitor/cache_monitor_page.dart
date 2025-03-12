import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/entity/label_value.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/num_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/redis_cache_info.dart';
import 'package:ruoyi_plus_flutter/code/module/system/repository/remote/cache_monitor_api.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../base/api/base_dio.dart';

class CacheMonitorPage extends AppBaseStatelessWidget<_CacheMonitorVm> {
  static const String routeName = '/monitor/cache';
  final String title;

  CacheMonitorPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_CacheMonitorVm>(
        create: (context) => _CacheMonitorVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return Scaffold(appBar: AppBar(title: Text(title)), body: getStatusBody(context));
        });
  }

  @override
  Widget getSuccessWidget(BuildContext context, {Map<String, dynamic>? params}) {
    ThemeData themeData = Theme.of(context);
    return Column(children: [
      Card(
          margin: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
          elevation: 0,
          color: themeData.slcTidyUpColor.getCardColorByTheme(themeData),
          child: Padding(
              padding: EdgeInsets.only(
                  left: SlcDimens.appDimens16,
                  right: SlcDimens.appDimens16,
                  top: SlcDimens.appDimens12,
                  bottom: SlcDimens.appDimens16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.current.sys_label_cache_monitor_redis_info,
                      style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens12),
                  Table(
                      border: TableBorder.all(
                          color: themeData.slcTidyUpColor.globalDividerColorBlack,
                          width: 0.8,
                          borderRadius: BorderRadius.circular(SlcDimens.appDimens6)),
                      children: getVm().tableInfo.map((infoItem) {
                        return TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: SlcDimens.appDimens12),
                            child: Text(infoItem.label!),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: SlcDimens.appDimens12),
                            child: Text(infoItem.value!),
                          )
                        ]);
                      }).toList())
                ],
              )))
    ]);
  }
}

class _CacheMonitorVm extends AppBaseVm with CancelTokenAssist {
  late RedisCacheInfo redisCacheInfo;
  late List<LabelValue<String>> tableInfo = List.empty(growable: true);

  void initVm() {
    CacheMonitorRepository.getInfo(defCancelToken).then((result) {
      redisCacheInfo = result.data!;
      _buildTableInfo();
      setLoadingStatus(LoadingStatus.success);
    }, onError: (e) {
      BaseDio.handlerError(e);
      finish();
    });
  }

  void _buildTableInfo() {
    tableInfo.clear();
    tableInfo.addAll([
      LabelValue("Redis版本", redisCacheInfo.info?.redis_version ?? ""),
      LabelValue("Redis模式", (redisCacheInfo.info?.redis_mode ?? "") == "standalone" ? "单机" : "集群"),
      LabelValue("tcp端口", redisCacheInfo.info?.tcp_port ?? ""),
      LabelValue("客户端数", redisCacheInfo.info?.connected_clients ?? ""),
      LabelValue("运行时间(天)", redisCacheInfo.info?.uptime_in_days ?? ""),
      LabelValue("使用内存", redisCacheInfo.info?.used_memory_human ?? ""),
      LabelValue(
          "使用cpu",
          NumUtil.getNumByValueStr(redisCacheInfo.info?.used_cpu_user_children ?? "0",
                  fractionDigits: 2)
              .toString()),
      LabelValue("内存配置", redisCacheInfo.info?.maxmemory_human ?? ""),
      LabelValue(
          "AOF是否开启",
          TextUtil.isEmpty(redisCacheInfo.info?.aof_enabled)
              ? ""
              : redisCacheInfo.info?.aof_enabled == "0"
                  ? "否"
                  : "是"),
      LabelValue("RDB是否成功", redisCacheInfo.info?.rdb_last_bgsave_status ?? ""),
      LabelValue("Key数量", redisCacheInfo.dbSize?.toString() ?? ""),
      LabelValue("网络入口/出口",
          "${redisCacheInfo.info?.instantaneous_input_kbps}kps/${redisCacheInfo.info?.instantaneous_input_kbps}kps")
    ]);
  }
}
