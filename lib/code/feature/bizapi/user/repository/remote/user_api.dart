import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';

import '../../../../../base/api/api_config.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../entity/my_user_info_vo.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApiClient {
  factory UserApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _UserApiClient(dio,
        baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///用户信息
  @GET("/system/user/getInfo")
  Future<ResultEntity> getInfo(@CancelRequest() CancelToken cancelToken);
}

///用户服务
class UserServiceRepository {
  static final UserApiClient _userApiClient = UserApiClient();

  static Future<IntensifyEntity<MyUserInfoVo>> getInfo(
      CancelToken cancelToken) {
    return _userApiClient
        .getInfo(cancelToken)
        .asStream()
        .map((event) {
          return event.toIntensify(
              createData: (resultEntity) =>
                  MyUserInfoVo.fromJson(resultEntity.data));
        })
        .map(DataTransformUtils.checkErrorIe)
        .map((event) {
          MyUserInfoVo userInfoVo = event.data!;
          GlobalVm().userShareVm.userInfoOf.setValue(userInfoVo);
          return event;
        })
        .single;
  }
}
