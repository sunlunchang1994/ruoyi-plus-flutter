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

  static final Map<String, List<ITreeDict<dynamic>>> DICT_MAP = {
    CODE_SYS_NORMAL_DISABLE: [
      TreeDict(code: CODE_SYS_NORMAL_DISABLE, dictKey: KEY_SYS_NORMAL_DISABLE_NORMAL, dictValue: "正常"),
      TreeDict(code: CODE_SYS_NORMAL_DISABLE, dictKey: KEY_SYS_NORMAL_DISABLE_STOP, dictValue: "停用"),
    ],
    CODE_SEX: [
      TreeDict(code: CODE_SEX, dictKey: KEY_SEX_MAN, dictValue: "男"),
      TreeDict(code: CODE_SEX, dictKey: KEY_SEX_WOMAN, dictValue: "女"),
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
