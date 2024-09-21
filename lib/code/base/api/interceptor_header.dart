import 'package:dio/dio.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/network/api_constant.dart';

import '../api/api_config.dart';

///@Author sunlunchang
///header拦截器，可在此处完善token等
class HeaderInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ApiConfig apiConfig = ApiConfig();
    if (options.headers[ApiConfig.KEY_TOKEN] == null && !TextUtil.isEmpty(apiConfig.token)) {
      options.headers.addAll({ApiConfig.KEY_TOKEN: apiConfig.token});
    }

    if (options.headers[ApiConfig.KEY_CLIENT_ID] == null && !TextUtil.isEmpty(apiConfig.clientid)) {
      options.headers.addAll({ApiConfig.KEY_CLIENT_ID: apiConfig.clientid});
    }

    if (TextUtil.isEmpty(options.headers[ApiConstant.KEY_CONTENT_TYPE])) {
      options.headers.addAll({ApiConstant.KEY_CONTENT_TYPE: ApiConstant.VALUE_APPLICATION_JSON});
    }
    super.onRequest(options, handler);
  }

}
