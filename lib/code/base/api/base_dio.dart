import 'package:dio/dio.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/network/api_constant.dart';

import '../../../generated/l10n.dart';
import '../api/result_entity.dart';
import 'api_exception.dart';
import 'interceptor_encrypt.dart';
import 'interceptor_header.dart';

///@Author sunlunchang
///基础dio工具，单例模式
class BaseDio {
  static final BaseDio _instance = BaseDio._();

  static BaseDio getInstance() {
    // 通过 getInstance 获取实例
    //_instance ??= BaseDio._();
    return _instance;
  }

  Dio? _dio = null;

  // 把构造方法私有化
  BaseDio._() {
    Dio dio = Dio();
    dio.options = BaseOptions(
        receiveTimeout: const Duration(seconds: 15000),
        connectTimeout: const Duration(seconds: 15000)); // 设置超时时间等 ...
    dio.interceptors
        .add(HeaderInterceptor()); // 添加header拦截器，如 token之类，需要全局使用的参数
    dio.interceptors.add(EncryptInterceptor()); // 添加加密拦截器
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
    _dio = dio;
  }

  ///此处待优化，需将Dio提升为全局变量
  Dio getDio() {
    return _dio!;
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
    LogUtil.e(error, tag: "getError");
    defErrMsg ??= S.current.label_unknown_exception;
    // 这里封装了一个 BaseError 类，会根据后端返回的code返回不同的错误类
    int defCode = 500;
    if (error is Error) {
      return ResultEntity(code: defCode, msg: error.toString());
    } else if (error is Exception) {
      switch (error) {
        case DioException _:
          if (error.type == DioExceptionType.badResponse) {
            final response = error.response;
            if (response != null) {
              //ResultEntity baseEntity = ResultEntity(code: response.statusCode);
              /*if (response.statusCode == 401) {
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
              }*/
              //上面这里不需要了，一般后端会给出
              try {
                ResultEntity baseEntity = ResultEntity.fromJson(response.data);
                baseEntity.code ??= response.statusCode;
                return baseEntity;
              } catch (e) {
                return ResultEntity(
                  code: response.statusCode,
                  msg: response.statusMessage,
                );
              }
            }
            return ResultEntity(code: defCode, msg: defErrMsg);
          }
        case ApiException _:
          return ResultEntity(
              code: error.code, msg: error.message ?? defErrMsg);
      }
    }
    return ResultEntity(code: defCode, msg: defErrMsg);
  }
}
