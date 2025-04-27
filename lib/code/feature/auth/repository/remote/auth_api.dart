import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../env_config.dart';
import '../../../../base/vm/global_vm.dart';
import '../../entity/captcha.dart';
import '../../entity/login_result.dart';
import '../../entity/login_tenant_vo.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _AuthApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///用户登录
  @POST("/auth/login")
  @Headers(<String, dynamic>{ApiConfig.KEY_APPLY_ENCRYPT: true})
  Future<ResultEntity> login(@Body() Map<String, Object> data);

  ///获取验证码
  @GET("/auth/code")
  Future<ResultEntity> getCode();

  ///获取租户列表
  @GET("/auth/tenant/list")
  Future<ResultEntity> tenantList();
}

///认证服务
class AuthRepository {
  static final AuthApi _authApi = AuthApi();

  ///用户登录
  static Future<IntensifyEntity<LoginResult>> login(String? tenantId, String account,
      String password, String codeResult, String? codeUuid, CancelToken cancelToken) async {
    Map<String, Object> dataMap = {};
    dataMap["tenantId"] = tenantId ?? EnvConfig.getEnvConfig().defTenantId;
    dataMap["username"] = account;
    dataMap["password"] = password;
    dataMap["code"] = codeResult;
    dataMap["uuid"] = codeUuid ?? '';
    dataMap["clientId"] = ApiConfig().clientid;
    dataMap["grantType"] = 'password';
    return _authApi.login(dataMap).successMap((event) {
      var intensifyEntity = IntensifyEntity<LoginResult>(
          resultEntity: event,
          createData: (resultEntity) => LoginResult.fromJson(resultEntity.data));
      return intensifyEntity;
    }).map((event) {
      LoginResult loginResult = event.data!;
      ApiConfig().setToken("Bearer ${loginResult.access_token!}");
      GlobalVm().userShareVm.loginResult = loginResult;
      return event;
    }).single;
  }

  ///获取验证码
  static Future<IntensifyEntity<Captcha>> getCode() async {
    return _authApi.getCode().successMap2Single((event) {
      var intensifyEntity = IntensifyEntity<Captcha>(
          resultEntity: event, createData: (resultEntity) => Captcha.fromJson(resultEntity.data));
      return intensifyEntity;
    });
  }

  ///获取租户列表
  static Future<IntensifyEntity<LoginTenantVo>> tenantList() async {
    return _authApi.tenantList().successMap2Single((event) {
      var intensifyEntity = IntensifyEntity<LoginTenantVo>(
          resultEntity: event,
          createData: (resultEntity) => LoginTenantVo.fromJson(resultEntity.data));
      return intensifyEntity;
    });
  }
}
