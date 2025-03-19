import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';

import '../../../../base/api/request_utils.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../feature/bizapi/system/entity/sys_config.dart';

part 'sys_config_api.g.dart';

@RestApi()
abstract class SysConfigApiClient {
  factory SysConfigApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysConfigApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取参数配置列表
  @GET("/system/config/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取参数配置信息
  @GET("/system/config/{dictId}")
  Future<ResultEntity> getInfo(
      @Path("dictId") int dictId, @CancelRequest() CancelToken cancelToken);

  ///添加参数配置
  @POST("/system/config")
  Future<ResultEntity> add(@Body() SysConfig? data, @CancelRequest() CancelToken cancelToken);

  ///编辑参数配置
  @PUT("/system/config")
  Future<ResultEntity> edit(@Body() SysConfig? data, @CancelRequest() CancelToken cancelToken);

  ///删除参数配置
  @DELETE("/system/config/{ids}")
  Future<ResultEntity> delete(@Path("ids") String ids, @CancelRequest() CancelToken cancelToken);
}

class SysConfigRepository {
  //实例
  static final SysConfigApiClient _sysConfigApiClient = SysConfigApiClient();

  static Future<IntensifyEntity<PageModel<SysConfig>>> list(
      int offset, int size, SysConfig? sysConfig, CancelToken cancelToken) {
    return _sysConfigApiClient
        .list(RequestUtils.toPageQuery(sysConfig?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toPage2Intensify(offset, size,
          createData: (dataItem) => SysConfig.fromJson(dataItem));
    });
  }

  ///获取参数配置信息
  static Future<IntensifyEntity<SysConfig?>> getInfo(int dictId, CancelToken cancelToken,
      {bool fillParentName = false}) {
    return _sysConfigApiClient.getInfo(dictId, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysConfig.fromJson(resultEntity.data);
      });
    });
  }

  ///提交参数配置信息
  static Future<IntensifyEntity<SysConfig>> submit(SysConfig body, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = body.configId == null
        ? _sysConfigApiClient.add(body, cancelToken)
        : _sysConfigApiClient.edit(body, cancelToken);
    return resultFuture.successMap2Single((event) {
      var intensifyEntity = IntensifyEntity<SysConfig>(resultEntity: event);
      return intensifyEntity;
    });
  }

  ///删除参数配置
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? configId, List<int>? configIds}) {
    //参数校验
    assert(configId != null && configIds == null || configId == null && configIds != null);
    configIds ??= [configId!];
    return _sysConfigApiClient
        .delete(configIds.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
