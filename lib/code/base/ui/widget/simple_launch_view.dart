import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';

/// @author sunlunchang
/// 类似桌面样式的图标构建
class SimpleLaunchView extends StatefulWidget {
  final ImageProvider image;
  final Widget label;
  final GestureTapCallback? onTap;
  final double iconSize;

  SimpleLaunchView(this.image, this.label, {this.onTap, this.iconSize = 32});

  @override
  State<StatefulWidget> createState() {
    return _SimpleLaunchState(image, label, onTap, iconSize);
  }
}

class _SimpleLaunchState extends State<SimpleLaunchView> {
  final ImageProvider image;
  final Widget label;
  final GestureTapCallback? onTap;
  final double iconSize;

  _SimpleLaunchState(this.image, this.label, this.onTap, this.iconSize);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              image: image,
              width: iconSize == 0 ? 32 : iconSize,
              height: iconSize == 0 ? 32 : iconSize),
          Padding(
            padding: EdgeInsets.only(top: SlcDimens.appDimens8),
            child: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14),
                child: label),
          )
        ],
      ),
    );
  }
}
