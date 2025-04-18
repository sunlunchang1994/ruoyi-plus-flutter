import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/utils/utils.dart';
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
      _getRedisInfoWidget(themeData),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
      _getCommandStatisticsBar(themeData),
      ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
    ]));
  }

  Widget _getRedisInfoWidget(ThemeData themeData) {
    return Card(
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
                        color: themeData.slcTidyUpColor.getDividerColorByTheme(themeData),
                        width: 0.8,
                        borderRadius: BorderRadius.circular(SlcDimens.appDimens6)),
                    children: getVm().tableInfo.map((infoItem) {
                      return TableRow(children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: SlcDimens.appDimens12),
                          child: Text(infoItem.label!),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: SlcDimens.appDimens12),
                          child: Text(infoItem.value!),
                        )
                      ]);
                    }).toList())
              ],
            )));
  }

  // 命令统计图
  Widget _getCommandStatisticsPic(ThemeData themeData) {
    return Card(
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
                NqSelector<_CacheMonitorVm, int>(builder: (context, value, child) {
                  return AspectRatio(
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
                              /*int touchedIndex =
                                  pieTouchResponse.touchedSection!.touchedSectionIndex;
                              getVm().selectCommandStatsGivePic(touchedIndex);*/
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
                      ));
                }, selector: (context, vm) {
                  return vm.shouldSetState.version;
                }),
              ],
            )));
  }

  // 命令统计图
  Widget _getCommandStatisticsLine(ThemeData themeData) {
    return Card(
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
                NqSelector<_CacheMonitorVm, int>(builder: (context, value, child) {
                  return Column(
                    children: [
                      AspectRatio(
                          aspectRatio: 1.2,
                          child: LineChart(
                            LineChartData(
                                clipData:
                                    FlClipData(top: true, bottom: false, left: true, right: true),
                                gridData: FlGridData(show: true),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 24,
                                        getTitlesWidget: (value, meta) {
                                          return SideTitleWidget(
                                            angle: 0.5,
                                            meta: meta,
                                            child:
                                                Text(getVm().getCommandNameByIndex(value.round())),
                                          );
                                        }),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        minIncluded: false,
                                        maxIncluded: false,
                                        showTitles: true,
                                        reservedSize: 48,
                                        getTitlesWidget: (value, meta) {
                                          return SideTitleWidget(
                                            meta: meta,
                                            child: Text(
                                              Utils().formatNumber(
                                                meta.min,
                                                meta.max,
                                                value.roundToDouble(),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    bottom: BorderSide(
                                        color: themeData.slcTidyUpColor
                                            .getDividerColorByTheme(themeData),
                                        width: 2),
                                    left: BorderSide(
                                        color: themeData.slcTidyUpColor
                                            .getDividerColorByTheme(themeData),
                                        width: 2),
                                    right: BorderSide.none,
                                    top: BorderSide.none,
                                  ),
                                ),
                                lineTouchData: LineTouchData(
                                  handleBuiltInTouches: true,
                                  touchTooltipData: LineTouchTooltipData(
                                      getTooltipColor: (touchedSpot) =>
                                          themeData.colorScheme.onSurface.withValues(alpha: 0.1),
                                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                        return touchedSpots.map((LineBarSpot touchedSpot) {
                                          final textStyle = TextStyle(
                                            color: touchedSpot.bar.gradient?.colors.first ??
                                                touchedSpot.bar.color ??
                                                Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          );
                                          return LineTooltipItem(
                                              "${getVm().redisCacheInfo.commandStats![touchedSpot.x.toInt()].name}:${touchedSpot.y.toString()}",
                                              textStyle);
                                        }).toList();
                                      }),
                                ),
                                lineBarsData: () {
                                  List<LineChartBarData> widgets = List.empty(growable: true);
                                  widgets.add(LineChartBarData(
                                    isCurved: true,
                                    color: themeData.colorScheme.primary,
                                    barWidth: 2,
                                    curveSmoothness: 0.35,
                                    isStrokeCapRound: true,
                                    preventCurveOverShooting: true,
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
                                      for (double i = 0; i < count; i += 1) {
                                        CommandStats commandStats = commandStatsList[i.round()];
                                        flSpots.add(FlSpot(i, commandStats.value!.toDouble()));
                                      }
                                      return flSpots;
                                    }.call(),
                                  ));
                                  return widgets;
                                }.call(),
                                maxX: getVm().commandStatsBaseLineX + _CacheMonitorVm.defBaseLineX,
                                minX: getVm().commandStatsBaseLineX - _CacheMonitorVm.defBaseLineX,
                                maxY: getVm().commandStatsMaxY.toDouble(),
                                baselineX: getVm().commandStatsBaseLineX.toDouble()),
                            duration: Duration.zero,
                          )),
                      () {
                        int commandStatsCount = getVm().redisCacheInfo.commandStats?.length ?? 0;
                        //不足10个则不显示
                        if (commandStatsCount <= _CacheMonitorVm.defBaseLineX * 2) {
                          return SizedBox.shrink();
                        }
                        double min = _CacheMonitorVm.defBaseLineX;
                        double max = commandStatsCount - 1 - min;
                        return Slider(
                          min: min,
                          max: max,
                          value: getVm().commandStatsBaseLineX.toDouble(),
                          onChanged: (value) {
                            // 拖动改变进度
                            getVm().updateCommandStatsBaseLineX(value);
                          },
                        );
                      }.call()
                    ],
                  );
                }, selector: (context, vm) {
                  return vm.shouldSetState.version;
                }),
              ],
            )));
  }

  // 命令统计图
  Widget _getCommandStatisticsBar(ThemeData themeData) {
    return Card(
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
                NqSelector<_CacheMonitorVm, int>(builder: (context, value, child) {
                  return Column(
                    children: [
                      AspectRatio(
                          aspectRatio: 0.5,
                          child: BarChart(
                            BarChartData(
                                rotationQuarterTurns: 1,
                                gridData: FlGridData(show: true),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 24,
                                        getTitlesWidget: (value, meta) {
                                          return SideTitleWidget(
                                            meta: meta,
                                            child: Text(getVm().getCommandNameByIndex(value.round(),
                                                abbreviation: true)),
                                          );
                                        }),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        minIncluded: false,
                                        maxIncluded: false,
                                        showTitles: true,
                                        reservedSize: 24,
                                        getTitlesWidget: (value, meta) {
                                          return SideTitleWidget(
                                            meta: meta,
                                            child: Text(
                                              Utils().formatNumber(
                                                meta.min,
                                                meta.max,
                                                value.roundToDouble(),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    bottom: BorderSide(
                                        color: themeData.slcTidyUpColor
                                            .getDividerColorByTheme(themeData),
                                        width: 2),
                                    right: BorderSide(
                                        color: themeData.slcTidyUpColor
                                            .getDividerColorByTheme(themeData),
                                        width: 2),
                                    left: BorderSide.none,
                                    top: BorderSide.none,
                                  ),
                                ),
                                //让触摸事件在空白的地方也显示tooltip
                                barTouchData: BarTouchData(
                                  handleBuiltInTouches: true,
                                  touchExtraThreshold:
                                      EdgeInsets.symmetric(vertical: 60, horizontal: 4),
                                  touchTooltipData: BarTouchTooltipData(
                                      maxContentWidth: 150,
                                      tooltipPadding:
                                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      getTooltipColor: (touchedSpot) =>
                                          themeData.colorScheme.surfaceContainerHigh,
                                      getTooltipItem: (
                                        BarChartGroupData group,
                                        int groupIndex,
                                        BarChartRodData rod,
                                        int rodIndex,
                                      ) {
                                        final color = rod.gradient?.colors.first ?? rod.color;
                                        final textStyle = TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        );
                                        return BarTooltipItem(
                                            "${getVm().redisCacheInfo.commandStats![groupIndex].name}:${rod.toY.round().toString()}",
                                            textStyle);
                                      },
                                      fitInsideVertically: true),
                                ),
                                barGroups: () {
                                  List<BarChartGroupData> widgets = List.empty(growable: true);
                                  List<CommandStats> commandStatsList =
                                      getVm().redisCacheInfo.commandStats ?? [];
                                  if (commandStatsList.isEmpty) {
                                    return widgets;
                                  }
                                  int count = commandStatsList.length;
                                  for (int i = 0; i < count; i += 1) {
                                    CommandStats commandStats = commandStatsList[i.round()];
                                    widgets.add(BarChartGroupData(x: i, barRods: [
                                      BarChartRodData(
                                        width: 16,
                                        toY: commandStats.value!.toDouble(),
                                        color: Color(commandStats.color!),
                                        borderRadius:
                                            const BorderRadius.vertical(top: Radius.circular(16)),
                                      )
                                    ]));
                                  }
                                  return widgets;
                                }.call(),
                                maxY: getVm().commandStatsMaxY.toDouble()),
                          )),
                    ],
                  );
                }, selector: (context, vm) {
                  return vm.shouldSetState.version;
                }),
              ],
            )));
  }
}

