import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';

import '../../../../../generated/l10n.dart';

/// @author sunlunchang
/// 列表页 状态为加载错误时展示
class LoadMoreErrorWidget extends StatelessWidget {
  const LoadMoreErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Center(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(S.current.label_refresh_load_failed,
                style: themeData.slcTidyUpStyle
                    .getTextColorSecondaryStyleByTheme(themeData))));
  }
}
