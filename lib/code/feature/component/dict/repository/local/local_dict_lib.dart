import '../../entity/tree_dict.dart';

class LocalDictLib {
  //code
  static const String CODE_SEX = "sec";

  //value
  //性别：男
  static const KEY_SEX_MAN = "1";

  //性别：女
  static const KEY_SEX_WOMAN = "2";

  static final Map<String, List<ITreeDict<dynamic>>> DICT_MAP = {
    CODE_SEX: [
      TreeDict(code: CODE_SEX, dictKey: KEY_SEX_MAN, dictValue: "男"),
      TreeDict(code: CODE_SEX, dictKey: KEY_SEX_WOMAN, dictValue: "女"),
    ]
  };

  ///
  ///根据code查询字典
  ///如果服务端配置了规则，请不要用此本地方法
  ///
  static ITreeDict<dynamic>? findDictByCodeKey(String code, String? dictKey) {
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
