import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// @Author sunlunchang
/// toast桥接类
class AppToastBridge {
  static void showToast({msg = String, ToastBridgeDuration? toastDuration}) {
    //BotToast.showText(text: msg);
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.black54,
        toastLength: toastDuration == ToastBridgeDuration.LENGTH_LONG
            ? Toast.LENGTH_LONG
            : Toast.LENGTH_SHORT);
  }
}

enum ToastBridgeDuration {
  /// Show Short toast for 1 sec
  LENGTH_SHORT,

  /// Show Long toast for 5 sec
  LENGTH_LONG
}
