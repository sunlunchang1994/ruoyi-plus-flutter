import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

/// @author sunlunchang
/// WebView工具类
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

  static WebViewController createWebViewController({
    JavaScriptMode javaScriptMode = JavaScriptMode.unrestricted,
    bool enableZoom = false,
    Color? backgroundColor,
    FutureOr<NavigationDecision> Function(NavigationRequest request)? onNavigationRequest,
    void Function(String url)? onPageStarted,
    void Function(String url)? onPageFinished,
    void Function(int progress)? onProgress,
    void Function(WebResourceError error)? onWebResourceError,
    void Function(UrlChange change)? onUrlChange,
    void Function(HttpAuthRequest request)? onHttpAuthRequest,
    void Function(HttpResponseError error)? onHttpError,
  }) {
    WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(javaScriptMode)
      ..enableZoom(enableZoom)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: onNavigationRequest ??
                  (NavigationRequest request) {
                /*if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }*/
                return NavigationDecision.navigate;
              },
          onPageStarted: onPageStarted,
          onPageFinished: onPageFinished,
          onProgress: onProgress,
          onWebResourceError: onWebResourceError,
          onUrlChange: onUrlChange,
          onHttpAuthRequest: onHttpAuthRequest,
          onHttpError: onHttpError,
        ),
      );
    if (backgroundColor != null) {
      webViewController.setBackgroundColor(backgroundColor);
    }
    return webViewController;
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
