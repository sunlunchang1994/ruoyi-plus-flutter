import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../../base/api/api_config.dart';
import '../../../../../base/api/base_dio.dart';

part 'pub_tenant_api.g.dart';

@RestApi()
abstract class PubTenantApi {
  factory PubTenantApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PubTenantApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

}

///租户服务
class PubTenantRepository {
  static final PubTenantApi _pubTenantApi = PubTenantApi();

}
