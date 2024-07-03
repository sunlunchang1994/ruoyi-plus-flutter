import 'dart:io';

class ConstantBase {
  static final Map<String, dynamic> GLOBAL_CACHE = <String, dynamic>{};

  static const bool IS_DEBUG = true;

  static final String PATH_SAVE_DIR = "${Platform.pathSeparator}file";

  ///时间格式化
  static final String VALUE_TIME_PATTERN_BY_Y_D_COMMON = "yyyy-MM-dd";
  static final String VALUE_TIME_PATTERN_BY_Y_M_COMMON = "yyyy-MM-dd HH:mm";
  static final String VALUE_TIME_PATTERN_BY_Y_S_COMMON = "yyyy-MM-dd HH:mm:ss";
  static final String VALUE_TIME_PATTERN_BY_H_M_COMMON = "HH:mm";
  static final String VALUE_TIME_PATTERN_BY_Y_D_CH = "yyyy年MM月dd日";
  static final String VALUE_TIME_PATTERN_BY_Y_MC_CH = "yyyy年MM月";
  static final String VALUE_TIME_PATTERN_BY_Y_M_CH = "yyyy年MM月dd日 HH:mm";
}
