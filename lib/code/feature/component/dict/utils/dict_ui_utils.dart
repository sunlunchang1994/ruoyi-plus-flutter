import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/widget/form/fast_form_builder_field_option.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../res/colors.dart';
import '../entity/tree_dict.dart';

class DictUiUtils {
  ///字典列表转对话框选项
  static List<SimpleDialogOption> dictList2DialogItem(
      BuildContext context,
      List<ITreeDict<dynamic>> treeDictList,
      final void Function(ITreeDict<dynamic>) onPressed,
      {bool autoPopDialog = true,
      bool resultGrowable = true}) {
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
    }).toList(growable: resultGrowable);
  }

  ///显示选择对话框
  static Future<T?> showSelectDialog<T>(BuildContext context, String dictType,
      final void Function(ITreeDict<dynamic>) onPressed,
      {String? title, bool autoPopDialog = true, bool resultGrowable = false}) {
    return showDialog<T?>(
        context: context,
        builder: (context) {
          List<SimpleDialogOption> dialogItem = dictList2DialogItem(
              context, GlobalVm().dictShareVm.dictMap[dictType]!, onPressed,
              autoPopDialog: autoPopDialog, resultGrowable: resultGrowable);
          return SimpleDialog(
              title: Text(title ?? S.current.app_label_please_choose),
              children: dialogItem);
        });
  }

  ///字典列表转表单选项
  static List<FormBuilderFieldOption<OptionVL<String>>> dictList2FromOption(
      List<ITreeDict<dynamic>> treeDictList) {
    if (treeDictList.isEmpty) {
      return [];
    }
    return treeDictList.map((item) {
      return VLFormBuilderFieldOption<String>(
          value: OptionVL<String>(item.tdDictValue!, item.tdDictLabel!));
    }).toList(growable: true);
  }

  ///字典转表单选项
  static OptionVL<String>? dict2OptionVL(ITreeDict<dynamic>? treeDict) {
    if (treeDict == null) {
      return null;
    }
    return OptionVL<String>(treeDict.tdDictValue!, treeDict.tdDictLabel!);
  }

  static Color getDictStyle(String dictType, String? dictKey) {
    ITreeDict<dynamic>? dictData = GlobalVm().dictShareVm.findDict(dictType, dictKey);
    if (dictData == null) {
      AppColors.getStatusColorByTag(AppColors.STATUS_TAG_DEFAULT);
    }
    return AppColors.getStatusColorByTag(dictData!.tdListStyle);
  }
}
