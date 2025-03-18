import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/role.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/retorfit/retorfit_expand.dart';
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
    return _RoleApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取角色列表
  @GET("/system/role/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? data, @CancelRequest() CancelToken cancelToken);

  ///获取角色信息
  @GET("/system/role/{roleId}")
  Future<ResultEntity> getInfo(
      @Path("roleId") int roleId, @CancelRequest() CancelToken cancelToken);

  ///添加角色
  @POST("/system/role")
  Future<ResultEntity> add(@Body() Role? data, @CancelRequest() CancelToken cancelToken);

  ///编辑角色
  @PUT("/system/role")
  Future<ResultEntity> edit(@Body() Role? data, @CancelRequest() CancelToken cancelToken);

  ///删除角色
  @DELETE("/system/role/{roleIds}")
  Future<ResultEntity> delete(
      @Path("roleIds") String postIds, @CancelRequest() CancelToken cancelToken);
}

///角色服务
class RoleRepository {
  //实例
  static final RoleApiClient _roleApiClient = RoleApiClient();

  ///获取角色列表
  static Future<IntensifyEntity<PageModel<Role>>> list(
      int offset, int size, Role? role, CancelToken cancelToken) {
    Map<String, dynamic> queryParams = RequestUtils.toPageQuery(role?.toJson(), offset, size);
    return _roleApiClient.list(queryParams, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return resultEntity.toPageModel(offset, size,
            createRecords: (rows) => Role.formJsonList(rows));
      });
    });
  }

  ///获取角色信息
  static Future<IntensifyEntity<Role>> getInfo(int roleId, CancelToken cancelToken) {
    return _roleApiClient.getInfo(roleId, cancelToken).successMap((event) {
      return event.toIntensify(createData: (resultEntity) {
        return Role.fromJson(resultEntity.data);
      });
    }).asyncMap((result) {
      Role roleInfo = result.data!;
      return MenuRepository.roleMenuCheckedList(roleInfo.roleId, cancelToken)
          .asMap((roleMenuCheckedList) {
        roleInfo.menuIds = roleMenuCheckedList.data;
        return result;
      }).single;
    }).single;
  }

  ///提交角色信息
  static Future<IntensifyEntity<dynamic>> submit(Role role, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = role.roleId == null
        ? _roleApiClient.add(role, cancelToken)
        : _roleApiClient.edit(role, cancelToken);
    return resultFuture.successMap2Single((event) {
      return event.toIntensify<dynamic>();
    });
  }

  ///删除角色
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? roleId, List<int>? roleIds}) {
    //参数校验
    assert(roleId != null && roleIds == null || roleId == null && roleIds != null);
    roleIds ??= [roleId!];
    return _roleApiClient
        .delete(roleIds.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
