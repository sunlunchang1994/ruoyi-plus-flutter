import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_oss_vo.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_oss_config.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';

part 'sys_oss_config_api.g.dart';

@RestApi()
abstract class SysOssConfigApiClient {
  factory SysOssConfigApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysOssConfigApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取配置列表
  @GET("/resource/oss/config/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取信息
  @GET("/resource/oss/config/{ossConfigId}")
  Future<ResultEntity> getInfo(@Path() int? ossConfigId, @CancelRequest() CancelToken cancelToken);

  ///改变状态
  @PUT("/resource/oss/config/changeStatus")
  Future<ResultEntity> changeStatus(
      @Body() SysOssConfig body, @CancelRequest() CancelToken cancelToken);
}

///OSS存储配置服务
class SysOssConfigRepository {
  static final SysOssConfigApiClient _sysOssApiClient = SysOssConfigApiClient();

  ///配置列表
  static Future<IntensifyEntity<PageModel<SysOssConfig>>> list(
      int offset, int size, SysOssConfig? sysOssConfig, CancelToken cancelToken) async {
    return _sysOssApiClient
        .list(RequestUtils.toPageQuery(sysOssConfig?.toJson(), offset, size), cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(createData: (resultEntity) {
        return resultEntity.toPageModel(offset, size, createRecords: (resultData) {
          return SysOssConfig.fromJsonList(resultData);
        });
      });
    }).single;
  }

  ///配置列表
  static Future<IntensifyEntity<SysOssConfig>> getInfo(
      int ossConfigId, CancelToken cancelToken) async {
    return _sysOssApiClient
        .getInfo(ossConfigId, cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysOssConfig.fromJson(resultEntity.data);
      });
    }).single;
  }

  ///改变状态
  static Future<IntensifyEntity<dynamic>> changeStatus(
      SysOssConfig sysOssConfig, CancelToken cancelToken) async {
    return _sysOssApiClient
        .changeStatus(sysOssConfig, cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(succeedEntity: true);
    }).single;
  }
}
