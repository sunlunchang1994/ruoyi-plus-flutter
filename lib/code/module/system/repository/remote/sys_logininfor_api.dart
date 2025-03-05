import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_notice.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_oper_log.dart';

import '../../../../base/api/result_entity.dart';
import '../../../../feature/bizapi/system/entity/sys_config.dart';
import '../../entity/sys_logininfor.dart';

part 'sys_logininfor_api.g.dart';

@RestApi()
abstract class SysLogininforApiClient {
  factory SysLogininforApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysLogininforApiClient(dio,
        baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取登录日志列表
  @GET("/monitor/logininfor/list")
  Future<ResultPageModel> list(@Queries() SysLogininfor? queryParams,
      @CancelRequest() CancelToken cancelToken);
}

class SysLogininforRepository {
  //实例
  static final SysLogininforApiClient _sysLogininforApiClient =
      SysLogininforApiClient();

  static Future<IntensifyEntity<PageModel<SysLogininfor>>> list(int offset,
      int size, SysLogininfor? sysLogininfor, CancelToken cancelToken) {
    return _sysLogininforApiClient
        .list(sysLogininfor, cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(
          createData: (resultEntity) => resultEntity.toPageModel(offset, size,
                  createRecords: (resultData) {
                List<SysLogininfor> sysNoticeList = SysLogininfor.fromJsonList(resultData);
                return sysNoticeList;
              }));
    }).single;
  }
}
