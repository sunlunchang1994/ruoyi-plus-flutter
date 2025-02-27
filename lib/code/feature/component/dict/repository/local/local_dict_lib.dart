import '../../entity/tree_dict.dart';

class LocalDictLib {

  //系统状态
  static const String CODE_SYS_NORMAL_DISABLE = "sys_normal_disable";
  //系统状态：正常
  static const KEY_SYS_NORMAL_DISABLE_NORMAL = "0";
  //系统状态：停用
  static const KEY_SYS_NORMAL_DISABLE_STOP = "1";

  //系统是否
  static const String CODE_SYS_YES_NO = "sys_yes_no";
  //系统是否：是
  static const KEY_SYS_YES_NO_Y = "Y";
  //系统是否：否
  static const KEY_SYS_YES_NO_N = "N";

  //系统是否 整数
  static const String CODE_SYS_YES_NO_INT = "sys_yes_no_int";
  //系统是否 整：是
  static const KEY_SYS_YES_NO_INT_Y = "0";
  //系统是否 整：否
  static const KEY_SYS_YES_NO_INT_N = "1";

  //菜单显示状态
  static const String CODE_SYS_SHOW_HIDE= "sys_show_hide";
  //菜单显示状态：显示
  static const KEY_SYS_SHOW_HIDE_S = "0";
  //菜单显示状态：隐藏
  static const KEY_SYS_SHOW_HIDE_H = "1";

  //性别
  static const String CODE_SEX = "sec";
  //性别：男
  static const KEY_SEX_MAN = "0";
  //性别：女
  static const KEY_SEX_WOMAN = "1";

  //菜单类型
  static const String CODE_MENU_TYPE = "menu_type";
  //菜单类型：目录
  static const KEY_MENU_TYPE_MULU = "M";
  //菜单类型：菜单
  static const KEY_MENU_TYPE_CAIDAN = "C";
  //菜单类型：事件
  static const KEY_MENU_TYPE_ACTION = "F";

  static final Map<String, List<ITreeDict<dynamic>>> DICT_MAP = {
    CODE_SYS_NORMAL_DISABLE: [
      TreeDict(code: CODE_SYS_NORMAL_DISABLE, dictKey: KEY_SYS_NORMAL_DISABLE_NORMAL, dictValue: "正常"),
      TreeDict(code: CODE_SYS_NORMAL_DISABLE, dictKey: KEY_SYS_NORMAL_DISABLE_STOP, dictValue: "停用"),
    ],
    CODE_SYS_YES_NO: [
      TreeDict(code: CODE_SYS_YES_NO, dictKey: KEY_SYS_YES_NO_Y, dictValue: "是"),
      TreeDict(code: CODE_SYS_YES_NO, dictKey: KEY_SYS_YES_NO_N, dictValue: "否"),
    ],
    CODE_SYS_YES_NO_INT: [
      TreeDict(code: CODE_SYS_YES_NO_INT, dictKey: KEY_SYS_YES_NO_INT_Y, dictValue: "是"),
      TreeDict(code: CODE_SYS_YES_NO_INT, dictKey: KEY_SYS_YES_NO_INT_N, dictValue: "否"),
    ],
    CODE_SYS_SHOW_HIDE: [
      TreeDict(code: CODE_SYS_SHOW_HIDE, dictKey: KEY_SYS_SHOW_HIDE_S, dictValue: "显示"),
      TreeDict(code: CODE_SYS_SHOW_HIDE, dictKey: KEY_SYS_SHOW_HIDE_H, dictValue: "隐藏"),
    ],
    CODE_SEX: [
      TreeDict(code: CODE_SEX, dictKey: KEY_SEX_MAN, dictValue: "男"),
      TreeDict(code: CODE_SEX, dictKey: KEY_SEX_WOMAN, dictValue: "女"),
    ],
    CODE_MENU_TYPE: [
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_MENU_TYPE_MULU, dictValue: "目录"),
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_MENU_TYPE_CAIDAN, dictValue: "菜单"),
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_MENU_TYPE_ACTION, dictValue: "按钮"),
    ]
  };

  ///
  ///根据code查询字典
  ///如果服务端配置了规则，请不要用此本地方法
  ///
  static ITreeDict<dynamic>? findDictByCodeKey(String code, String? dictKey,{String? defDictKey}) {
    dictKey ??= defDictKey;
    if (dictKey == null) {
      return null;
    }
    try {
      return DICT_MAP[code]?.firstWhere((item) {
        return item.tdDictValue == dictKey;
      });
    } catch (e) {
      return null;
    }
  }
}
