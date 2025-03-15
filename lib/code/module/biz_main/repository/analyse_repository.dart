import 'package:flutter_slc_boxes/flutter/slc/common/date_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/random_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/slc_color_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/slc_num_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:ruoyi_plus_flutter/code/module/biz_main/entity/analyse_model.dart';

class AnalyseRepository {
  /// 获取一周在线人数
  static Future<List<WeekOnline>> getWeekOnline() {
    List<WeekOnline> entityList = List.empty(growable: true);
    int regressDay = 7;
    DateTime now = DateTime.now();
    for (int i = 0; i < regressDay; i++) {
      DateTime dateTime = now.subtract(Duration(days: i));
      WeekOnline weekOnline = WeekOnline(DateUtil.formatDate(dateTime, format: DateFormats.mo_d),
          RandomUtil.randomIntRange(1000, 10000));
      entityList.add(weekOnline);
    }
    return Future.value(entityList.reversed.toList());
  }

  /// 获取当天的流量趋势
  static Future<List<BrowseTrends>> getBrowseTrends() {
    List<int> countList = [
      20000,
      15000,
      10000,
      8000,
      7000,
      4000,
      1000,
      2000,
      18000,
      30000,
      45000,
      50000,
      25000,
      31000,
      40000,
      52000,
      60000,
      55000,
      51000,
      48000,
      46000,
      40000,
      35000,
      30000
    ];
    List<BrowseTrends> entityList = List.empty(growable: true);
    DateTime now = DateTime.now();
    now = now.subtract(Duration(minutes: now.minute));
    int hour = now.hour;
    for (int i = 0; i <= hour; i++) {
      BrowseTrends browseTrends = BrowseTrends(getBrowseTrendHour(i),
          RandomUtil.randomIntRange(countList[i] - 1000, countList[i] + 1000));
      entityList.add(browseTrends);
    }
    return Future.value(entityList);
  }

  static String getBrowseTrendHour(int hour) {
    return "${SlcNumUtil.padZeroByValue(hour, length: 2, padRight: false)!}:00";
  }

  /// 获取月访问统计
  static Future<List<BrowseMonth>> getBrowseMonth() {
    List<BrowseMonth> entityList = List.empty(growable: true);
    for (int i = 0; i < 12; i++) {
      BrowseMonth browseMonth = BrowseMonth("${i + 1}月", RandomUtil.randomIntRange(1000, 10000));
      entityList.add(browseMonth);
    }
    return Future.value(entityList);
  }

  /// 获取访问来源
  static Future<List<AccessSource>> getAccessSource() {
    List<AccessSource> entityList = List.empty(growable: true);
    entityList.add(AccessSource(
        "搜索引擎", RandomUtil.randomIntRange(1000, 2000), SlcColorUtil.COLOR_ARRAY_MD[0]));
    entityList.add(AccessSource(
        "直接访问", RandomUtil.randomIntRange(1000, 2000), SlcColorUtil.COLOR_ARRAY_MD[1]));
    entityList.add(AccessSource(
        "邮件营销", RandomUtil.randomIntRange(1000, 2000), SlcColorUtil.COLOR_ARRAY_MD[2]));
    entityList.add(AccessSource(
        "联盟广告", RandomUtil.randomIntRange(1000, 2000), SlcColorUtil.COLOR_ARRAY_MD[3]));
    return Future.value(entityList);
  }

  /// 获取访问来源
  static Future<List<AccessTrends>> getAccessTrends() {
    List<AccessTrends> entityList = List.empty(growable: true);
    AccessTrends accessTrends1 = new AccessTrends(
        "visit",
        [
          AccessTrendsItem("网页", RandomUtil.randomIntRange(10, 100)),
          AccessTrendsItem("移动端", RandomUtil.randomIntRange(10, 100)),
          AccessTrendsItem("IPad", RandomUtil.randomIntRange(10, 100)),
          AccessTrendsItem("PC客户端", RandomUtil.randomIntRange(10, 100)),
          AccessTrendsItem("第三方", RandomUtil.randomIntRange(10, 100)),
          AccessTrendsItem("其他", RandomUtil.randomIntRange(10, 100))
        ],SlcColorUtil.COLOR_ARRAY_MD[0]);
    entityList.add(accessTrends1);
    AccessTrends accessTrends2 = new AccessTrends(
        "trend",
        [
          AccessTrendsItem("网页", RandomUtil.randomIntRange(10, 100)),
          AccessTrendsItem("移动端", RandomUtil.randomIntRange(10, 100)),
          AccessTrendsItem("IPad", RandomUtil.randomIntRange(10, 100)),
          AccessTrendsItem("PC客户端", RandomUtil.randomIntRange(10, 100)),
          AccessTrendsItem("第三方", RandomUtil.randomIntRange(10, 100)),
          AccessTrendsItem("其他", RandomUtil.randomIntRange(10, 100))
        ],SlcColorUtil.COLOR_ARRAY_MD[2]);
    entityList.add(accessTrends2);
    return Future.value(entityList);
  }
}
