import 'package:dio/dio.dart' hide Headers;
import 'package:boxes_flutter/flutter/slc/adapter/page_model.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:base/base/api/request_utils.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';

import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:system/system/entity/sys_client.dart';

part 'sys_client_api.g.dart';

@RestApi()
abstract class SysClientApi {
  factory SysClientApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysClientApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
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
  static final SysClientApi _sysClientApi = SysClientApi();

  ///客户端列表
  static Future<IntensifyEntity<PageModel<SysClient>>> list(
      int offset, int size, SysClient? sysClient, CancelToken cancelToken) async {
    return _sysClientApi
        .list(RequestUtils.toPageQuery(sysClient?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toPage2Intensify(offset, size,
          createData: (dataItem) => SysClient.fromJson(dataItem));
    });
  }

  ///客户端信息
  static Future<IntensifyEntity<SysClient>> getInfo(int clientId, CancelToken cancelToken) async {
    return _sysClientApi.getInfo(clientId, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysClient.fromJson(resultEntity.data);
      });
    });
  }

  ///提交客户端
  static Future<IntensifyEntity<SysClient>> submit(SysClient body, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = body.id == null
        ? _sysClientApi.add(body, cancelToken)
        : _sysClientApi.edit(body, cancelToken);
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
    return _sysClientApi
        .delete(ids.join(TextUtil.comma), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
