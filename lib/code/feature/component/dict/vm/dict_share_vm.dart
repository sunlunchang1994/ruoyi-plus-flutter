import 'package:flutter_slc_boxes/flutter/slc/common/object_util.dart';

import '../entity/tree_dict.dart';
import '../utils/dict_ui_utils.dart';

///@author slc
class DictShareVm {
  final Map<String, List<ITreeDict<dynamic>>?> dictMap = {};

  DictShareVm() {}

  ///
  ITreeDict<dynamic>? findDict(String code, String? dictKey,
      {String? defDictKey}) {
    return DictUiUtils.findDictByDataList(dictMap[code],dictKey,defDictKey:defDictKey);
  }



}
