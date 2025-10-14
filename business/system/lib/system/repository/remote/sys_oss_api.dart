import 'package:dio/dio.dart' hide Headers;
import 'package:boxes_flutter/flutter/slc/adapter/page_model.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:base/base/api/request_utils.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';
import 'package:bizapi/system/entity/sys_oss_vo.dart';

import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';

part 'sys_oss_api.g.dart';

@RestApi()
abstract class SysOssApi {
  factory SysOssApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysOssApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取上传文件列表
  @GET("/resource/oss/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///删除操作日志
  @DELETE("/resource/oss/{ids}")
  Future<ResultEntity> delete(@Path("ids") String ids, @CancelRequest() CancelToken cancelToken);
}

///OSS存储服务
class SysOssRepository {
  static final SysOssApi _sysOssApi = SysOssApi();

  ///上传文件的列表
  static Future<IntensifyEntity<PageModel<SysOssVo>>> list(
      int offset, int size, SysOssVo? sysOssVo, CancelToken cancelToken) async {
    return _sysOssApi
        .list(RequestUtils.toPageQuery(sysOssVo?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toPage2Intensify(offset, size, createData: (dataItem) {
        return SysOssVo.fromJson(dataItem);
      });
    });
  }

  ///删除OSS存储
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? id, List<int>? ids}) {
    //参数校验
    assert(id != null && ids == null || id == null && ids != null);
    ids ??= [id!];
    return _sysOssApi
        .delete(ids.join(TextUtil.comma), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
