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

part 'sys_oper_log_api.g.dart';

@RestApi()
abstract class SysOperLogApiClient {
  factory SysOperLogApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysOperLogApiClient(dio,
        baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取操作日志列表
  @GET("/monitor/operlog/list")
  Future<ResultPageModel> list(@Queries() SysOperLog? queryParams,
      @CancelRequest() CancelToken cancelToken);
}

class SysOperLogRepository {
  //实例
  static final SysOperLogApiClient _sysOperLogApiClient = SysOperLogApiClient();

  static Future<IntensifyEntity<PageModel<SysOperLog>>> list(
      int offset, int size, SysOperLog? sysOperLog, CancelToken cancelToken) {
    return _sysOperLogApiClient
        .list(sysOperLog, cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(
          createData: (resultEntity) => resultEntity.toPageModel(offset, size,
                  createRecords: (resultData) {
                List<SysOperLog> sysNoticeList =
                    SysOperLog.fromJsonList(resultData);
                return sysNoticeList;
              }));
    }).single;
  }
}
