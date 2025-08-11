import 'package:fast/gen/assets.gen.dart';
import 'package:fast/gen/l10n.dart';
import 'package:fast/package_info.dart';
import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_extension.dart';
import 'package:flutter_svg/svg.dart';

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
          SvgPicture.asset(Assets.fast.images.icNoData,
              package: FastPkgInfo.packageName,
              height: 72,
              color: themeData.slcTidyUpColor.getTextColorHintByTheme(themeData)),
          Padding(
              padding: EdgeInsets.only(top: SlcDimens.appDimens8),
              child: Text(FastS.of(context).label_data_is_null,
                  style: themeData.slcTidyUpStyle.getTextColorHintStyleByTheme(themeData)))
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
