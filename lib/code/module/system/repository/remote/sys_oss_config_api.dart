import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
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
abstract class SysOssConfigApi {
  factory SysOssConfigApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysOssConfigApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
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

  ///添加Oss配置
  @POST("/resource/oss/config")
  Future<ResultEntity> add(@Body() SysOssConfig? data, @CancelRequest() CancelToken cancelToken);

  ///编辑Oss配置
  @PUT("/resource/oss/config")
  Future<ResultEntity> edit(@Body() SysOssConfig? data, @CancelRequest() CancelToken cancelToken);

  ///删除操作日志
  @DELETE("/resource/oss/config/{ids}")
  Future<ResultEntity> delete(@Path("ids") String ids, @CancelRequest() CancelToken cancelToken);
}

///OSS存储配置服务
class SysOssConfigRepository {
  static final SysOssConfigApi _sysOssConfig = SysOssConfigApi();

  ///配置列表
  static Future<IntensifyEntity<PageModel<SysOssConfig>>> list(
      int offset, int size, SysOssConfig? sysOssConfig, CancelToken cancelToken) async {
    return _sysOssConfig
        .list(RequestUtils.toPageQuery(sysOssConfig?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toPage2Intensify(offset, size,createData: (dataItem) {
        return SysOssConfig.fromJson(dataItem);
      });
    });
  }

  ///配置列表
  static Future<IntensifyEntity<SysOssConfig>> getInfo(
      int ossConfigId, CancelToken cancelToken) async {
    return _sysOssConfig.getInfo(ossConfigId, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysOssConfig.fromJson(resultEntity.data);
      });
    });
  }

  ///改变状态
  static Future<IntensifyEntity<dynamic>> changeStatus(
      SysOssConfig sysOssConfig, CancelToken cancelToken) async {
    return _sysOssConfig.changeStatus(sysOssConfig, cancelToken).successMap2Single((event) {
      return event.toIntensify(succeedEntity: true);
    });
  }

  ///提交Oss配置
  static Future<IntensifyEntity<SysOssConfig>> submit(SysOssConfig body, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = body.ossConfigId == null
        ? _sysOssConfig.add(body, cancelToken)
        : _sysOssConfig.edit(body, cancelToken);
    return resultFuture.successMap2Single((event) {
      var intensifyEntity = IntensifyEntity<SysOssConfig>(resultEntity: event);
      return intensifyEntity;
    });
  }

  ///删除OSS配置
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? id, List<int>? ids}) {
    //参数校验
    assert(id != null && ids == null || id == null && ids != null);
    ids ??= [id!];
    return _sysOssConfig
        .delete(ids.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
