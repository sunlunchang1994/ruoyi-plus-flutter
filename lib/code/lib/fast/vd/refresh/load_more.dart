import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';

import '../../../../../generated/l10n.dart';

/// @author sunlunchang
/// 列表页 状态为加载更多时展示
class LoadMoreWidget extends StatelessWidget {
  const LoadMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(S.current.label_refresh_loading,
          style:
              SlcStyles.getTextColorSecondaryStyleByTheme(Theme.of(context))),
    ));
  }
}
