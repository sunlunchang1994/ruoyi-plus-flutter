import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/api/app_page_model.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/extras/user/entity/user.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/page_transform_utils.dart';
import '../../entity/user_info_vo.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApiClient {
  factory UserApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _UserApiClient(dio, baseUrl: baseUrl ?? ApiConfig().apiUrl);
  }

  ///用户信息
  @GET("/system/user/getInfo")
  Future<ResultEntity> getInfo();

  ///用户列表
  @GET("/system/user/list")
  Future<ResultPageModel> list(@Queries() Map<String, dynamic> queries);
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

  static Future<IntensifyEntity<PageModel<User>>> list(int offset, int size) {
    return _userApiClient
        .list({"pageNum": offset, "pageSize": size})
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<PageModel<User>>(
              resultEntity: ResultEntity(code: event.code, msg: event.msg),
              createData: (resultEntity) {
                AppPageModel appPageModel = AppPageModel(
                    current: offset,
                    size: size,
                    rows: event.rows,
                    total: event.total);
                PageModel<User> pageModel = PageTransformUtils.appPageModel2PageModel(appPageModel,
                    records: User.formJsonList(appPageModel.rows));
                return pageModel;
              });
          return intensifyEntity;
        })
        .map(DateTransformUtils.checkErrorIe)
        .single;
  }
}
