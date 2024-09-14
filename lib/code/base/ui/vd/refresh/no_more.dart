import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';

import '../../../../../generated/l10n.dart';

/// @Author sunlunchang
/// 列表页 没有更多数据了控件
class NoMoreWidget extends StatelessWidget {
  const NoMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(S.current.label_refresh_loading_no_more,
                style: SlcStyles.getTextColorHintStyleByTheme(
                    Theme.of(context)))));
  }
}
