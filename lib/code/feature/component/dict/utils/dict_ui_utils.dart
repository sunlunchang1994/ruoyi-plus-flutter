import 'package:flutter/material.dart';

import '../entity/tree_dict.dart';

class DictUiUtils {
  ///字典列表转对话框选项
  static List<SimpleDialogOption> dict2DialogItem(BuildContext context,
      List<ITreeDict<dynamic>> treeDictList, final void Function(ITreeDict<dynamic>) onPressed,
      {bool autoPopDialog = true}) {
    if (treeDictList.isEmpty) {
      return [];
    }
    return treeDictList.map((item) {
      return SimpleDialogOption(
        child: Text(item.tdDictLabel!),
        onPressed: () {
          onPressed.call(item);
          if (autoPopDialog) {
            Navigator.of(context).pop();
          }
        },
      );
    }).toList(growable: true);
  }
}
