import 'package:fast/gen/fast_l10n.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_extension.dart';

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
            child: Text(FastS.of(context).label_refresh_load_failed,
                style: themeData.slcTidyUpStyle
                    .getTextColorSecondaryStyleByTheme(themeData))));
  }
}
