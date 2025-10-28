import 'dart:io';

///@author sunlunchang
///基础常量
class ConstantBase {
  ///key
  ///IntentData
  static const String KEY_INTENT_DATA = "intentData";
  ///Intent 标题Key
  static const String KEY_INTENT_TITLE = "title";
  ///Intent url
  static const String KEY_INTENT_URL = "url";
  ///Intent 选择的数据
  static const String KEY_INTENT_SELECT_DATA = "selectData";

  ///value
  static final BigInt VALUE_PARENT_ID_DEF = BigInt.zero; //默认父id
  static final String VALUE_PARENT_ID_DEF_STR = VALUE_PARENT_ID_DEF.toString(); //默认父id

  /// path
  ///文件保存基础路径
  static final String PATH_SAVE_DIR = "${Platform.pathSeparator}file";

}
