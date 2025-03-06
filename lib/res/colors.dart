import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';

class AppColors extends SlcColors {
  //状态
  static const String STATUS_TAG_DEFAULT = "default";
  static const String STATUS_TAG_PRIMARY = "primary";
  static const String STATUS_TAG_SUCCESS = "success";
  static const String STATUS_TAG_INFO = "info";
  static const String STATUS_TAG_WARNING = "warning";
  static const String STATUS_TAG_DANGER = "danger";

  static Color getStatusColor(bool? status) {
    if (status == null) {
      return getStatusColorByTag(STATUS_TAG_DEFAULT);
    }
    if (status) {
      return getStatusColorByTag(STATUS_TAG_SUCCESS);
    }
    return getStatusColorByTag(STATUS_TAG_DANGER);
  }

  static Color getStatusColorByTag(String? tag) {
    var defColor = Colors.white38;
    if (tag == null) {
      return defColor;
    }
    switch (tag) {
      case STATUS_TAG_DEFAULT:
        return defColor;
      case STATUS_TAG_PRIMARY:
        return SlcColors.globalUiColorBlue1;
      case STATUS_TAG_SUCCESS:
        return SlcColors.globalUiColorGreen1;
      case STATUS_TAG_INFO:
        return SlcColors.globalUiColorPurple1;
      case STATUS_TAG_WARNING:
        return SlcColors.globalUiColorOrange2;
      case STATUS_TAG_DANGER:
        return SlcColors.globalUiColorRed1;
    }
    return defColor;
  }
}
