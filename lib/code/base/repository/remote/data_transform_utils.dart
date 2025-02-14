import '../../../lib/fast/vd/list_data_component.dart';

import '../../api/api_config.dart';
import '../../api/api_exception.dart';
import '../../api/result_entity.dart';

///@Author sunlunchang
///数据转换类，一般在网络返回时的异步中使用
class DateTransformUtils {
  static DateWrapper<T> entity2LDWrapperShell<T>(IntensifyEntity entity,
      {T? data}) {
    return DateWrapper(
        code: entity.getCode(), msg: entity.getMsg(), data: data);
  }

  static DateWrapper<T> entity2LDWrapper<T>(IntensifyEntity<T> entity) {
    DateWrapper<T> dateWrapper =
        entity2LDWrapperShell(entity, data: entity.data);
    return dateWrapper;
  }

  static ResultEntity checkError<T>(ResultEntity entity) {
    if (entity.isSuccess()) {
      return entity;
    }
    throw ApiException(entity.code ?? ApiConfig.CODE_UNKNOWN_MISTAKE,
        message: entity.msg);
  }

  static IntensifyEntity<T> checkErrorIe<T>(IntensifyEntity<T> entity) {
    if (entity.isSuccess()) {
      return entity;
    }
    throw ApiException(entity.getCode() ?? ApiConfig.CODE_UNKNOWN_MISTAKE,
        message: entity.getMsg());
  }
}
