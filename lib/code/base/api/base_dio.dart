import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/utils/fast_dialog_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';

import '../../../generated/l10n.dart';
import '../../feature/auth/ui/login_page.dart';
import '../../root_page.dart';
import '../api/result_entity.dart';
import 'api_exception.dart';
import 'interceptor_encrypt.dart';
import 'interceptor_header.dart';

///@author sunlunchang
///基础dio工具，单例模式
class BaseDio {
  static final BaseDio _instance = BaseDio._();

  static BaseDio getInstance() {
    // 通过 getInstance 获取实例
    //_instance ??= BaseDio._();
    return _instance;
  }

  Dio? _dio;

  // 把构造方法私有化
  BaseDio._() {
    Dio dio = Dio();
    dio.options = BaseOptions(
        receiveTimeout: const Duration(seconds: 15000),
        connectTimeout: const Duration(seconds: 15000)); // 设置超时时间等 ...
    dio.interceptors.add(HeaderInterceptor()); // 添加header拦截器，如 token之类，需要全局使用的参数
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

  ///获取错误结果对象
  static ResultEntity getError(dynamic error, {String? defErrMsg}) {
    LogUtil.e(error, tag: "getError");
    defErrMsg ??= S.current.label_unknown_exception;
    // 这里封装了一个 BaseError 类，会根据后端返回的code返回不同的错误类
    int defCode = ApiConfig.VALUE_CODE_SERVER_ERROR;
    if (error is Error) {
      return ResultEntity(code: defCode, msg: error.toString());
    } else if (error is Exception) {
      switch (error) {
        case DioException _:
          if (error.type == DioExceptionType.cancel) {
            ResultEntity baseEntity = ResultEntity.createSucceedFail(error.message ?? "Canceled",
                code: ApiConfig.VALUE_CODE_CANCEL);
            return baseEntity;
          } else if (error.type == DioExceptionType.connectionTimeout) {
            ResultEntity baseEntity = ResultEntity.createSucceedFail(
                S.current.label_error_connection_timeout,
                code: ApiConfig.VALUE_CODE_ERROR_REQUEST);
            return baseEntity;
          } else if (error.type == DioExceptionType.sendTimeout) {
            ResultEntity baseEntity = ResultEntity.createSucceedFail(
                S.current.label_error_send_timeout,
                code: ApiConfig.VALUE_CODE_ERROR_REQUEST);
            return baseEntity;
          } else if (error.type == DioExceptionType.receiveTimeout) {
            ResultEntity baseEntity = ResultEntity.createSucceedFail(
                S.current.label_error_receive_timeout,
                code: ApiConfig.VALUE_CODE_ERROR_REQUEST);
            return baseEntity;
          } else if (error.type == DioExceptionType.connectionError) {
            ResultEntity baseEntity = ResultEntity.createSucceedFail(
                S.current.label_error_connection_error,
                code: ApiConfig.VALUE_CODE_ERROR_REQUEST);
            return baseEntity;
          }
          //if (error.type == DioExceptionType.badResponse) {//替换成了下面这句
          else {
            final response = error.response;
            if (response != null) {
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
          return ResultEntity(code: error.code, msg: error.message ?? defErrMsg);
      }
    }
    return ResultEntity(code: defCode, msg: defErrMsg);
  }

  ///直接调用此方法给Future
  static errProxyFunc({
    String? defErrMsg,
    bool showToast = true,
    bool showUnauthorized = true,
    Function(ResultEntity entity)? onError,
  }) {
    return (error) {
      //获取entity时先不处理showToast和showUnauthorized，等执行了onError和onFinallyErr后再处理
      ResultEntity entity =
          handlerErr(error, defErrMsg: defErrMsg, showToast: false, showUnauthorized: false);
      onError?.call(entity);
      if (showUnauthorized && entity.isUnauthorized()) {
        BaseDio.handlerUnauthorized(entity);
      } else if (showToast) {
        BaseDio.showToast(entity);
      }
    };
  }

  /// 处理错误
  static ResultEntity handlerErr(dynamic error,
      {String? defErrMsg, bool showToast = true, bool showUnauthorized = true}) {
    ResultEntity resultEntity = getError(error, defErrMsg: defErrMsg);
    if (showUnauthorized && handlerUnauthorized(resultEntity)) {
      // no thing
    } else if (showToast) {
      BaseDio.showToast(resultEntity);
    }
    return resultEntity;
  }

  ///处理未授权
  static bool handlerUnauthorized(ResultEntity resultEntity) {
    if (resultEntity.code == ApiConfig.VALUE_CODE_NORMAL_UNAUTHORIZED) {
      //在此处弹框
      showDialog(
          context: navigatorKey.currentState!.context,
          builder: (context) {
            return AlertDialog(
                title: Text(S.current.label_prompt),
                content: Text(S.current.app_label_login_normal_unauthorized),
                actions: FastDialogUtils.getCommonlyAction(context, positiveLister: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginPage.routeName,
                    (Route<dynamic> route) => false,
                  );
                }));
          });

      return true;
    }
    return false;
  }

  ///获取错误码
  static int getErrCode(dynamic error, {String? defErrMsg}) {
    return getError(error, defErrMsg: defErrMsg).code!;
  }

  ///获取错误信息
  static String getErrMsg(dynamic error, {String? defErrMsg}) {
    return getError(error, defErrMsg: defErrMsg).msg!;
  }

  static void showToastByErr(dynamic error, {String? defErrMsg}) {
    showToast(getError(error, defErrMsg: defErrMsg));
  }

  static void showToast(ResultEntity resultEntity) {
    if (resultEntity.code == ApiConfig.VALUE_CODE_CANCEL) {
      //主动取消不显示提示
      return;
    }
    AppToastUtil.showToast(msg: resultEntity.msg);
  }
}
