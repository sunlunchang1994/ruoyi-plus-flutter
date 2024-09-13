import '../../../base/ui/vd/list_data_component.dart';

import '../../api/result_entity.dart';

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
}
