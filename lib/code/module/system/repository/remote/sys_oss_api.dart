import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_oss_vo.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';

part 'sys_oss_api.g.dart';

@RestApi()
abstract class SysOssApiClient {
  factory SysOssApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysOssApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
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
  static final SysOssApiClient _sysOssApiClient = SysOssApiClient();

  ///上传文件的列表
  static Future<IntensifyEntity<PageModel<SysOssVo>>> list(
      int offset, int size, SysOssVo? sysOssVo, CancelToken cancelToken) async {
    return _sysOssApiClient
        .list(RequestUtils.toPageQuery(sysOssVo?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return resultEntity.toPageModel(offset, size, createRecords: (resultData) {
          return SysOssVo.fromJsonList(resultData);
        });
      });
    });
  }

  ///删除OSS存储
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? id, List<int>? ids}) {
    //参数校验
    assert(id != null && ids == null || id == null && ids != null);
    ids ??= [id!];
    return _sysOssApiClient
        .delete(ids.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
