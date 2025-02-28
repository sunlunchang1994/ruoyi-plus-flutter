import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/role.dart';
import 'package:ruoyi_plus_flutter/code/module/system/repository/remote/menu_api.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';

part 'role_api.g.dart';

@RestApi()
abstract class RoleApiClient {
  factory RoleApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _RoleApiClient(dio,
        baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取角色列表
  @GET("/system/role/list")
  Future<ResultPageModel> list(@Queries() Map<String, dynamic>? data,
      @CancelRequest() CancelToken cancelToken);

  ///获取角色信息
  @GET("/system/role/{roleId}")
  Future<ResultEntity> getInfo(
      @Path("roleId") int roleId, @CancelRequest() CancelToken cancelToken);

  ///添加角色
  @POST("/system/role")
  Future<ResultEntity> add(
      @Body() Role? data, @CancelRequest() CancelToken cancelToken);

  ///编辑角色
  @PUT("/system/role")
  Future<ResultEntity> edit(
      @Body() Role? data, @CancelRequest() CancelToken cancelToken);
}

///角色服务
class RoleRepository {
  //实例
  static final RoleApiClient _deptApiClient = RoleApiClient();

  ///获取角色列表
  static Future<IntensifyEntity<PageModel<Role>>> list(
      int offset, int size, Role? role, CancelToken cancelToken) {
    Map<String, dynamic> queryParams = Map.identity();
    queryParams["pageNum"] = offset;
    queryParams["pageSize"] = size;
    if (role?.roleId != null) {
      queryParams["roleId"] = role!.roleId;
    }
    if (TextUtil.isNotEmpty(role?.roleName)) {
      queryParams["roleName"] = role!.roleName;
    }
    if (TextUtil.isNotEmpty(role?.roleKey)) {
      queryParams["roleKey"] = role!.roleKey;
    }
    if (TextUtil.isNotEmpty(role?.status)) {
      queryParams["status"] = role!.status;
    }
    return _deptApiClient
        .list(queryParams, cancelToken)
        .asStream()
        .map((event) {
          return event.toIntensify(createData: (resultEntity) {
            return resultEntity.toPageModel(offset, size,
                createRecords: (rows) => Role.formJsonList(rows));
          });
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }

  ///获取角色信息
  static Future<IntensifyEntity<Role>> getInfo(
      int roleId, CancelToken cancelToken) {
    return _deptApiClient
        .getInfo(roleId, cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(createData: (resultEntity) {
        return Role.fromJson(resultEntity.data);
      });
    }).asyncMap((result) {
      Role roleInfo = result.data!;
      return MenuRepository.roleMenuCheckedList(roleInfo.roleId, cancelToken)
          .asStream()
          .map((roleMenuCheckedList) {
        roleInfo.menuIds = roleMenuCheckedList.data;
        return result;
      }).single;
    }).single;
  }

  ///提交角色信息
  static Future<IntensifyEntity<dynamic>> submit(
      Role role, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = role.roleId == null
        ? _deptApiClient.add(role, cancelToken)
        : _deptApiClient.edit(role, cancelToken);
    return resultFuture
        .asStream()
        .map((event) {
          return event.toIntensify<dynamic>();
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }
}
