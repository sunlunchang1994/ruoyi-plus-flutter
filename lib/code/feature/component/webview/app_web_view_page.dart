import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/webview/web_view_util.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../generated/l10n.dart';

class AppWebViewPage extends AppBaseStatelessWidget<AppWebViewVm> {
  static const String routeName = '/webview';
  final String? title;
  final String url;

  AppWebViewPage(this.url, {this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppWebViewVm(),
      builder: (context, child) {
        registerEvent(context);
        getVm().initVm(url);
        return PopScope(
            canPop: false,
            onPopInvokedWithResult: (canPop, result) {
              if (canPop) {
                return;
              }
              getVm().controller.canGoBack().then((canGoBack) {
                if (canGoBack) {
                  getVm().controller.goBack();
                  return;
                }
                Navigator.pop(context);
              });
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(title ?? url),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close)),
                  PopupMenuButton(itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          value: S.current.action_refresh, child: Text(S.current.action_refresh)),
                      PopupMenuItem(
                          value: S.current.app_label_open_url_in_sys_browser,
                          child: Text(S.current.app_label_open_url_in_sys_browser))
                    ];
                  }, onSelected: (value) {
                    if (value == S.current.action_refresh) {
                      getVm().controller.reload();
                    } else if (value == S.current.app_label_open_url_in_sys_browser) {
                      launchUrl(Uri.parse(url));
                    }
                  })
                ],
              ),
              body: Stack(
                children: [
                  WebViewUtil.newCompatWebView(controller: getVm().controller),
                  NqSelector<AppWebViewVm, int>(builder: (context, value, child) {
                    return Visibility(
                        visible: value != 100,
                        child: LinearProgressIndicator(value: value / 100.0));
                  }, selector: (context, vm) {
                    return vm.loadProgress;
                  })
                ],
              ),
            ));
      },
    );
  }
}

class AppWebViewVm extends AppBaseVm {
  int loadProgress = 0;

  late WebViewController controller;

  void initVm(String url) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: _onWebViewLoadProgress,
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            /*if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
            }*/
            return NavigationDecision.navigate;
          },
        ),
      );
    controller.loadRequest(Uri.parse(url));
  }

  void _onWebViewLoadProgress(int progress) {
    loadProgress = progress;
    notifyListeners();
  }
}
