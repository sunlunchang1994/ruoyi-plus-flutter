import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../../entity/my_user_info_vo.dart';
import '../../vm/user_share_vm.dart';

part 'pub_user_api.g.dart';

/// @author sunlunchang
/// 用户服务
@RestApi()
abstract class PubUserApi {
  factory PubUserApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PubUserApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///用户信息
  @GET("/system/user/getInfo")
  Future<ResultEntity> getInfo(@CancelRequest() CancelToken cancelToken);
}

///用户服务
class PubUserRepository {
  static final PubUserApi _pubUserApi = PubUserApi();

  static Future<IntensifyEntity<MyUserInfoVo>> getInfo(CancelToken cancelToken) {
    return _pubUserApi.getInfo(cancelToken).successMap((event) {
      return event.toIntensify(
          createData: (resultEntity) => MyUserInfoVo.fromJson(resultEntity.data));
    }).map((event) {
      MyUserInfoVo userInfoVo = event.data!;
      UserShareVm().userInfoOf.setValue(userInfoVo);
      return event;
    }).single;
  }
}
