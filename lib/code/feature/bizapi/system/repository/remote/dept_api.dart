import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';

import '../../../../../base/api/api_config.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../../../../base/repository/remote/data_transform_utils.dart';

part 'dept_api.g.dart';

@RestApi()
abstract class DeptApiClient {
  factory DeptApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _DeptApiClient(dio, baseUrl: baseUrl ?? ApiConfig().apiUrl);
  }

  ///获取部门列表
  @GET("/system/dept/list")
  Future<ResultEntity> list(@Queries() Dept? data);
}

///部门服务
class DeptServiceRepository {
  static final DeptApiClient _deptApiClient = DeptApiClient();

  static Future<IntensifyEntity<List<Dept>>> list(Dept? dept) {
    return _deptApiClient
        .list(dept)
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<List<Dept>>(
              resultEntity: event,
              createData: (resultEntity) {
                List<Dept> dataList = Dept.formJsonList(resultEntity.data); //列表为空时创建默认的
                return dataList;
              });
          return intensifyEntity;
        })
        .map(DateTransformUtils.checkErrorIe)
        .single;
  }
}
