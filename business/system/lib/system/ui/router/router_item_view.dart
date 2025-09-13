import 'package:flutter/material.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_extension.dart';

import 'package:base/gen/assets.gen.dart';
import 'package:base/package_base_info.dart';
import 'package:bizapi/system/entity/router_vo.dart';

/// @author sunlunchang
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
        color: themeData.slcTidyUpColor.getCardColorByTheme(themeData),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.icAppLogo.image(
                  package: BasePkgInfo.packageName,
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
