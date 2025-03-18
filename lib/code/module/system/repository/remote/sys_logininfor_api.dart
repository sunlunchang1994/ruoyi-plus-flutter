import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';

import '../../../../base/api/result_entity.dart';
import '../../../../base/vm/global_vm.dart';
import '../../../../feature/component/dict/vm/dict_share_vm.dart';
import '../../entity/sys_logininfor.dart';

part 'sys_logininfor_api.g.dart';

@RestApi()
abstract class SysLogininforApiClient {
  factory SysLogininforApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysLogininforApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取登录日志列表
  @GET("/monitor/logininfor/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///删除登录日志
  @DELETE("/monitor/logininfor/{ids}")
  Future<ResultEntity> delete(@Path("ids") String ids, @CancelRequest() CancelToken cancelToken);
}

class SysLogininforRepository {
  //实例
  static final SysLogininforApiClient _sysLogininforApiClient = SysLogininforApiClient();

  static Future<IntensifyEntity<PageModel<SysLogininfor>>> list(
      int offset, int size, SysLogininfor? sysLogininfor, CancelToken cancelToken) {
    return _sysLogininforApiClient
        .list(RequestUtils.toPageQuery(sysLogininfor?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify(
          createData: (resultEntity) =>
              resultEntity.toPageModel(offset, size, createRecords: (resultData) {
                List<SysLogininfor> sysNoticeList = SysLogininfor.fromJsonList(resultData);
                translationDict(sysNoticeList);
                return sysNoticeList;
              }));
    });
  }

  static void translationDict(List<SysLogininfor>? dataList) {
    if (dataList == null) {
      return;
    }
    DictShareVm dictShareVm = GlobalVm().dictShareVm;
    for (var action in dataList) {
      action.statusName =
          dictShareVm.findDict(LocalDictLib.CODE_SYS_COMMON_STATUS, action.status)?.tdDictLabel;
    }
  }

  ///删除登录日志
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? id, List<int>? ids}) {
    //参数校验
    assert(id != null && ids == null || id == null && ids != null);
    ids ??= [id!];
    return _sysLogininforApiClient
        .delete(ids.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
