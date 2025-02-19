import '../../../../generated/l10n.dart';
import '../../../lib/fast/vd/list_data_component.dart';

import '../../api/api_config.dart';
import '../../api/api_exception.dart';
import '../../api/result_entity.dart';

///@Author sunlunchang
///数据转换类，一般在网络返回时的异步中使用
class DataTransformUtils {
  static DataWrapper<T> entity2LDWrapperShell<T>(IntensifyEntity entity,
      {T? data}) {
    return DataWrapper(
        code: entity.getCode(), msg: entity.getMsg(), data: data);
  }

  static DataWrapper<T> entity2LDWrapper<T>(IntensifyEntity<T> entity) {
    DataWrapper<T> dateWrapper =
        entity2LDWrapperShell(entity, data: entity.data);
    return dateWrapper;
  }

  static ResultEntity checkError<T>(ResultEntity entity) {
    if (entity.isSuccess()) {
      return entity;
    }
    throw ApiException(entity.code ?? ApiConfig.VALUE_CODE_SERVER_ERROR,
        message: entity.msg);
  }

  static IntensifyEntity<T> checkErrorIe<T>(IntensifyEntity<T> entity) {
    if (entity.isSuccess()) {
      return entity;
    }
    throw ApiException(entity.getCode() ?? ApiConfig.VALUE_CODE_SERVER_ERROR,
        message: entity.getMsg());
  }

  static ResultEntity checkNull<T>(ResultEntity entity) {
    checkError(entity);
    if (entity.data!=null) {
      return entity;
    }
    throw ApiException(entity.code ?? ApiConfig.VALUE_CODE_SERVER_ERROR,
        message: S.current.label_data_is_null);
  }

  static IntensifyEntity<T> checkNullIe<T>(IntensifyEntity<T> entity) {
    checkErrorIe(entity);
    if (entity.data!=null) {
      return entity;
    }
    throw ApiException(entity.getCode() ?? ApiConfig.VALUE_CODE_SERVER_ERROR,
        message: S.current.label_data_is_null);
  }
}
