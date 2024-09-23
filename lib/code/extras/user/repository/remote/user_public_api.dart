import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../entity/login_result.dart';

part 'user_public_api.g.dart';

@RestApi()
abstract class UserPublicApiClient {
  factory UserPublicApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _UserPublicApiClient(dio, baseUrl: baseUrl ?? ApiConfig().apiUrl);
  }

  ///用户登录
  @POST("/auth/login")
  @Headers(<String, dynamic>{ApiConfig.KEY_APPLY_ENCRYPT: true})
  Future<ResultEntity> login(@Body() Map<String, Object> data);
}

///用户服务
class UserPublicServiceRepository {
  static final UserPublicApiClient _userApiClient = UserPublicApiClient();

  ///用户登录
  static Future<IntensifyEntity<LoginResult>> login(
      String tenantId, String account, String password, String codeResult, String? codeUuid, CancelToken cancelToken) async {
    Map<String, Object> dataMap = {};
    dataMap["tenantId"] = tenantId;
    dataMap["username"] = account;
    dataMap["password"] = password;
    dataMap["code"] = codeResult;
    dataMap["uuid"] = codeUuid ?? '';
    dataMap["clientId"] = ApiConfig().clientid;
    dataMap["grantType"] = 'password';
    return _userApiClient
        .login(dataMap)
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<LoginResult>(
              resultEntity: event, createData: (resultEntity) => LoginResult.fromJson(resultEntity.data));
          return intensifyEntity;
        })
        .map(DateTransformUtils.checkErrorIe)
        .map((event) {
          LoginResult loginResult = event.data;
          ApiConfig().token = "Bearer ${loginResult.access_token!}";
          GlobalVm().userVmBox.loginResult = loginResult;
          return event;
        })
        .single;
  }
}
