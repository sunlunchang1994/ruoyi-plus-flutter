import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/api/app_page_model.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/user.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/page_transform_utils.dart';
import '../../entity/dept_tree.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApiClient {
  factory UserApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _UserApiClient(dio,
        baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///用户列表
  @GET("/system/user/list")
  Future<ResultPageModel> list(@Queries() Map<String, dynamic> queries,
      @CancelRequest() CancelToken cancelToken);

  ///获取部门树列表
  @GET("/system/user/deptTree")
  Future<ResultEntity> deptTree();
}

///用户服务
class UserServiceRepository {
  static final UserApiClient _userApiClient = UserApiClient();

  static Future<IntensifyEntity<List<User>>> queryNoPage(
      User? user, CancelToken cancelToken) {
    return list(0, 10000, user, cancelToken).asStream().map((event) {
      return IntensifyEntity<List<User>>(
          succeedEntity: event.isSuccess(),
          data: PageTransformUtils.page2List(event.data));
    }).single;
  }

  static Future<IntensifyEntity<PageModel<User>>> list(
      int offset, int size, User? user, CancelToken cancelToken) {
    Map<String, dynamic> queryParams = Map.identity();
    queryParams["pageNum"] = offset;
    queryParams["pageSize"] = size;
    if (user?.deptId != null) {
      queryParams["deptId"] = user!.deptId;
    }
    if (TextUtil.isNotEmpty(user?.userName)) {
      queryParams["userName"] = user!.userName;
    }
    return _userApiClient
        .list(queryParams, cancelToken)
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
                PageModel<User> pageModel =
                    PageTransformUtils.appPm2Pm(appPageModel,
                        records: User.formJsonList(appPageModel.rows));
                return pageModel;
              });
          return intensifyEntity;
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }

  static Future<IntensifyEntity<List<DeptTree>>> deptTree(Dept? dept) {
    return _userApiClient
        .deptTree()
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<List<DeptTree>>(
              resultEntity: event,
              createData: (resultEntity) {
                return DeptTree.fromJsonList(resultEntity.data);
              });
          return intensifyEntity;
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }
}
