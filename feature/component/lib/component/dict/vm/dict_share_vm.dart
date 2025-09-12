import 'package:boxes_flutter/flutter/slc/common/object_util.dart';

import '../entity/tree_dict.dart';
import '../utils/dict_ui_utils.dart';

/// @author slc
/// 字典共享
class DictShareVm {
  final Map<String, List<ITreeDict<dynamic>>?> dictMap = {};

  DictShareVm() {}

  ///
  ITreeDict<dynamic>? findDict(String code, String? dictKey, {String? defDictKey}) {
    return DictUiUtils.findDictByDataList(dictMap[code], dictKey, defDictKey: defDictKey);
  }
}
