import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_tenant_package.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../entity/sys_user_online.dart';

part 'sys_user_online_api.g.dart';

@RestApi()
abstract class SysUserOnlineApiClient {
  factory SysUserOnlineApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysUserOnlineApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///在线用户列表
  @GET("/monitor/online/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);
}

///在线用户服务
class SysUserOnlineRepository {
  static final SysUserOnlineApiClient _sysUserOnlineApiClient = SysUserOnlineApiClient();

  ///在线用户列表
  static Future<IntensifyEntity<PageModel<SysUserOnline>>> list(
      int offset, int size, String? ipaddr, String? userName, CancelToken cancelToken) async {
    return _sysUserOnlineApiClient
        .list(RequestUtils.toPageQuery({"ipaddr": ipaddr, "userName": userName}, offset, size),
            cancelToken)
        .successMap2Single((event) {
      return event.toPage2Intensify(offset, size, createData: (dataItem) {
        return SysUserOnline.fromJson(dataItem);
      });
    });
  }
}