class _CacheMonitorVm extends AppBaseVm with CancelTokenAssist {
  late RedisCacheInfo redisCacheInfo;

  //redis信息
  late List<LabelValue<String>> tableInfo = List.empty(growable: true);

  //命令统计
  static const double defBaseLineX = 5;
  final ShouldSetState shouldSetState = ShouldSetState();
  double commandStatsBaseLineX = defBaseLineX;
  int commandStatsMaxY = 0;

  void initVm() {
    CacheMonitorRepository.getInfo(defCancelToken).then((result) {
      redisCacheInfo = result.data!;
      _buildTableInfo();
      _buildCommandStats();
      setLoadingStatus(LoadingStatus.success);
    }, onError: BaseDio.errProxyFunc(onError: (error) {
      if (error.isUnauthorized()) {
        return;
      }
      finish();
    }));
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

  void _buildCommandStats() {
    commandStatsMaxY = redisCacheInfo.commandStats?.fold(0, (previousValue, element) {
          return max(previousValue!, element.value!);
        }) ??
        0;
  }

  //根据index获取名利名称
  String getCommandNameByIndex(int index, {bool abbreviation = false}) {
    String name = redisCacheInfo.commandStats?[index].name ?? "";
    if (abbreviation && TextUtil.isNotEmpty(name)) {
      return name.substring(0, 1).toUpperCase();
    }
    return name;
  }

  // 更新命令统计的baselineX
  void updateCommandStatsBaseLineX(double commandStatsBaseLineX) {
    this.commandStatsBaseLineX = commandStatsBaseLineX;
    shouldSetState.updateVersion();
    notifyListeners();
  }
}
