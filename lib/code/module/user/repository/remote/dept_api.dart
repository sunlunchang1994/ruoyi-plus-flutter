import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';

part 'dept_api.g.dart';

@RestApi()
abstract class DeptApiClient {
  factory DeptApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _DeptApiClient(dio,
        baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取部门列表
  @GET("/system/dept/list")
  Future<ResultEntity> list(
      @Queries() Dept? data, @CancelRequest() CancelToken cancelToken);

  ///获取部门信息
  @GET("/system/dept/{deptId}")
  Future<ResultEntity> getInfo(
      @Path("deptId") int deptId, @CancelRequest() CancelToken cancelToken);

  ///添加部门
  @POST("/system/dept")
  Future<ResultEntity> add(
      @Body() Dept? data, @CancelRequest() CancelToken cancelToken);

  ///编辑部门
  @PUT("/system/dept")
  Future<ResultEntity> edit(
      @Body() Dept? data, @CancelRequest() CancelToken cancelToken);
}

///部门服务
class DeptRepository {
  //实例
  static final DeptApiClient _deptApiClient = DeptApiClient();

  ///获取部门列表
  static Future<IntensifyEntity<List<Dept>>> list(
      Dept? dept, CancelToken cancelToken) {
    return _deptApiClient
        .list(dept, cancelToken)
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<List<Dept>>(
              resultEntity: event,
              createData: (resultEntity) {
                List<Dept> dataList =
                    Dept.formJsonList(resultEntity.data); //列表为空时创建默认的
                return dataList;
              });
          return intensifyEntity;
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }

  ///获取部门信息
  static Future<IntensifyEntity<Dept>> getInfo(
      int deptId, CancelToken cancelToken) {
    return _deptApiClient
        .getInfo(deptId, cancelToken)
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<Dept>(
              resultEntity: event,
              createData: (resultEntity) {
                return Dept.fromJson(resultEntity.data);
              });
          return intensifyEntity;
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }

  ///提交部门信息
  static Future<IntensifyEntity<Dept>> submit(
      Dept dept, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = dept.deptId == null
        ? _deptApiClient.add(dept, cancelToken)
        : _deptApiClient.edit(dept, cancelToken);
    return resultFuture
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<Dept>(resultEntity: event);
          return intensifyEntity;
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }
}
