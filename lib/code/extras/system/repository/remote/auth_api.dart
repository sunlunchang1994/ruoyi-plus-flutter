import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../entity/captcha.dart';
import '../../entity/login_tenant_vo.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _AuthApiClient(dio, baseUrl: baseUrl ?? ApiConfig().apiUrl);
  }

  ///获取验证码
  @GET("/auth/code")
  Future<ResultEntity> getCode();

  ///获取租户列表
  @GET("/auth/tenant/list")
  Future<ResultEntity> tenantList();
}

///认证服务
class AuthServiceRepository {
  static final AuthApiClient _userApiClient = AuthApiClient();

  ///获取验证码
  static Future<IntensifyEntity<Captcha>> getCode() async {
    return _userApiClient
        .getCode()
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<Captcha>(
              resultEntity: event, createData: (resultEntity) => Captcha.fromJson(resultEntity.data));
          return intensifyEntity;
        })
        .map(DateTransformUtils.checkErrorIe)
        .single;
  }

  ///获取租户列表
  static Future<IntensifyEntity<LoginTenantVo>> tenantList() async {
    return _userApiClient
        .tenantList()
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<LoginTenantVo>(
              resultEntity: event, createData: (resultEntity) => LoginTenantVo.fromJson(resultEntity.data));
          return intensifyEntity;
        })
        .map(DateTransformUtils.checkErrorIe)
        .single;
  }
}
