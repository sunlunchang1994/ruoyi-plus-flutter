import 'dart:io';

///@Author sunlunchang
///基础常量
class ConstantBase {
  ///是否为发布到线上模式；待完善、需去掉不可变
  static const bool IS_RELEASE = false;

  ///文件保存基础路径
  static final String PATH_SAVE_DIR = "${Platform.pathSeparator}file";

  ///时间格式化
  static final String VALUE_TIME_PATTERN_BY_Y_MC_COMMON = "yyyy-MM";
  static final String VALUE_TIME_PATTERN_BY_Y_D_COMMON = "yyyy-MM-dd";
  static final String VALUE_TIME_PATTERN_BY_Y_H_COMMON = "yyyy-MM-dd HH";
  static final String VALUE_TIME_PATTERN_BY_Y_M_COMMON = "yyyy-MM-dd HH:mm";
  static final String VALUE_TIME_PATTERN_BY_Y_S_COMMON = "yyyy-MM-dd HH:mm:ss";
  static final String VALUE_TIME_PATTERN_BY_H_S_COMMON = "HH:mm:ss";
  static final String VALUE_TIME_PATTERN_BY_H_M_COMMON = "HH:mm";
  static final String VALUE_TIME_PATTERN_BY_Y_D_CH = "yyyy年MM月dd日";
  static final String VALUE_TIME_PATTERN_BY_Y_H_CH = "yyyy年MM月dd日 HH时";
  static final String VALUE_TIME_PATTERN_BY_Y_MC_CH = "yyyy年MM月";
  static final String VALUE_TIME_PATTERN_BY_Y_M_CH = "yyyy年MM月dd日 HH:mm";

  ///路由相关
  static const String COMPONENT_LAYOUT = "Layout"; //Layout组件标识
  static const String COMPONENT_PARENT_VIEW = "ParentView"; //ParentView组件标识
  static const String COMPONENT_INNER_LINK = "InnerLink"; //InnerLink组件标识

  ///Intent 标题Key
  static const String INTENT_KEY_TITLE = "title";
}
