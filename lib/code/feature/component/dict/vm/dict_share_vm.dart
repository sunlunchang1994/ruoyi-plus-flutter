import 'package:flutter_slc_boxes/flutter/slc/common/object_util.dart';

import '../entity/tree_dict.dart';

///@author slc
class DictShareVm {
  final Map<String, List<ITreeDict<dynamic>>> dictMap = {};

  DictShareVm() {}

  ///
  ///根据code查询字典
  ///如果服务端配置了规则，请不要用此本地方法
  ///
  ITreeDict<dynamic>? findDict(String code, String? dictKey,
      {String? defDictKey}) {
    List<ITreeDict<dynamic>>? dictDataList = dictMap[code];
    if (ObjectUtil.isEmptyList(dictDataList)) {
      //数据列表为空直接返回
      return null;
    }
    if (dictKey != null) {
      //指定的dictKey不为空时，直接查询，查询不到返回空
      try {
        return dictDataList!.firstWhere((item) {
          return item.tdDictValue == dictKey;
        });
      } catch (e) {
        return null;
      }
    }
    try {
      //先通过tdIsDefault查询
      ITreeDict<dynamic>? targetDict = dictDataList!.firstWhere((item) {
        return item.tdIsDefault;
      }, orElse: () {
        //查询不到通过defDictKey查询，查询不到返回空
        return dictDataList.firstWhere((item) {
          return item.tdDictValue == defDictKey;
        });
      });
      return targetDict;
    } catch (e) {
      return null;
    }
  }


}
