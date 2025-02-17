import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/fast_form_builder_field_option.dart';

import '../entity/tree_dict.dart';

class DictUiUtils {
  ///字典列表转对话框选项
  static List<SimpleDialogOption> dict2DialogItem(
      BuildContext context,
      List<ITreeDict<dynamic>> treeDictList,
      final void Function(ITreeDict<dynamic>) onPressed,
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

  ///字典列表转表单选项
  static List<FormBuilderFieldOption<OptionVL<String>>> dict2FromOption(
      BuildContext context, List<ITreeDict<dynamic>> treeDictList) {
    if (treeDictList.isEmpty) {
      return [];
    }
    return treeDictList.map((item) {
      return VLFormBuilderFieldOption<String>(
          value: OptionVL<String>(item.tdDictValue!, item.tdDictLabel!));
    }).toList(growable: true);
  }
}
