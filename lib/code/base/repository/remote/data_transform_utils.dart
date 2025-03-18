import 'package:ruoyi_plus_flutter/code/lib/fast/retorfit/retorfit_expand.dart';

import '../../../../generated/l10n.dart';
import '../../../lib/fast/vd/list_data_component.dart';

import '../../api/api_config.dart';
import '../../api/api_exception.dart';
import '../../api/result_entity.dart';

///@author sunlunchang
///数据转换类，一般在网络返回时的异步中使用
class DataTransformUtils {
  static DataWrapper<T> entity2LDWrapperShell<T>(IntensifyEntity entity, {T? data}) {
    return DataWrapper(code: entity.getCode(), msg: entity.getMsg(), data: data);
  }

  static DataWrapper<T> entity2LDWrapper<T>(IntensifyEntity<T> entity) {
    DataWrapper<T> dataWrapper = entity2LDWrapperShell(entity, data: entity.data);
    return dataWrapper;
  }

  static T checkError<T extends IResultEntity>(T entity) {
    if (entity.isSuccess()) {
      return entity;
    }
    throw ApiException(entity.code ?? ApiConfig.VALUE_CODE_SERVER_ERROR, message: entity.msg);
  }

  static IntensifyEntity<T> checkErrorIe<T>(IntensifyEntity<T> entity) {
    if (entity.isSuccess()) {
      return entity;
    }
    throw ApiException(entity.getCode() ?? ApiConfig.VALUE_CODE_SERVER_ERROR,
        message: entity.getMsg());
  }

  static T checkNull<T extends IResultEntity>(T entity) {
    checkError(entity);
    if (entity.data != null) {
      return entity;
    }
    throw ApiException(entity.code ?? ApiConfig.VALUE_CODE_SERVER_ERROR,
        message: S.current.label_data_is_null);
  }

  static IntensifyEntity<T> checkNullIe<T>(IntensifyEntity<T> entity) {
    checkErrorIe(entity);
    if (entity.data != null) {
      return entity;
    }
    throw ApiException(entity.getCode() ?? ApiConfig.VALUE_CODE_SERVER_ERROR,
        message: S.current.label_data_is_null);
  }
}

///Future 扩展，用于处理IResultEntity数据转换
extension FutureDataTransform<T extends IResultEntity> on Future<T> {
  //转换前检查错误
  Stream<S> successMap<S>(S Function(T event) convert) {
    return asMap(DataTransformUtils.checkError).map(convert);
  }

  //转换前检查错误并转成Future
  Future<S> successMap2Single<S>(S Function(T event) convert) {
    return successMap(convert).single;
  }

  //转换后检查错误
  Stream<IntensifyEntity<S>> successIeMap<S>(IntensifyEntity<S> Function(T event) convert) {
    return asMap(convert).map(DataTransformUtils.checkErrorIe);
  }

  //转换后检查错误并转成Future
  Future<IntensifyEntity<S>> successIeMap2Single<S>(IntensifyEntity<S> Function(T event) convert) {
    return successIeMap(convert).single;
  }
}
