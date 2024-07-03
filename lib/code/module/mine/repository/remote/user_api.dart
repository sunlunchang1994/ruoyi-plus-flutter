import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/vm/global_vm.dart';

part 'user_api.g.dart';

@RestApi(baseUrl: ApiConfig.API_URL)
abstract class UserApiClient {
  factory UserApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _UserApiClient(dio, baseUrl: baseUrl);
  }
}

///用户服务
class UserServiceRepository {
  static final UserApiClient _userApiClient = UserApiClient();

  static Future<IntensifyEntity> login(
      String account, String password, CancelToken cancelToken) async {
    IntensifyEntity intensifyEntity =
        IntensifyEntity(resultEntity: ResultEntity(code: 500, msg: "请完善本APP"));
    //将用户信息存入全局数据
    if (intensifyEntity.isSuccess()) {
      GlobalVm().userVmBox.userInfoOf.value = intensifyEntity.data;
    }
    return intensifyEntity;
  }
}
