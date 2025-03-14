import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebViewUtil {

  /// 兼容
  static WebViewWidget newCompatWebView({
    Key? key,
    required WebViewController controller,
    TextDirection layoutDirection = TextDirection.ltr,
    Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers =
        const <Factory<OneSequenceGestureRecognizer>>{},
  }) {
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      //修复Android的WebView由于厂商和部分版本问题导致模糊，但是在关闭页面时会有延迟显示
      return WebViewWidget.fromPlatformCreationParams(
        params: AndroidWebViewWidgetCreationParams(
            key: key,
            controller: controller.platform,
            layoutDirection: layoutDirection,
            gestureRecognizers: gestureRecognizers,
            displayWithHybridComposition: true),
      );
    }
    return WebViewWidget(
        key: key,
        controller: controller,
        layoutDirection: layoutDirection,
        gestureRecognizers: gestureRecognizers);
  }

  /// 富文本处理
  /// 1. 图片自适应
  /// 2. 防止图片过大
  static String formatRichText(String richText) {
    String head = "<head>"
        "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> "
        "<style>img{max-width: 100%; width:100%; height:auto;}*{margin:0px;}</style>"
        "</head>";
    return "<html>$head<body>$richText</body></html>";
  }
}
