import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/entity/label_value.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/num_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/object_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/status_widget.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/redis_cache_info.dart';
import 'package:ruoyi_plus_flutter/code/module/system/repository/remote/cache_monitor_api.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../lib/fast/provider/should_set_state.dart';

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
    return SingleChildScrollView(
        child: Column(children: [
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
              ))),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
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
                  Text(S.current.sys_label_cache_monitor_command_statistics,
                      style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens12),
                  /*SfCircularChart(series: <CircularSeries>[
                    PieSeries<CommandStats, String>(
                      dataSource: getVm().redisCacheInfo.commandStats ?? [],
                      pointColorMapper: (CommandStats data, _) => data.color,
                      xValueMapper: (CommandStats data, _) => data.name,
                      yValueMapper: (CommandStats data, _) => data.value,
                      explode: true,
                      radius: "60%",
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        // 显示标签
                        labelPosition: ChartDataLabelPosition.outside,
                        // 标签位置在饼图外部
                        useSeriesColor: false,
                        // 自动排列标签
                        labelIntersectAction: LabelIntersectAction.shift,
                      ),
                    )
                  ])*/
                  NqSelector<_CacheMonitorVm, int>(builder: (context, value, child) {
                    return AspectRatio(
                        aspectRatio: 1.2,
                        child: LineChart(
                          LineChartData(
                              lineTouchData: LineTouchData(
                                handleBuiltInTouches: true,
                                touchCallback:
                                    (FlTouchEvent event, LineTouchResponse? touchResponse) {
                                  //如何监听触摸更改commandStatsBaseLineX的值
                                  /*if (touchResponse != null &&
                                      touchResponse.lineBarSpots != null &&
                                      touchResponse.lineBarSpots!.isNotEmpty) {
                                    int touchedIndex = touchResponse.lineBarSpots![0].spotIndex;
                                    getVm().updateCommandStatsBaseLineX(touchedIndex);
                                  }*/
                                  if (event.localPosition == null) {
                                    getVm().touchOffset = null;
                                    return;
                                  }
                                  if (getVm().touchOffset == null) {
                                    getVm().touchOffset = event.localPosition;
                                    return;
                                  }
                                  getVm().updateCommandStatsBaseLineX(
                                      (event.localPosition!.dx - getVm().touchOffset!.dx).toInt());
                                  getVm().touchOffset = event.localPosition;
                                },
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipColor: (touchedSpot) =>
                                      themeData.colorScheme.onSurface.withValues(alpha: 0.1),
                                ),
                              ),
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    interval: 1,
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(
                                      color: themeData.slcTidyUpColor.globalDividerColorBlack,
                                      width: 2),
                                  left: BorderSide(
                                      color: themeData.slcTidyUpColor.globalDividerColorBlack,
                                      width: 2),
                                  right: BorderSide.none,
                                  top: BorderSide.none,
                                ),
                              ),
                              lineBarsData: () {
                                List<LineChartBarData> widgets = List.empty(growable: true);
                                widgets.add(LineChartBarData(
                                  isCurved: true,
                                  color: themeData.primaryColor,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                  spots: () {
                                    List<FlSpot> flSpots = List.empty(growable: true);
                                    List<CommandStats> commandStatsList =
                                        getVm().redisCacheInfo.commandStats ?? [];
                                    if (commandStatsList.isEmpty) {
                                      return flSpots;
                                    }
                                    int count = commandStatsList.length;
                                    int iStart = max(getVm().commandStatsBaseLineX - 5, 0);
                                    int iEnd = min(getVm().commandStatsBaseLineX + 5, count);
                                    if (iEnd == count) {
                                      iStart = count - 10;
                                    } else if (iStart == 0) {
                                      iEnd = iStart + 10;
                                    }
                                    for (int i = iStart; i < iEnd; i++) {
                                      CommandStats commandStats = commandStatsList[i];
                                      flSpots.add(
                                          FlSpot(i.toDouble(), commandStats.value!.toDouble()));
                                    }
                                    return flSpots;
                                  }.call(),
                                ));
                                return widgets;
                              }.call(),
                              maxX: 10,
                              minX: 0,
                              baselineX: getVm().commandStatsBaseLineX.toDouble()),
                          duration: const Duration(milliseconds: 250),
                        ));
                    /*return AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  return;
                                }
                                int touchedIndex =
                                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                                getVm().selectCommandStatsGivePic(touchedIndex);
                              },
                            ),
                            startDegreeOffset: 180,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 1,
                            centerSpaceRadius: 0,
                            sections: () {
                              List<PieChartSectionData> pieChartSectionData =
                                  List.empty(growable: true);
                              List<CommandStats> commandStatsList =
                                  getVm().redisCacheInfo.commandStats ?? [];
                              int count = commandStatsList.length;
                              if (count == 0) {
                                return pieChartSectionData;
                              }
                              for (int i = 0; i < count; i++) {
                                CommandStats commandStats = commandStatsList[i];
                                pieChartSectionData.add(PieChartSectionData(
                                    color: Color(commandStats.color!),
                                    value: commandStats.value!.toDouble(),
                                    title: commandStats.name,
                                    radius: (ScreenUtil.getInstance().screenWidthDpr -
                                            SlcDimens.appDimens16 * 4) /
                                        3,
                                    showTitle: false,
                                    borderSide: commandStats.isBoxChecked()
                                        ? const BorderSide(width: 6, color: Colors.transparent)
                                        : null));
                              }
                              return pieChartSectionData;
                            }.call(),
                          ),
                        ));*/
                  }, selector: (context, vm) {
                    return vm.shouldSetState.version;
                  }),
                ],
              ))),
    ]));
  }
}

class _CacheMonitorVm extends AppBaseVm with CancelTokenAssist {
  late RedisCacheInfo redisCacheInfo;

  //redis信息
  late List<LabelValue<String>> tableInfo = List.empty(growable: true);

  //命令统计
  int commandStatsBaseLineX = 5;
  final ShouldSetState shouldSetState = ShouldSetState();
  Offset? touchOffset;

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

  void updateCommandStatsBaseLineX(int commandStatsBaseLineX) {
    if (ObjectUtil.isEmptyList(redisCacheInfo.commandStats)) {
      return;
    }
    if(commandStatsBaseLineX>-2&&commandStatsBaseLineX<2){
      return;
    }
    //commandStatsBaseLineX=commandStatsBaseLineX<0?-1:1;
    int tempBaseLineX = this.commandStatsBaseLineX + commandStatsBaseLineX;
    if (tempBaseLineX < 0 || tempBaseLineX > redisCacheInfo.commandStats!.length) {
      return;
    }
    this.commandStatsBaseLineX = tempBaseLineX;
    shouldSetState.updateVersion();
    notifyListeners();
  }
}
