import 'package:boxes_flutter/flutter/slc/mvvm/base_mvvm.dart';

import '../entity/tree_dict.dart';
import '../utils/dict_ui_utils.dart';

/// @author slc
/// 字典共享
class DictShareVm extends AbsoluteChangeNotifier {
  final Map<String, List<ITreeDict<dynamic>>?> dictMap = {};

  DictShareVm._privateConstructor();

  static final DictShareVm _instance = DictShareVm._privateConstructor();

  factory DictShareVm() {
    return _instance;
  }

  ///
  ITreeDict<dynamic>? findDict(String code, String? dictKey, {String? defDictKey}) {
    return DictUiUtils.findDictByDataList(dictMap[code], dictKey, defDictKey: defDictKey);
  }
}
