import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../entity/captcha.dart';

part 'tenant_api.g.dart';

@RestApi()
abstract class TenantApiClient {
  factory TenantApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _TenantApiClient(dio, baseUrl: baseUrl ?? ApiConfig().apiUrl);
  }

}

///租户服务
class TenantServiceRepository {
  static final TenantApiClient _userApiClient = TenantApiClient();

}
