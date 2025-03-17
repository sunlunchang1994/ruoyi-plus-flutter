import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';
import 'package:ruoyi_plus_flutter/code/module/user/repository/remote/user_api.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/bizapi/user/entity/my_user_info_vo.dart';
import '../../../../feature/bizapi/user/entity/user_info_vo.dart';

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

  ///删除部门
  @DELETE("/system/dept/{deptIds}")
  Future<ResultEntity> delete(@Path("deptIds") String deptIds, @CancelRequest() CancelToken cancelToken);
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
        .map(DataTransformUtils.checkError)
        .map((event) {
          return event.toIntensify(createData: (resultEntity) {
            List<Dept> dataList =
            Dept.formJsonList(resultEntity.data); //列表为空时创建默认的
            return dataList;
          });
        })
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
        .asyncMap<IntensifyEntity<Dept>>((deptIe) {
          Dept? dept = deptIe.data;
          if (dept?.leader != null) {
            //获取用户信息
            return UserServiceRepository.getUserById(dept!.leader!, cancelToken)
                .asStream()
                .map((event) {
              UserInfoVo? userInfo = event.data;
              dept.leaderName = userInfo?.user?.nickName;
              return deptIe;
            }).single;
          }
          return deptIe;
        })
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

  //删除部门
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? deptId, List<int>? deptIds}) {
    //参数校验
    assert(deptId != null && deptIds == null || deptId == null && deptIds != null);
    deptIds ??= [deptId!];
    return _deptApiClient
        .delete(deptIds.join(TextUtil.COMMA), cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify();
    }).single;
  }

}
