import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter_slc_boxes/flutter/slc/network/api_constant.dart';

import '../vm/global_vm.dart';
import '../api/api_config.dart';

class HeaderInterceptor extends Interceptor {
  /*@override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({ApiConfig.KEY_TOKEN:  new GlobalVm().token});
    return handler.next(options);
  }*/

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ApiConfig apiConfig = ApiConfig();
    if (options.headers[ApiConfig.KEY_TOKEN] == null &&
        !TextUtil.isEmpty(apiConfig.token)) {
      options.headers.addAll({ApiConfig.KEY_TOKEN: apiConfig.token});
    }
    if (TextUtil.isEmpty(options.headers["content-type"])) {
      options.headers.addAll({
        "content-type": ApiConstant.VALUE_APPLICATION_JSON
      });
    }
    super.onRequest(options, handler);
  }

  /*@override
  Future onRequest(RequestOptions options) async {
    GlobalVm globalVm = GlobalVm();
    if (options.headers[ApiConfig.KEY_TOKEN] == null &&
        !TextUtil.isEmpty(globalVm.token)) {
      options.headers.addAll({ApiConfig.KEY_TOKEN: globalVm.token});
    }
    if (TextUtil.isEmpty(options.headers["content-type"])) {
      options.headers.addAll({
        "content-type": ApiConstant.VALUE_APPLICATION_JSON
      });
    }
    return options;
  }*/
}
