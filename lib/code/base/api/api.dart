import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api/base_dio.dart';

part 'api.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);
  }
}
