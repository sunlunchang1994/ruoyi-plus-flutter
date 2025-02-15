import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../../base/api/api_config.dart';
import '../../../../../base/api/base_dio.dart';

part 'tenant_api.g.dart';

@RestApi()
abstract class TenantApiClient {
  factory TenantApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _TenantApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

}

///租户服务
class TenantServiceRepository {
  static final TenantApiClient _userApiClient = TenantApiClient();

}
