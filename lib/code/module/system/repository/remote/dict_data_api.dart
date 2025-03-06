import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_dict_type.dart';

import '../../../../base/api/result_entity.dart';
import '../../../../feature/bizapi/system/entity/sys_dict_data.dart';

part 'dict_data_api.g.dart';

@RestApi()
abstract class DictDataApiClient {
  factory DictDataApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _DictDataApiClient(dio,
        baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取字典数据列表
  @GET("/system/dict/data/list")
  Future<ResultPageModel> list(@Queries() Map<String, dynamic>? queryParams,
      @CancelRequest() CancelToken cancelToken);

  ///获取字典数据信息
  @GET("/system/dict/data/{dictCode}")
  Future<ResultEntity> getInfo(
      @Path("dictCode") int dictCode, @CancelRequest() CancelToken cancelToken);

  ///添加字典数据
  @POST("/system/dict/data")
  Future<ResultEntity> add(
      @Body() SysDictData? data, @CancelRequest() CancelToken cancelToken);

  ///编辑字典数据
  @PUT("/system/dict/data")
  Future<ResultEntity> edit(
      @Body() SysDictData? data, @CancelRequest() CancelToken cancelToken);
}

class DictDataRepository {
  //实例
  static final DictDataApiClient _dictDataApiClient = DictDataApiClient();

  static Future<IntensifyEntity<PageModel<SysDictData>>> list(
      int offset, int size, SysDictData? sysDictType, CancelToken cancelToken) {
    return _dictDataApiClient
        .list(RequestUtils.toPageQuery(sysDictType?.toJson(), offset, size),
            cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(
          createData: (resultEntity) => resultEntity.toPageModel(offset, size,
              createRecords: (resultData) =>
                  SysDictData.fromJsonList(resultData)));
    }).single;
  }

  ///获取字典数据信息
  static Future<IntensifyEntity<SysDictData?>> getInfo(
      int dictId, CancelToken cancelToken,
      {bool fillParentName = false}) {
    return _dictDataApiClient
        .getInfo(dictId, cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysDictData.fromJson(resultEntity.data);
      });
    }).single;
  }

  ///提交字典数据信息
  static Future<IntensifyEntity<SysDictData>> submit(
      SysDictData body, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = body.dictCode == null
        ? _dictDataApiClient.add(body, cancelToken)
        : _dictDataApiClient.edit(body, cancelToken);
    return resultFuture
        .asStream()
        .map((event) {
          var intensifyEntity =
              IntensifyEntity<SysDictData>(resultEntity: event);
          return intensifyEntity;
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }
}
