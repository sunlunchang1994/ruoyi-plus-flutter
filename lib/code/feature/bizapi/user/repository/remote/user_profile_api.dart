import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/profile_vo.dart';

import '../../../../../base/api/api_config.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../entity/avatar_vo.dart';

part 'user_profile_api.g.dart';

@RestApi()
abstract class UserProfileApiClient {
  factory UserProfileApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _UserProfileApiClient(dio, baseUrl: baseUrl ?? ApiConfig().apiUrl);
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
}

///用户服务
class UserProfileServiceRepository {
  static final UserProfileApiClient _userProfileApiClient = UserProfileApiClient();

  static Future<IntensifyEntity<ProfileVo>> profile() {
    return _userProfileApiClient
        .profile()
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity(
              resultEntity: event,
              createData: (resultEntity) {
                return ProfileVo.fromJson(resultEntity.data);
              });
          return intensifyEntity;
        })
        .map(DateTransformUtils.checkErrorIe)
        .single;
  }

  static Future<IntensifyEntity> updateProfile(
      String nickName, String email, String phonenumber, String sex) {
    Map<String, Object> dataMap = {};
    dataMap["nickName"] = nickName;
    dataMap["email"] = email;
    dataMap["phonenumber"] = phonenumber;
    dataMap["sex"] = sex;
    return _userProfileApiClient
        .updateProfile(dataMap)
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity(resultEntity: event);
          return intensifyEntity;
        })
        .map(DateTransformUtils.checkErrorIe)
        .single;
  }

  static Future<IntensifyEntity<AvatarVo>> avatar(String avatarPath) {
    return _userProfileApiClient
        .avatar(File(avatarPath))
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<AvatarVo>(
              resultEntity: event, createData: (resultEntity) => AvatarVo.fromJson(resultEntity.data));
          return intensifyEntity;
        })
        .map(DateTransformUtils.checkErrorIe)
        .single;
  }
}
