import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/router/slc_router.dart';
import 'mix_manager.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';

import 'mix_method_channel_handler.dart';

class MixPageHandler {
  final MixMethodChannelHandler mixMethodChannelVmBox;

  //监听的渠道方法
  final MethodCallListener _methodCallListener = MethodCallListener([
    MixMethodChannelHandler.METHOD_ON_ATTACH,
    MixMethodChannelHandler.METHOD_ON_DETACH
  ]);

  MixPageHandler(this.mixMethodChannelVmBox) {
    _methodCallListener.onMethodCall = (String method, dynamic arguments) {
      if (MixMethodChannelHandler.METHOD_ON_ATTACH == method) {
        _onAttach(arguments);
      } else if (MixMethodChannelHandler.METHOD_ON_DETACH == method) {
        _onDetach(arguments);
      }
    };
    mixMethodChannelVmBox.addMethodCallListener(_methodCallListener);
  }

  void init() {}

  ///此处传递MixPlaceholderPage的context
  BuildContext? _handlerReAttachContext;

  Widget Function(BuildContext)? _reAttachPageFunc;

  String Function(BuildContext)? _reAttachRouteFunc;

  ///销毁过
  bool _detachExperienced = false;

  registerHandlerReAttachContext(BuildContext? handlerReAttachContext) {
    _handlerReAttachContext = handlerReAttachContext;
  }

  ///与registerHandlerReAttachRoute互斥，为了防止内存泄漏，二者取其一
  registerHandlerReAttachPage(Widget Function(BuildContext)? reAttachPageFunc) {
    _reAttachPageFunc = reAttachPageFunc;
    if (reAttachPageFunc != null) {
      registerHandlerReAttachRoute(null);
    }
  }

  ///与registerHandlerReAttachPage互斥，为了防止内存泄漏，二者取其一
  registerHandlerReAttachRoute(
      String Function(BuildContext)? reAttachRouteFunc) {
    _reAttachRouteFunc = reAttachRouteFunc;
    if (reAttachRouteFunc != null) {
      registerHandlerReAttachPage(null);
    }
  }

  ///附加上的时候
  ///此处不用判断是否是第一次，因为第一次_handlerReAttachContext肯定是空的
  _onAttach(dynamic arguments) {
    if (_detachExperienced && _handlerReAttachContext != null) {
      if (_reAttachPageFunc != null) {
        _handlerReAttachContext!.pushReplacement(createMixPageRouteBuilder(
            _reAttachPageFunc!.call(_handlerReAttachContext!)));
      } else if (_reAttachRouteFunc != null) {
        _handlerReAttachContext!.pushReplacementNamed(
            _reAttachRouteFunc!.call(_handlerReAttachContext!));
      } else {
        //没有界面
      }

      ///赋值为空此处应该用 Navigator.pushReplacement方法，因为需要销毁界面
      _handlerReAttachContext = null;
      LogUtil.d("MixPageHandler._onAttach");
    }
  }

  ///分离的时候
  _onDetach(dynamic arguments) {
    _detachExperienced = true;
  }

  static Route createMixPageRouteBuilder(Widget page) {
    //return MaterialPageRoute(builder: (context) => page);
    return PageRouteBuilder(
      pageBuilder: (context, _, __) => page,
      transitionDuration: Duration(milliseconds: 0),
      transitionsBuilder: (_, __, ___, child) => child,
    );
  }
}

class MixShelfWidget extends StatelessWidget {
  final Widget Function(BuildContext context) transitionBuilder;
  final MixManager mixManager;

  const MixShelfWidget(this.mixManager, this.transitionBuilder, {super.key});

  @override
  Widget build(BuildContext context) {
    mixManager.mixPageHandler.registerHandlerReAttachContext(context);
    return transitionBuilder.call(context);
  }
}
