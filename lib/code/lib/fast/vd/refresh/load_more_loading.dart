import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';

import '../../../../../generated/l10n.dart';

/// @author sunlunchang
/// 列表页 加载更多控件
class LoadMoreLoadingWidget extends StatelessWidget {
  const LoadMoreLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              )),
          Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: new Text(S.current.label_refresh_loading,
                  style: themeData.slcTidyUpStyle
                      .getTextColorSecondaryStyleByTheme(themeData))),
        ],
      ),
    );
  }
}
