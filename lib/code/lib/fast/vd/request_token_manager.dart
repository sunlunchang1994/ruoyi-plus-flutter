import 'package:dio/dio.dart';

mixin CancelTokenAssist {
  static const String KEY_DEF_CANCEL_TOKEN = "defCancelToken";

  //取消token栈堆数据
  Map<dynamic, CancelToken>? _cancelTokenMap;

  Map<dynamic, CancelToken> get cancelTokenMap {
    _cancelTokenMap ??= {};
    return _cancelTokenMap!;
  }

  CancelToken get defCancelToken {
    return getOrCreateCancelToken(KEY_DEF_CANCEL_TOKEN);
  }

  void cancelDefToken({Object? reason, bool remove = true}) {
    cancelTokenByKey(KEY_DEF_CANCEL_TOKEN, reason: reason, remove: remove);
  }

  CancelToken getOrCreateCancelToken(dynamic key){
    CancelToken? cancelToken = cancelTokenMap[key];
    if (cancelToken == null) {
      cancelToken ??= CancelToken();
      cancelTokenMap[key] = cancelToken;
    }
    return cancelToken;
  }


  void cancelTokenByKey(dynamic key, {Object? reason, bool remove = true}) {
    CancelToken? oldCancelToken;
    if (remove) {
      //此处获取CancelToken使用remove，意味着取消后就可以甩掉了，没用
      oldCancelToken = cancelTokenMap.remove(key);
    } else {
      oldCancelToken = cancelTokenMap[key];
    }
    _cancelTargetToken(oldCancelToken, reason);
  }

  ///取消目标token
  void _cancelTargetToken(CancelToken? cancelToken, [Object? reason]) {
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel(reason);
    }
  }

  void cancelAllToken([Object? reason]) {
    reason ??= "cancelAll";
    _cancelTokenMap?.values.forEach((value) {
      _cancelTargetToken(value, reason);
    });
    _cancelTokenMap?.clear();
    _cancelTokenMap = null;
  }

  ///尝试取消改对象
  static void cancelAllIf(Object target, [Object? reason]) {
    if (target is CancelTokenAssist) {
      CancelTokenAssist requestTokenManager = target;
      requestTokenManager.cancelAllToken(reason);
    }
  }
}
