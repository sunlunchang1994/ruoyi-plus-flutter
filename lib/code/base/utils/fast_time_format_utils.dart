import '../config/constant_base.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:intl/intl.dart';

/// @Author sunlunchang
/// 快速时间格式化，方便格式化日期数据
class FastTimeFormatUtils {
  ///
  /// 日期转UI年月
  ///
  /// @param date
  /// @return
  ///
  static String toUiY2MC(String date) {
    if (TextUtil.isEmpty(date)) {
      return "";
    }
    return toTargetFormat(date, ConstantBase.VALUE_TIME_PATTERN_BY_Y_MC_COMMON,
        ConstantBase.VALUE_TIME_PATTERN_BY_Y_MC_CH);
  }

  ///
  /// 日期转UI年月日
  ///
  /// @param date
  /// @return
  ///
  static String toUiY2D(String date) {
    if (TextUtil.isEmpty(date)) {
      return "";
    }
    return toTargetFormat(date, ConstantBase.VALUE_TIME_PATTERN_BY_Y_D_COMMON,
        ConstantBase.VALUE_TIME_PATTERN_BY_Y_D_CH);
  }

  ///
  ///日期转UI日期+时分
  ///
  ///@param date
  ///@return
  ///
  static String toUiY2M(String date) {
    if (TextUtil.isEmpty(date)) {
      return "";
    }
    return toTargetFormat(date, ConstantBase.VALUE_TIME_PATTERN_BY_Y_M_COMMON,
        ConstantBase.VALUE_TIME_PATTERN_BY_Y_M_CH);
  }

  ///
  /// 日期转时分
  ///
  /// @param date
  /// @return
  ///
  static String toUiH2M(String date) {
    if (TextUtil.isEmpty(date)) {
      return "";
    }
    return toTargetFormat(date, ConstantBase.VALUE_TIME_PATTERN_BY_Y_S_COMMON,
        ConstantBase.VALUE_TIME_PATTERN_BY_H_M_COMMON);
  }

  ///
  /// 转换为目标格式
  static String toTargetFormat(
      String date, String srcPattern, String newPattern) {
    return DateFormat(newPattern).format(DateFormat(srcPattern).parse(date));
  }
}
