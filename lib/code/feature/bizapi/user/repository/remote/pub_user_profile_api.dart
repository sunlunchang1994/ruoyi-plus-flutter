import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/profile_vo.dart';

import '../../../../../base/api/api_config.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../entity/avatar_vo.dart';

part 'pub_user_profile_api.g.dart';

@RestApi()
abstract class PubUserProfileApi {
  factory PubUserProfileApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PubUserProfileApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取个人信息
  @GET("/system/user/profile")
  Future<ResultEntity> profile();

  ///提交个人信息
  @PUT("/system/user/profile")
  Future<ResultEntity> updateProfile(@Body() Map<String, Object> data);

  ///上传用户头像
  @POST("/system/user/profile/avatar")
  Future<ResultEntity> avatar(@Part(name: "avatarfile") File avatarFile);

  ///上传用户头像
  @Headers(<String, dynamic>{ApiConfig.KEY_APPLY_ENCRYPT: true})
  @PUT("/system/user/profile/updatePwd")
  Future<ResultEntity> updatePwd(@Body() Map<String, String> body);
}

///用户服务
class PubUserProfileRepository {
  static final PubUserProfileApi _pubUserProfileApi = PubUserProfileApi();

  static Future<IntensifyEntity<ProfileVo>> profile() {
    return _pubUserProfileApi.profile().successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return ProfileVo.fromJson(resultEntity.data);
      });
    });
  }

  static Future<IntensifyEntity> updateProfile(
      String nickName, String email, String phonenumber, String sex) {
    Map<String, Object> dataMap = {};
    dataMap["nickName"] = nickName;
    dataMap["email"] = email;
    dataMap["phonenumber"] = phonenumber;
    dataMap["sex"] = sex;
    return _pubUserProfileApi.updateProfile(dataMap).successMap2Single((event) {
      return event.toIntensify();
    });
  }

  static Future<IntensifyEntity<AvatarVo>> avatar(String avatarPath) {
    return _pubUserProfileApi.avatar(File(avatarPath)).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) => AvatarVo.fromJson(resultEntity.data));
    });
  }

  static Future<IntensifyEntity<dynamic>> updatePwd(String oldPwd, String newPwd) {
    return _pubUserProfileApi
        .updatePwd({"oldPassword": oldPwd, "newPassword": newPwd}).successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
