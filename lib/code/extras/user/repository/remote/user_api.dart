import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/extras/user/entity/user.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../entity/user_info_vo.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApiClient {
  factory UserApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _UserApiClient(dio, baseUrl: baseUrl ?? ApiConfig().apiUrl);
  }

  ///用户登录
  @GET("/system/user/getInfo")
  Future<ResultEntity> getInfo();
}

///用户服务
class UserServiceRepository {
  static final UserApiClient _userApiClient = UserApiClient();

  static Future<IntensifyEntity<UserInfoVo>> getInfo() {
    return _userApiClient
        .getInfo()
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<UserInfoVo>(
              resultEntity: event, createData: (resultEntity) => UserInfoVo.fromJson(resultEntity.data));
          return intensifyEntity;
        })
        .map(DateTransformUtils.checkErrorIe)
        .map((event) {
          UserInfoVo userInfoVo = event.data;
          GlobalVm().userVmBox.userInfoOf.value = userInfoVo;
          return event;
        })
        .single;
  }
}
