import 'package:fast/gen/l10n.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_extension.dart';

/// @author sunlunchang
/// 列表页 没有更多数据了控件
class NoMoreWidget extends StatelessWidget {
  const NoMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Center(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(FastS.of(context).label_refresh_loading_no_more,
                style: themeData.slcTidyUpStyle.getTextColorHintStyleByTheme(Theme.of(context)))));
  }
}
