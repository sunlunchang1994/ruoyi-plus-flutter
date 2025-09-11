import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_extension.dart';

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
            child: Text(FastS.of(context).label_refresh_loading_succeed,
                style: themeData.slcTidyUpStyle.getTextColorSecondaryStyleByTheme(Theme.of(context)))));
  }
}
