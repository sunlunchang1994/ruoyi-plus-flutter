import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';

import '../../../../../generated/l10n.dart';

/// @author sunlunchang
/// 列表页 加载更多成功控件
class LoadMoreSucceedWidget extends StatelessWidget {
  const LoadMoreSucceedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Center(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(S.current.label_refresh_loading_succeed,
                style: themeData.slcTidyUpStyle.getTextColorSecondaryStyleByTheme(Theme.of(context)))));
  }
}
