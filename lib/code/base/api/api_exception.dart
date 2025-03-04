import 'api_config.dart';
import 'result_entity.dart';

///@author sunlunchang
///本地定义的网络访问异常
class ApiException implements Exception {
  int code;
  String? message;

  ApiException(this.code, {this.message});

  factory ApiException.of(ResultEntity resultEntity) {
    return ApiException(resultEntity.code ?? ApiConfig.VALUE_CODE_SERVER_ERROR,
        message: resultEntity.msg);
  }
}
