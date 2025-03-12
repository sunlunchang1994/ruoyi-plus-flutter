import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_tenant_package.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';

part 'sys_tenant_package_api.g.dart';

@RestApi()
abstract class SysTenantPackageApiClient {
  factory SysTenantPackageApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysTenantPackageApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取租户套餐列表
  @GET("/system/tenant/package/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取用于选择的租户套餐列表
  @GET("/system/tenant/package/selectList")
  Future<ResultEntity> selectList(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取租户套餐信息
  @GET("/system/tenant/package/{packageId}")
  Future<ResultEntity> getInfo(@Path() int? packageId, @CancelRequest() CancelToken cancelToken);

  ///添加租户套餐
  @POST("/system/tenant/package")
  Future<ResultEntity> add(
      @Body() SysTenantPackage data, @CancelRequest() CancelToken cancelToken);

  ///编辑租户套餐
  @PUT("/system/tenant/package")
  Future<ResultEntity> edit(
      @Body() SysTenantPackage data, @CancelRequest() CancelToken cancelToken);
}

///租户套餐服务
class SysTenantPackageRepository {
  static final SysTenantPackageApiClient _sysTenantPackageApiClient = SysTenantPackageApiClient();

  ///租户套餐列表
  static Future<IntensifyEntity<PageModel<SysTenantPackage>>> list(
      int offset, int size, SysTenantPackage? sysTenantPackage, CancelToken cancelToken) async {
    return _sysTenantPackageApiClient
        .list(RequestUtils.toPageQuery(sysTenantPackage?.toJson(), offset, size), cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(createData: (resultEntity) {
        return resultEntity.toPageModel(offset, size, createRecords: (resultData) {
          return SysTenantPackage.fromJsonList(resultData);
        });
      });
    }).single;
  }

  ///获取用于选择的租户套餐列表
  static Future<IntensifyEntity<List<SysTenantPackage>>> selectList(
      SysTenantPackage? sysTenantPackage, CancelToken cancelToken) async {
    return _sysTenantPackageApiClient
        .selectList(sysTenantPackage?.toJson(), cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysTenantPackage.fromJsonList(resultEntity.data);
      });
    }).single;
  }

  ///租户套餐信息
  static Future<IntensifyEntity<SysTenantPackage>> getInfo(
      int packageId, CancelToken cancelToken) async {
    return _sysTenantPackageApiClient
        .getInfo(packageId, cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysTenantPackage.fromJson(resultEntity.data);
      });
    }).single;
  }

  ///提交租户套餐
  static Future<IntensifyEntity<SysTenantPackage>> submit(
      SysTenantPackage body, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = body.packageId == null
        ? _sysTenantPackageApiClient.add(body, cancelToken)
        : _sysTenantPackageApiClient.edit(body, cancelToken);
    return resultFuture
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<SysTenantPackage>(resultEntity: event);
          return intensifyEntity;
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }
}
