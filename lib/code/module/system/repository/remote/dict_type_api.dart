import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_dict_type.dart';

import '../../../../base/api/request_utils.dart';
import '../../../../base/api/result_entity.dart';

part 'dict_type_api.g.dart';

@RestApi()
abstract class DictTypeApi {
  factory DictTypeApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _DictTypeApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取字典类型列表
  @GET("/system/dict/type/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取字典类型信息
  @GET("/system/dict/type/{dictId}")
  Future<ResultEntity> getInfo(
      @Path("dictId") int dictId, @CancelRequest() CancelToken cancelToken);

  ///添加字典类型
  @POST("/system/dict/type")
  Future<ResultEntity> add(@Body() SysDictType? data, @CancelRequest() CancelToken cancelToken);

  ///编辑字典类型
  @PUT("/system/dict/type")
  Future<ResultEntity> edit(@Body() SysDictType? data, @CancelRequest() CancelToken cancelToken);

  ///删除字典数据
  @DELETE("/system/dict/type/{typeIds}")
  Future<ResultEntity> delete(
      @Path("typeIds") String typeIds, @CancelRequest() CancelToken cancelToken);
}

class DictTypeRepository {
  //实例
  static final DictTypeApi _dictTypeApi = DictTypeApi();

  static Future<IntensifyEntity<PageModel<SysDictType>>> list(
      int offset, int size, SysDictType? sysDictType, CancelToken cancelToken) {
    return _dictTypeApi
        .list(RequestUtils.toPageQuery(sysDictType?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toPage2Intensify(offset, size,
          createData: (dataItem) => SysDictType.fromJson(dataItem));
    });
  }

  ///获取字典类型信息
  static Future<IntensifyEntity<SysDictType?>> getInfo(int dictId, CancelToken cancelToken,
      {bool fillParentName = false}) {
    return _dictTypeApi.getInfo(dictId, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysDictType.fromJson(resultEntity.data);
      });
    });
  }

  ///提交字典类型信息
  static Future<IntensifyEntity<SysDictType>> submit(SysDictType body, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = body.dictId == null
        ? _dictTypeApi.add(body, cancelToken)
        : _dictTypeApi.edit(body, cancelToken);
    return resultFuture.successMap2Single((event) {
      return event.toIntensify();
    });
  }

  ///删除字典类型
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? dictTypeId, List<int>? dictTypeIds}) {
    //参数校验
    assert(dictTypeId != null && dictTypeIds == null || dictTypeId == null && dictTypeIds != null);
    dictTypeIds ??= [dictTypeId!];
    return _dictTypeApi
        .delete(dictTypeIds.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
