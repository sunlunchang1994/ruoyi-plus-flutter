import 'package:flutter/services.dart';
import 'package:flutter_scaffold_single/code/base/api/api_config.dart';
import 'package:flutter_scaffold_single/code/base/vm/global_vm.dart';

///
/// 嵌入在原生应用上的消息盒子用于接收消息
/// 混合开发可以用到
///
class ToTopMsgVmBox {
  MethodChannel? _channel;
  List<MethodCallListener> _methodCallHandlerList = List.empty(growable: true);

  init() {
    _channel = const MethodChannel('multiple-flutters');
    _channel!.setMethodCallHandler((call) async {
      if (call.method == "onAttach") {
        //相关吃出话参数，例如token，用户信息等等
        /*Map arguments = call.arguments;
        ApiConfig config = ApiConfig();
        ApiConfig.API_URL = arguments["apiUrl"];
        config.token = arguments[ApiConfig.KEY_TOKEN];
        GlobalVm().userVmBox.userInfoOf.value = arguments["userId"];*/
        return;
      }
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
    });
  }

  void addMethodCallListener(MethodCallListener methodCallListener) {
    if (!_methodCallHandlerList.contains(methodCallListener)) {
      _methodCallHandlerList.add(methodCallListener);
    }
  }

  void removeMethodCallListener(MethodCallListener methodCallListener) {
    _methodCallHandlerList.remove(methodCallListener);
  }

  void invokeMethod(String method, {dynamic arguments}) {
    _channel?.invokeMethod(method, arguments);
  }
}

class MethodCallListener {
  final List<String> listenerMethod;
  dynamic Function(String method, dynamic arguments)? onMethodCall;

  MethodCallListener(this.listenerMethod, {this.onMethodCall});
}
