import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../../base/api/api_config.dart';
import '../../../../../base/api/base_dio.dart';

part 'pub_tenant_api.g.dart';

@RestApi()
abstract class PubTenantApiClient {
  factory PubTenantApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PubTenantApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

}

///租户服务
class PubTenantRepository {
  static final PubTenantApiClient _userApiClient = PubTenantApiClient();

}
