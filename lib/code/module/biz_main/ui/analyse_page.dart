import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/module/biz_main/repository/analyse_repository.dart';

import '../../../../generated/l10n.dart';
import '../entity/analyse_model.dart';

class AnalysePage extends StatefulWidget {
  const AnalysePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AnalysePage();
  }
}

class _AnalysePage extends AppBaseState<AnalysePage, _AnalyseVm>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_AnalyseVm>(
        create: (context) => _AnalyseVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return Scaffold(
            appBar: AppBar(
                title: Text(S.current.main_label_analyse),
                titleSpacing: NavigationToolbar.kMiddleSpacing),
            body: SingleChildScrollView(
              child: Column(children: [
                _getTopCardWidget(themeData),
                ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                _getWeekOnlineStatistics(themeData),
                ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                _getTrafficTrendsStatistics(themeData),
                ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                _getBrowseMonthStatisticsBar(themeData),
                ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                _getAccessSourceStatistics(themeData),
                ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                _getAccessTrendsStatistics(themeData),
              ]),
            ),
          );
        });
  }

  Widget _getTopCardWidget(ThemeData themeData) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
        child: Column(spacing: SlcDimens.appDimens16, children: [
          Row(
            spacing: SlcDimens.appDimens16,
            children: [
              _getTopCardItem(themeData, () {
                return [
                  Text("用户量", style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                  Text("2000",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeData.colorScheme.primary)),
                ];
              }),
              _getTopCardItem(themeData, () {
                return [
                  Text("访问量", style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                  Text("12000",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeData.colorScheme.primary)),
                ];
              })
            ],
          ),
          Row(
            spacing: SlcDimens.appDimens16,
            children: [
              _getTopCardItem(themeData, () {
                return [
                  Text("下载量", style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                  Text("1800",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeData.colorScheme.primary)),
                ];
              }),
              _getTopCardItem(themeData, () {
                return [
                  Text("使用量", style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                  Text("5800",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: themeData.colorScheme.primary)),
                ];
              })
            ],
          )
        ]));
  }

  Widget _getTopCardItem(ThemeData themeData, List<Widget> Function() getContent) {
    return Expanded(
        child: Card(
            margin: EdgeInsets.zero,
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
                  children: getContent.call(),
                ))));
  }

  AxisTitles getBottomAxisTitles(String Function(double value, TitleMeta meta)? getTitlesText,
      {double reservedSize = 36}) {
    return AxisTitles(
      sideTitles: SideTitles(
          showTitles: true,
          reservedSize: reservedSize,
          getTitlesWidget: (value, meta) {
            return SideTitleWidget(
              angle: 0.5,
              meta: meta,
              child: Text(getTitlesText?.call(value, meta) ?? value.toString()),
            );
          }),
    );
  }

  AxisTitles getLeftAxisTitles(
      {String Function(double value, TitleMeta meta)? getTitlesText, double reservedSize = 36}) {
    return AxisTitles(
      sideTitles: SideTitles(
          minIncluded: false, maxIncluded: false, showTitles: true, reservedSize: reservedSize),
    );
  }

  FlBorderData getFlBorderData(ThemeData themeData) {
    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: themeData.slcTidyUpColor.getDividerColorByTheme(themeData), width: 2),
        left: BorderSide(color: themeData.slcTidyUpColor.getDividerColorByTheme(themeData), width: 2),
        right: BorderSide.none,
        top: BorderSide.none,
      ),
    );
  }

  LineTouchData getLineTouchData(ThemeData themeData,
      {String Function(LineBarSpot touchedSpot)? getTooltipText}) {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          getTooltipColor: (touchedSpot) => themeData.colorScheme.surface,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = TextStyle(
                color: touchedSpot.bar.gradient?.colors.first ??
                    touchedSpot.bar.color ??
                    themeData.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem(
                  getTooltipText?.call(touchedSpot) ?? touchedSpot.y.toString(), textStyle);
            }).toList();
          }),
    );
  }

  LineChartBarData getLineChartBarData(ThemeData themeData, List<FlSpot> spots,
      {FlDotData? flDotData}) {
    return LineChartBarData(
      isCurved: true,
      color: themeData.colorScheme.primary,
      barWidth: 3,
      curveSmoothness: 0.35,
      isStrokeCapRound: true,
      isStrokeJoinRound: true,
      preventCurveOverShooting: true,
      preventCurveOvershootingThreshold: 0,
      dotData: flDotData ?? const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            ColorTween(begin: themeData.colorScheme.primary, end: themeData.colorScheme.primary)
                .lerp(0.2)!
                .withValues(alpha: 0.1),
            ColorTween(begin: themeData.colorScheme.primary, end: themeData.colorScheme.primary)
                .lerp(0.2)!
                .withValues(alpha: 0.1),
          ],
        ),
      ),
      spots: spots,
    );
  }

  /// 周在线统计
  Widget _getWeekOnlineStatistics(ThemeData themeData) {
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
                Text(S.current.analyse_label_week_online,
                    style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                ThemeUtil.getSizedBox(height: SlcDimens.appDimens12),
                NqSelector<_AnalyseVm, List<WeekOnline>>(builder: (context, weekOnlineList, child) {
                  return AspectRatio(
                      aspectRatio: 1.4,
                      child: weekOnlineList.isEmpty
                          ? CircularProgressIndicator()
                          : LineChart(LineChartData(
                              //clipData: FlClipData(top: true, bottom: false, left: true, right: true),
                              gridData: FlGridData(show: true),
                              titlesData: FlTitlesData(
                                bottomTitles: getBottomAxisTitles((value, meta) {
                                  return weekOnlineList[value.round()].date;
                                }),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: getLeftAxisTitles(),
                              ),
                              borderData: getFlBorderData(themeData),
                              lineTouchData: getLineTouchData(themeData,
                                  getTooltipText: (touchedSpot) =>
                                      "${weekOnlineList[touchedSpot.x.toInt()].date}：${touchedSpot.y.round().toString()}人"),
                              lineBarsData: () {
                                List<LineChartBarData> widgets = List.empty(growable: true);
                                widgets.add(getLineChartBarData(
                                    themeData,
                                    () {
                                      List<FlSpot> flSpots = List.empty(growable: true);
                                      if (weekOnlineList.isEmpty) {
                                        return flSpots;
                                      }
                                      int count = weekOnlineList.length;
                                      for (double i = 0; i < count; i += 1) {
                                        WeekOnline weekOnline = weekOnlineList[i.round()];
                                        flSpots.add(FlSpot(i, weekOnline.count.toDouble()));
                                      }
                                      return flSpots;
                                    }.call()));
                                return widgets;
                              }.call(),
                              minY: 0)));
                }, selector: (context, vm) {
                  return vm.weekOnlineList;
                })
              ],
            )));
  }

  ///日浏览趋势
  Widget _getTrafficTrendsStatistics(ThemeData themeData) {
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
                Text(S.current.analyse_label_traffic_trends,
                    style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                ThemeUtil.getSizedBox(height: SlcDimens.appDimens12),
                NqSelector<_AnalyseVm, List<BrowseTrends>>(
                    builder: (context, browseTrendsList, child) {
                  return AspectRatio(
                      aspectRatio: 1.4,
                      child: browseTrendsList.isEmpty
                          ? CircularProgressIndicator()
                          : LineChart(LineChartData(
                              //clipData: FlClipData(top: true, bottom: false, left: true, right: true),
                              gridData: FlGridData(show: true),
                              titlesData: FlTitlesData(
                                bottomTitles: getBottomAxisTitles((value, meta) {
                                  int index = value.round();
                                  if (index >= browseTrendsList.length) {
                                    return AnalyseRepository.getBrowseTrendHour(index);
                                  }
                                  return browseTrendsList[index].hour;
                                }),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: getLeftAxisTitles(),
                              ),
                              borderData: getFlBorderData(themeData),
                              lineTouchData: getLineTouchData(themeData,
                                  getTooltipText: (touchedSpot) =>
                                      "${browseTrendsList[touchedSpot.x.toInt()].hour}：${touchedSpot.y.round().toString()}"),
                              lineBarsData: () {
                                List<LineChartBarData> widgets = List.empty(growable: true);
                                widgets.add(getLineChartBarData(
                                    themeData,
                                    () {
                                      List<FlSpot> flSpots = List.empty(growable: true);
                                      if (browseTrendsList.isEmpty) {
                                        return flSpots;
                                      }
                                      int count = browseTrendsList.length;
                                      for (double i = 0; i < count; i += 1) {
                                        BrowseTrends browseTrends = browseTrendsList[i.round()];
                                        flSpots.add(FlSpot(i, browseTrends.count.toDouble()));
                                      }
                                      return flSpots;
                                    }.call(),
                                    flDotData: FlDotData(
                                        show: true,
                                        getDotPainter: (
                                          FlSpot spot,
                                          double xPercentage,
                                          LineChartBarData bar,
                                          int index, {
                                          double? size,
                                        }) {
                                          return FlDotCirclePainter(
                                            radius: 3,
                                            color: themeData.colorScheme.primary,
                                            strokeColor: Colors.transparent,
                                          );
                                        })));
                                return widgets;
                              }.call(),
                              minX: 0,
                              maxX: 23)));
                }, selector: (context, vm) {
                  return vm.browseTrendsList;
                })
              ],
            )));
  }

  // 月访问统计图
  Widget _getBrowseMonthStatisticsBar(ThemeData themeData) {
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
                Text(S.current.analyse_label_month_visits,
                    style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                ThemeUtil.getSizedBox(height: SlcDimens.appDimens12),
                NqSelector<_AnalyseVm, List<BrowseMonth>>(
                    builder: (context, browseMonthList, child) {
                  return Column(
                    children: [
                      AspectRatio(
                          aspectRatio: 1,
                          child: browseMonthList.isEmpty
                              ? CircularProgressIndicator()
                              : BarChart(
                                  BarChartData(
                                      gridData: FlGridData(show: true),
                                      titlesData: FlTitlesData(
                                          bottomTitles: getBottomAxisTitles((value, meta) {
                                            return browseMonthList[value.round()].month;
                                          }),
                                          rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles: SideTitles(showTitles: false),
                                          ),
                                          leftTitles: getLeftAxisTitles(
                                              getTitlesText: (value, meta) {
                                                return value.round().toString();
                                              },
                                              reservedSize: 48)),
                                      borderData: getFlBorderData(themeData),
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
                                                  "${browseMonthList[groupIndex].month}:${rod.toY.round().toString()}",
                                                  textStyle);
                                            },
                                            fitInsideVertically: true),
                                      ),
                                      barGroups: () {
                                        List<BarChartGroupData> widgets =
                                            List.empty(growable: true);
                                        List<BrowseMonth> browseMonthList = getVm().browseMonthList;
                                        if (browseMonthList.isEmpty) {
                                          return widgets;
                                        }
                                        int count = browseMonthList.length;
                                        for (int i = 0; i < count; i += 1) {
                                          BrowseMonth browseMonth = browseMonthList[i.round()];
                                          widgets.add(BarChartGroupData(x: i, barRods: [
                                            BarChartRodData(
                                              width: 16,
                                              toY: browseMonth.count.toDouble(),
                                              color: themeData.colorScheme.primary,
                                              borderRadius: const BorderRadius.vertical(
                                                  top: Radius.circular(16)),
                                            )
                                          ]));
                                        }
                                        return widgets;
                                      }.call()),
                                )),
                    ],
                  );
                }, selector: (context, vm) {
                  return vm.browseMonthList;
                }),
              ],
            )));
  }

  // 来源统计
  Widget _getAccessSourceStatistics(ThemeData themeData) {
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
                Text(S.current.analyse_label_access_source,
                    style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                ThemeUtil.getSizedBox(height: SlcDimens.appDimens12),
                NqSelector<_AnalyseVm, List<AccessSource>>(
                    builder: (context, accessSourceList, child) {
                  return AspectRatio(
                      aspectRatio: 1.4,
                      child: accessSourceList.isEmpty
                          ? CircularProgressIndicator()
                          : PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  enabled: true,
                                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection == null) {
                                      return;
                                    }
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
                                  int count = accessSourceList.length;
                                  if (count == 0) {
                                    return pieChartSectionData;
                                  }
                                  for (int i = 0; i < count; i++) {
                                    AccessSource accessSource = accessSourceList[i];
                                    pieChartSectionData.add(PieChartSectionData(
                                        showTitle: true,
                                        titlePositionPercentageOffset: 0.6,
                                        titleStyle: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold),
                                        color: Color(accessSource.color),
                                        value: accessSource.count.toDouble(),
                                        title: "${accessSource.type}\n${accessSource.count}",
                                        radius: ScreenUtil.getInstance().screenWidthDpr / 3.5));
                                  }
                                  return pieChartSectionData;
                                }.call(),
                              ),
                            ));
                }, selector: (context, vm) {
                  return vm.accessSourceList;
                }),
              ],
            )));
  }

  //访问趋势
  Widget _getAccessTrendsStatistics(ThemeData themeData) {
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
                Text(S.current.analyse_label_access_trends,
                    style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData)),
                ThemeUtil.getSizedBox(height: SlcDimens.appDimens6),
                NqSelector<_AnalyseVm, List<AccessTrends>>(
                    builder: (context, accessTrendsList, child) {
                  return AspectRatio(
                      aspectRatio: 1,
                      child: accessTrendsList.isEmpty
                          ? CircularProgressIndicator()
                          : RadarChart(
                              RadarChartData(
                                radarTouchData: RadarTouchData(
                                  enabled: true,
                                  touchSpotThreshold: 16,
                                  touchCallback: (FlTouchEvent event, response) {
                                    int? touchedDataSetIndex =
                                        response?.touchedSpot?.touchedDataSetIndex;
                                    LogUtil.d(touchedDataSetIndex);
                                    if (!event.isInterestedForInteractions &&
                                        touchedDataSetIndex == null) {
                                      for (var element in accessTrendsList) {
                                        element.selected = false;
                                      }
                                      getVm().accessTrendsList = List.from(accessTrendsList);
                                      getVm().notifyListeners();
                                      return;
                                    }
                                    for (int i = 0; i < accessTrendsList.length; i++) {
                                      accessTrendsList[i].selected = i == touchedDataSetIndex;
                                    }
                                    getVm().accessTrendsList = List.from(accessTrendsList);
                                    getVm().notifyListeners();
                                  },
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                ),
                                radarBackgroundColor: Colors.transparent,
                                radarBorderData: BorderSide(
                                    color: themeData.slcTidyUpColor.getDividerColorByTheme(themeData),
                                    width: 2),
                                radarShape: RadarShape.polygon,
                                tickCount: 3,
                                ticksTextStyle: TextStyle(
                                    color: themeData.colorScheme.onSurfaceVariant, fontSize: 10),
                                tickBorderData: BorderSide(
                                    color: themeData.slcTidyUpColor.getDividerColorByTheme(themeData),
                                    width: 1),
                                gridBorderData: BorderSide(
                                    color: themeData.slcTidyUpColor.getDividerColorByTheme(themeData),
                                    width: 1),
                                titlePositionPercentageOffset: 0.08,
                                titleTextStyle:
                                    TextStyle(color: themeData.colorScheme.onSurface, fontSize: 14),
                                getTitle: (index, angle) {
                                  //final usedAngle = angle;
                                  final usedAngle = 0.0;
                                  return RadarChartTitle(
                                    text: accessTrendsList.first.accessTrendsItemList[index].label,
                                    angle: usedAngle,
                                  );
                                },
                                dataSets: () {
                                  List<RadarDataSet> radarDataSetList = List.empty(growable: true);
                                  int count = accessTrendsList.length;
                                  if (count == 0) {
                                    return radarDataSetList;
                                  }
                                  for (int i = 0; i < count; i++) {
                                    AccessTrends accessTrends = accessTrendsList[i];
                                    Color accessTrendsColor = Color(accessTrends.color);
                                    radarDataSetList.add(RadarDataSet(
                                      fillColor: accessTrends.selected
                                          ? accessTrendsColor.withValues(alpha: 0.3)
                                          : accessTrendsColor.withValues(alpha: 0.15),
                                      borderColor: accessTrends.selected
                                          ? accessTrendsColor
                                          : accessTrendsColor.withValues(alpha: 0.3),
                                      entryRadius: accessTrends.selected ? 3 : 2,
                                      borderWidth: accessTrends.selected ? 2.5 : 2,
                                      dataEntries: accessTrends.accessTrendsItemList
                                          .map((e) => RadarEntry(value: e.count.toDouble()))
                                          .toList(),
                                    ));
                                  }
                                  return radarDataSetList;
                                }.call(),
                              ),
                            ));
                }, selector: (context, vm) {
                  return vm.accessTrendsList;
                }),
              ],
            )));
  }

  @override
  bool get wantKeepAlive => true;
}

/// 分析VM
class _AnalyseVm extends AppBaseVm {
  List<WeekOnline> weekOnlineList = [];
  List<BrowseTrends> browseTrendsList = [];
  List<BrowseMonth> browseMonthList = [];
  List<AccessSource> accessSourceList = [];
  List<AccessTrends> accessTrendsList = [];

  void initVm() {
    AnalyseRepository.getWeekOnline().then((value) {
      weekOnlineList = value;
      notifyListeners();
    });
    AnalyseRepository.getBrowseTrends().then((value) {
      browseTrendsList = value;
      notifyListeners();
    });
    AnalyseRepository.getBrowseMonth().then((value) {
      browseMonthList = value;
      notifyListeners();
    });
    AnalyseRepository.getAccessSource().then((value) {
      accessSourceList = value;
      notifyListeners();
    });
    AnalyseRepository.getAccessTrends().then((value) {
      accessTrendsList = value;
      notifyListeners();
    });
  }
}
