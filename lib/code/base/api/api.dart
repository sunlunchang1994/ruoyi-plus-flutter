import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api/api_config.dart';
import '../api/base_dio.dart';

part 'api.g.dart';

@RestApi(baseUrl: ApiConfig.API_URL)
abstract class ApiClient {
  factory ApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);
  }
}
