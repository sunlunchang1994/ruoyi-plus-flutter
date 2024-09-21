import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../extras/user/entity/login_result.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApiClient {
  factory UserApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _UserApiClient(dio, baseUrl: baseUrl ?? ApiConfig().apiUrl);
  }

  ///用户登录
  @POST("/client/token")
  Future<ResultEntity> example(@Body() Map<String, Object> data);
}

///用户服务
class UserServiceRepository {
  static final UserApiClient _userApiClient = UserApiClient();

  /**
   * 示例
   */
  static Future<IntensifyEntity<LoginResult>> example(
      String account, String password, CancelToken cancelToken) async {
    Map<String, Object> dataMap = {};
    dataMap["username"] = account;
    dataMap["password"] = password;
    return _userApiClient
        .example(dataMap)
        .asStream()
        .map((event) {
      var intensifyEntity = IntensifyEntity<LoginResult>(
          resultEntity: event,
          createData: (resultEntity) =>
              LoginResult.fromJson(resultEntity.data));
      ApiConfig().token = "bearer ${intensifyEntity.data.access_token}";
      return intensifyEntity;
    }).single;
  }
}
