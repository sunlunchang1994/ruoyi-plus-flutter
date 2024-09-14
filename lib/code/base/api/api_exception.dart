import 'result_entity.dart';

///@Author sunlunchang
///本地定义的网络访问异常
class ApiException implements Exception {
  int code;
  String? message;

  ApiException(this.code, {this.message});

  factory ApiException.of(ResultEntity resultEntity) {
    return ApiException(resultEntity.code ?? 500,
        message: resultEntity.msg);
  }
}
