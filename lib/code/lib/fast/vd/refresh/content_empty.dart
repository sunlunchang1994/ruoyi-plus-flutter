import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../generated/l10n.dart';

///
///@author sunlunchang
///一般页面中或列表页中、当获取的数据为空时，可将此控件放到页面中
///
class ContentEmptyWidget extends StatelessWidget {
  const ContentEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SvgPicture.asset("assets/images/slc/ic_no_date.svg",
              height: 72, color: SlcColors.tidyUpColor.getTextColorHintByTheme(themeData)),
          Padding(
              padding: EdgeInsets.only(top: SlcDimens.appDimens8),
              child: Text(S.current.label_data_is_null,
                  style: SlcStyles.tidyUpStyle.getTextColorHintStyleByTheme(Theme.of(context))))
        ]));
  }

  ///
  /// 获取空视图包装
  ///
  static ContentEmptyWidget? getEmptyWidgetByDataSize(int size) {
    return size <= 0 ? const ContentEmptyWidget() : null;
  }
}

class ContentEmptyWrapper extends StatelessWidget {
  const ContentEmptyWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillViewport(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ContentEmptyWidget();
            },
            childCount: 1,
          ),
        )
      ],
    );
  }

  ///
  /// 获取空视图包装
  ///
  static Widget? getEmptyWrapperByDataSize(int size) {
    return size <= 0 ? const ContentEmptyWrapper() : null;
  }
}
