import 'package:flutter/services.dart';
import '../../base/api/api_config.dart';

///
/// @Author sunlunchang
/// 嵌入在原生应用上的消息盒子用于接收消息
/// 混合开发可以用到
///
class MixMethodChannelHandler {
  static const String METHOD_ON_ATTACH = "onAttach";
  static const String METHOD_ON_DETACH = "onDetach";

  MethodChannel? _channel;

  final List<MethodCallListener> _methodCallHandlerList = List.empty(growable: true);

  init() {
    _channel = const MethodChannel('multiple-flutters');
    _channel!.setMethodCallHandler((call) async {
      if (call.method == METHOD_ON_ATTACH) {
        _onAttach(call.arguments);
      } else if (call.method == METHOD_ON_DETACH) {
        _onDetach(call.arguments);
      }
      _onMethodCallHandler(call);
    });
  }

  _onAttach(dynamic arguments) {
    Map paramsMap = arguments;
    ApiConfig config = ApiConfig();
    config.setServiceApiAddress(paramsMap["apiUrl"]);
    config.setToken(paramsMap[ApiConfig.KEY_TOKEN]);
    //下面填充用户信息等等
    //GlobalVm().userVmBox.userInfoOf.value = paramsMap["userId"];
  }

  _onDetach(dynamic arguments) {}

  _onMethodCallHandler(MethodCall call) {
    int methodCallHandlerListSize =
        _methodCallHandlerList.toList(growable: false).length;
    MethodCallListener? findResult;
    for (int i = 0; i < methodCallHandlerListSize; i++) {
      if (_methodCallHandlerList[i].listenerMethod.contains(call.method)) {
        findResult = _methodCallHandlerList[i];
      }
    }
    if (findResult != null) {
      findResult.onMethodCall?.call(call.method, call.arguments);
      return;
    }
    throw Exception('not implemented ${call.method}');
  }

  ///添加方法监听
  void addMethodCallListener(MethodCallListener methodCallListener) {
    if (!_methodCallHandlerList.contains(methodCallListener)) {
      _methodCallHandlerList.add(methodCallListener);
    }
  }

  ///移除方法监听
  void removeMethodCallListener(MethodCallListener methodCallListener) {
    _methodCallHandlerList.remove(methodCallListener);
  }

  ///调用方法
  void invokeMethod(String method, {dynamic arguments}) {
    _channel?.invokeMethod(method, arguments);
  }
}

///方法监听
class MethodCallListener {
  final List<String> listenerMethod;
  dynamic Function(String method, dynamic arguments)? onMethodCall;

  MethodCallListener(this.listenerMethod, {this.onMethodCall});
}
