import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';

import '../../../../extras/system/entity/router_vo.dart';

/// @Author sunlunchang
/// 菜单路由控件
class MenuItemView extends StatelessWidget {
  final RouterVo router;
  final GestureTapCallback? onTap;
  final double iconSize;

  const MenuItemView(this.router, {super.key, this.onTap, this.iconSize = 32});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Ink(
        color: SlcColors.getCardColorByTheme(themeData),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  image: const AssetImage("assets/images/ic_launcher.png"),
                  width: iconSize == 0 ? 32 : iconSize,
                  height: iconSize == 0 ? 32 : iconSize),
              Padding(
                padding: EdgeInsets.only(top: SlcDimens.appDimens8),
                child: DefaultTextStyle(
                    style: themeData.textTheme.labelMedium!.copyWith(fontSize: 14),
                    child: Text(router.getRouterTitle())),
              )
            ],
          ),
        ));
  }
}
