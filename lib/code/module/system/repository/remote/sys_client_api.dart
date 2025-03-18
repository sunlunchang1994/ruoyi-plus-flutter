import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_client.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';

part 'sys_client_api.g.dart';

@RestApi()
abstract class SysClientApiClient {
  factory SysClientApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysClientApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取客户端列表
  @GET("/system/client/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取客户端信息
  @GET("/system/client/{clientId}")
  Future<ResultEntity> getInfo(@Path() int? clientId, @CancelRequest() CancelToken cancelToken);

  ///添加客户端
  @POST("/system/client")
  Future<ResultEntity> add(@Body() SysClient? data, @CancelRequest() CancelToken cancelToken);

  ///编辑客户端
  @PUT("/system/client")
  Future<ResultEntity> edit(@Body() SysClient? data, @CancelRequest() CancelToken cancelToken);

  ///删除菜单
  @DELETE("/system/client/{ids}")
  Future<ResultEntity> delete(@Path("ids") String ids, @CancelRequest() CancelToken cancelToken);
}

///客户端服务
class SysClientRepository {
  static final SysClientApiClient _sysClientApiClient = SysClientApiClient();

  ///客户端列表
  static Future<IntensifyEntity<PageModel<SysClient>>> list(
      int offset, int size, SysClient? sysClient, CancelToken cancelToken) async {
    return _sysClientApiClient
        .list(RequestUtils.toPageQuery(sysClient?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return resultEntity.toPageModel(offset, size, createRecords: (resultData) {
          return SysClient.fromJsonList(resultData);
        });
      });
    });
  }

  ///客户端信息
  static Future<IntensifyEntity<SysClient>> getInfo(int clientId, CancelToken cancelToken) async {
    return _sysClientApiClient.getInfo(clientId, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysClient.fromJson(resultEntity.data);
      });
    });
  }

  ///提交客户端
  static Future<IntensifyEntity<SysClient>> submit(SysClient body, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = body.id == null
        ? _sysClientApiClient.add(body, cancelToken)
        : _sysClientApiClient.edit(body, cancelToken);
    return resultFuture.successMap2Single((event) {
      var intensifyEntity = IntensifyEntity<SysClient>(resultEntity: event);
      return intensifyEntity;
    });
  }

  ///删除客户端
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? id, List<int>? ids}) {
    //参数校验
    assert(id != null && ids == null || id == null && ids != null);
    ids ??= [id!];
    return _sysClientApiClient
        .delete(ids.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
