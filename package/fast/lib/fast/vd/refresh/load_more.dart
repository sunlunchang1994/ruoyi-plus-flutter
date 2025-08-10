import 'package:fast/gen/l10n.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_extension.dart';

/// @author sunlunchang
/// 列表页 状态为加载更多时展示
class LoadMoreWidget extends StatelessWidget {
  const LoadMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(FastS.of(context).label_refresh_loading,
          style:
              themeData.slcTidyUpStyle.getTextColorSecondaryStyleByTheme(themeData)),
    ));
  }
}
