import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../entity/captcha.dart';

part 'sys_public_api.g.dart';

@RestApi()
abstract class SysPublicApiClient {
  factory SysPublicApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysPublicApiClient(dio, baseUrl: baseUrl ?? ApiConfig().apiUrl);
  }

  ///获取验证码
  @GET("/auth/code")
  Future<ResultEntity> getCode();
}

///系统服务
class SysPublicServiceRepository {
  static final SysPublicApiClient _userApiClient = SysPublicApiClient();

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
}
