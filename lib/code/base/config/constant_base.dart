import 'dart:io';

///@Author sunlunchang
///基础常量
class ConstantBase {
  ///key
  ///Intent 标题Key
  static const String KEY_INTENT_TITLE = "title";

  ///value
  ///路由相关
  static const int VALUE_PARENT_ID_DEF = 0; //默认父id
  static final String VALUE_PARENT_ID_DEF_ST = VALUE_PARENT_ID_DEF.toString(); //默认父id

  /// path
  ///文件保存基础路径
  static final String PATH_SAVE_DIR = "${Platform.pathSeparator}file";
}
