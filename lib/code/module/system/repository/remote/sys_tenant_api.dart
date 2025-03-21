import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/system/repository/remote/sys_tenant_package_api.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../feature/bizapi/system/entity/sys_tenant.dart';

part 'sys_tenant_api.g.dart';

@RestApi()
abstract class SysTenantApi {
  factory SysTenantApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysTenantApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取租户列表
  @GET("/system/tenant/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取租户信息
  @GET("/system/tenant/{tenantId}")
  Future<ResultEntity> getInfo(@Path() int? tenantId, @CancelRequest() CancelToken cancelToken);

  ///添加租户
  @POST("/system/tenant")
  @Headers(<String, dynamic>{ApiConfig.KEY_APPLY_ENCRYPT: true})
  Future<ResultEntity> add(@Body() SysTenant? data, @CancelRequest() CancelToken cancelToken);

  ///编辑租户
  @PUT("/system/tenant")
  Future<ResultEntity> edit(@Body() SysTenant? data, @CancelRequest() CancelToken cancelToken);

  ///同步租户列表
  @GET("/system/tenant/syncTenantPackage")
  Future<ResultEntity> syncTenantPackage(@Query("tenantId") String tenantId,
      @Query("packageId") int? packageId, @CancelRequest() CancelToken cancelToken);

  ///同步租户字典列表
  @GET("/system/tenant/syncTenantDict")
  Future<ResultEntity> syncTenantDict(@CancelRequest() CancelToken cancelToken);

  ///删除租户
  @DELETE("/system/tenant/{ids}")
  Future<ResultEntity> delete(@Path("ids") String ids, @CancelRequest() CancelToken cancelToken);
}

///租户服务
class SysTenantRepository {
  static final SysTenantApi _sysTenantApi = SysTenantApi();

  ///租户列表
  static Future<IntensifyEntity<PageModel<SysTenant>>> list(
      int offset, int size, SysTenant? sysTenant, CancelToken cancelToken) async {
    return _sysTenantApi
        .list(RequestUtils.toPageQuery(sysTenant?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toPage2Intensify(offset, size, createData: (dataItem) {
        return SysTenant.fromJson(dataItem);
      });
    });
  }

  ///租户信息
  static Future<IntensifyEntity<SysTenant>> getInfo(int tenantId, CancelToken cancelToken) async {
    return _sysTenantApi.getInfo(tenantId, cancelToken).successMap((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysTenant.fromJson(resultEntity.data);
      });
    }).asyncMap<IntensifyEntity<SysTenant>>((event) {
      //获取套餐信息
      if (event.data != null && event.data!.packageId != null) {
        return SysTenantPackageRepository.getInfo(event.data!.packageId!, cancelToken)
            .asStream()
            .map((packageEvent) {
          if (packageEvent.data != null) {
            event.data!.packageName = packageEvent.data?.packageName;
          }
          return event;
        }).single;
      }
      return event;
    }).single;
  }

  ///提交租户
  static Future<IntensifyEntity<SysTenant>> submit(SysTenant body, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = body.id == null
        ? _sysTenantApi.add(body, cancelToken)
        : _sysTenantApi.edit(body, cancelToken);
    return resultFuture.successMap2Single((event) {
      var intensifyEntity = IntensifyEntity<SysTenant>(resultEntity: event);
      return intensifyEntity;
    });
  }

  ///同步租户套餐
  static Future<IntensifyEntity<dynamic>> syncTenantPackage(
      String tenantId, int? packageId, CancelToken cancelToken) {
    return _sysTenantApi
        .syncTenantPackage(tenantId, packageId, cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }

  ///同步租户字典列表
  static Future<IntensifyEntity<dynamic>> syncTenantDict(CancelToken cancelToken) {
    return _sysTenantApi.syncTenantDict(cancelToken).successMap2Single((event) {
      return event.toIntensify();
    });
  }

  ///删除租户
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? id, List<int>? ids}) {
    //参数校验
    assert(id != null && ids == null || id == null && ids != null);
    ids ??= [id!];
    return _sysTenantApi
        .delete(ids.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
