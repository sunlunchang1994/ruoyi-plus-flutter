import 'package:flutter/services.dart';

class BarUtils {
  static void showEnabledSystemUI(bool isShow) {
    if (isShow) {
      // 显示状态栏、底部按钮栏
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else {
      // 隐藏状态栏和底部按钮栏
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      //SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

}
