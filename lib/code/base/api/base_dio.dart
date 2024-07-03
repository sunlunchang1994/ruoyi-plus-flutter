import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';

import '../../../generated/l10n.dart';
import '../api/result_entity.dart';
import 'api_exception.dart';
import 'interceptor_header.dart';

class BaseDio {
  BaseDio._(); // 把构造方法私有化

  static final BaseDio _instance = BaseDio._();

  static BaseDio getInstance() {
    // 通过 getInstance 获取实例
    //_instance ??= BaseDio._();
    return _instance;
  }

  Dio getDio() {
    final Dio dio = Dio();
    dio.options = BaseOptions(
        receiveTimeout: const Duration(seconds: 15000),
        connectTimeout: const Duration(seconds: 15000)); // 设置超时时间等 ...
    dio.interceptors.add(HeaderInterceptor()); // 添加拦截器，如 token之类，需要全局使用的参数
    /*dio.interceptors.add(SlcDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: false,
        maxWidth: 180)
    );*/
    dio.interceptors.add(LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        logPrint: (object) {
          LogUtil.d(object, tag: "dio");
        }));
    return dio;
  }

  ///获取错误码
  static int getErrorCode(dynamic error, {String? defErrMsg}) {
    return getError(error, defErrMsg: defErrMsg).code!;
  }

  ///获取错误信息
  static String getErrorMsg(dynamic error, {String? defErrMsg}) {
    return getError(error, defErrMsg: defErrMsg).msg!;
  }

  ///获取错误结果对象
  static ResultEntity getError(dynamic error, {String? defErrMsg}) {
    defErrMsg ??= S.current.label_unknown_exception;
    // 这里封装了一个 BaseError 类，会根据后端返回的code返回不同的错误类
    int defCode = 500;
    if (error is Error) {
      return ResultEntity(code: defCode, msg: error.toString());
    } else if (error is Exception) {
      switch (error.runtimeType) {
        case DioException _:
          if ((error as DioException).type == DioExceptionType.badResponse) {
            final response = error.response;
            if (response != null) {
              ResultEntity baseEntity = ResultEntity(code: response.statusCode);
              if (response.statusCode == 401) {
                baseEntity.msg = "请先登录";
              } else if (response.statusCode == 403) {
                baseEntity.msg = "非法访问，请使用正确的token";
              } else if (response.statusCode == 408) {
                baseEntity.msg = "用户不存在";
              } else if (response.statusCode == 409) {
                baseEntity.msg = "用户名不能为空";
              } else if (response.statusCode == 405) {
                baseEntity.msg = "用户密码不正确";
              } else if (response.statusCode == 406) {
                baseEntity.msg = "用户密码不能为空";
              } else {
                try {
                  ResultEntity baseEntity =
                      ResultEntity.fromJson(response.data);
                  baseEntity.code ??= response.statusCode;
                  return baseEntity;
                } catch (e) {
                  return ResultEntity(
                    code: response.statusCode,
                    msg: response.statusMessage,
                  );
                }
              }
            }
            return ResultEntity(code: defCode, msg: defErrMsg);
          }
        case ApiException _:
          ApiException apiException = error as ApiException;
          return ResultEntity(
              code: apiException.code, msg: apiException.message ?? defErrMsg);
      }
    }
    return ResultEntity(code: defCode, msg: defErrMsg);
  }
}
