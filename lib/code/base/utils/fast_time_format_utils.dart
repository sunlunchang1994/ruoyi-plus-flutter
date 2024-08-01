import 'package:flutter_scaffold_single/code/base/config/constant_base.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:intl/intl.dart';

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
    return DateFormat(ConstantBase.VALUE_TIME_PATTERN_BY_Y_MC_CH).format(
        DateFormat(ConstantBase.VALUE_TIME_PATTERN_BY_Y_MC_COMMON).parse(date));
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
    return DateFormat(ConstantBase.VALUE_TIME_PATTERN_BY_Y_D_CH).format(
        DateFormat(ConstantBase.VALUE_TIME_PATTERN_BY_Y_D_COMMON).parse(date));
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
    return DateFormat(ConstantBase.VALUE_TIME_PATTERN_BY_Y_M_CH).format(
        DateFormat(ConstantBase.VALUE_TIME_PATTERN_BY_Y_M_COMMON).parse(date));
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
    return DateFormat(ConstantBase.VALUE_TIME_PATTERN_BY_H_M_COMMON).format(
        DateFormat(ConstantBase.VALUE_TIME_PATTERN_BY_Y_S_COMMON).parse(date));
  }
}
