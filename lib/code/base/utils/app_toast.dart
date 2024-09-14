import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// @Author sunlunchang
/// toast桥接类
class AppToastBridge {
  static void showToast({msg = String, ToastBridge? toastLength}) {
    //BotToast.showText(text: msg);
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.black54,
        toastLength: toastLength == ToastBridge.LENGTH_LONG
            ? Toast.LENGTH_LONG
            : Toast.LENGTH_SHORT);
  }
}

enum ToastBridge {
  /// Show Short toast for 1 sec
  LENGTH_SHORT,

  /// Show Long toast for 5 sec
  LENGTH_LONG
}
