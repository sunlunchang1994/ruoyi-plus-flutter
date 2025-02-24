import '../../entity/tree_dict.dart';

class LocalDictLib {

  //系统状态
  static const String CODE_SYS_NORMAL_DISABLE = "sys_normal_disable";
  //系统状态：正常
  static const KEY_SYS_NORMAL_DISABLE_NORMAL = "0";
  //系统状态：停用
  static const KEY_SYS_NORMAL_DISABLE_STOP = "1";

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
    CODE_SEX: [
      TreeDict(code: CODE_SEX, dictKey: KEY_SEX_MAN, dictValue: "男"),
      TreeDict(code: CODE_SEX, dictKey: KEY_SEX_WOMAN, dictValue: "女"),
    ],
    CODE_MENU_TYPE: [
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_MENU_TYPE_MULU, dictValue: "目录"),
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_MENU_TYPE_CAIDAN, dictValue: "菜单"),
      TreeDict(code: CODE_MENU_TYPE, dictKey: KEY_MENU_TYPE_ACTION, dictValue: "事件"),
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
