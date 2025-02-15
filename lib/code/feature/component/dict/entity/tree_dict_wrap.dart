import 'package:ruoyi_plus_flutter/code/feature/component/dict/entity/tree_dict.dart';

///
/// @author: sunlunchang
///
class TreeDictWrap {
  List<ITreeDict<dynamic>>? _sysDictList;
  List<String> _dictLabelArray = [];

  TreeDictWrap();

  TreeDictWrap.fromList(List<ITreeDict<dynamic>> sysDictList) {
    setSysDictList(sysDictList);
  }

  List<ITreeDict<dynamic>>? get sysDictList => _sysDictList;

  void setSysDictList(List<ITreeDict<dynamic>>? sysDictList) {
    _sysDictList = sysDictList ?? [];
    _dictLabelArray = _dictList2LabelArray(_sysDictList!);
  }

  List<String> get dictLabelArray => _dictLabelArray;

  void setDictLabelArray(List<String> dictLabelArray) {
    _dictLabelArray = dictLabelArray;
  }

  static List<String> _dictList2LabelArray(List<ITreeDict<dynamic>> dictList) {
    if (dictList.isEmpty) {
      return [];
    }
    return dictList.map((item) => item.tdDictLabel?.isEmpty ?? true ? '' : item.tdDictLabel).toList()
        as List<String>;
  }
}
