import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_notice.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_oper_log.dart';

import '../../../../base/api/request_utils.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../feature/component/dict/vm/dict_share_vm.dart';

part 'sys_oper_log_api.g.dart';

@RestApi()
abstract class SysOperLogApi {
  factory SysOperLogApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysOperLogApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取操作日志列表
  @GET("/monitor/operlog/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///删除操作日志
  @DELETE("/monitor/operlog/{ids}")
  Future<ResultEntity> delete(@Path("ids") String ids, @CancelRequest() CancelToken cancelToken);
}

class SysOperLogRepository {
  //实例
  static final SysOperLogApi _sysOperLogApi = SysOperLogApi();

  static Future<IntensifyEntity<PageModel<SysOperLog>>> list(
      int offset, int size, SysOperLog? sysOperLog, CancelToken cancelToken) {
    return _sysOperLogApi
        .list(RequestUtils.toPageQuery(sysOperLog?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      IntensifyEntity<PageModel<SysOperLog>> intensifyEntity = event.toPage2Intensify(offset, size,
          createData: (dataItem) => SysOperLog.fromJson(dataItem));
      translationDict(intensifyEntity.data?.records);
      return intensifyEntity;
    });
  }

  static void translationDict(List<SysOperLog>? dataList) {
    if (dataList == null) {
      return;
    }
    DictShareVm dictShareVm = GlobalVm().dictShareVm;
    for (var action in dataList) {
      action.statusName =
          dictShareVm.findDict(LocalDictLib.CODE_SYS_COMMON_STATUS, action.status)?.tdDictLabel;
      action.businessTypeName = dictShareVm
          .findDict(LocalDictLib.CODE_SYS_OPER_TYPE, action.businessType?.toString())
          ?.tdDictLabel;
    }
  }

  ///删除操作日志
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? id, List<int>? ids}) {
    //参数校验
    assert(id != null && ids == null || id == null && ids != null);
    ids ??= [id!];
    return _sysOperLogApi
        .delete(ids.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
