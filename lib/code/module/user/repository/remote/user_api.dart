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
import '../../../../feature/bizapi/user/entity/post.dart';
import '../../../../feature/bizapi/user/entity/user_info_vo.dart';
import '../../../../feature/component/dict/repository/local/local_dict_lib.dart';
import '../../entity/dept_tree.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApiClient {
  factory UserApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _UserApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///用户列表
  @GET("/system/user/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic> queries, @CancelRequest() CancelToken cancelToken);

  ///获取部门树列表
  @GET("/system/user/deptTree")
  Future<ResultEntity> deptTree();

  ///部门下的用户列表
  @GET("/system/user/list/dept/{deptId}")
  Future<ResultEntity> userListByDept(@Path("deptId") int deptId, @CancelRequest() CancelToken cancelToken);

  ///获取用户信息
  @GET("/system/user/{userId}")
  Future<ResultEntity> getUserById(@Path("userId") String userId, @CancelRequest() CancelToken cancelToken);

  ///新增用户
  @POST("/system/user")
  Future<ResultEntity> add(@Body() User body, @CancelRequest() CancelToken cancelToken);

  ///更新用户
  @PUT("/system/user")
  Future<ResultEntity> edit(@Body() User body, @CancelRequest() CancelToken cancelToken);
}

///用户服务
class UserServiceRepository {
  static final UserApiClient _userApiClient = UserApiClient();

  static Future<IntensifyEntity<List<User>>> queryNoPage(User? user, CancelToken cancelToken) {
    return list(0, 10000, user, cancelToken).asStream().map((event) {
      return IntensifyEntity<List<User>>(
          createSucceed: () => ResultEntity.createSucceedEntity(),
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
    if (TextUtil.isNotEmpty(user?.nickName)) {
      queryParams["nickName"] = user!.nickName;
    }
    if (TextUtil.isNotEmpty(user?.phonenumber)) {
      queryParams["phonenumber"] = user!.phonenumber;
    }
    if (TextUtil.isNotEmpty(user?.status)) {
      queryParams["status"] = user!.status;
    }
    return _userApiClient
        .list(queryParams, cancelToken)
        .asStream()
        .map((event) {
          return event.toIntensify(createData: (resultEntity) {
            AppPageModel appPageModel =
                AppPageModel(current: offset, size: size, rows: event.rows, total: event.total);
            PageModel<User> pageModel =
                PageTransformUtils.appPm2Pm(appPageModel, records: User.formJsonList(appPageModel.rows));
            return pageModel;
          });
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }

  static Future<IntensifyEntity<List<DeptTree>>> deptTree(Dept? dept) {
    return _userApiClient.deptTree().asStream().map(DataTransformUtils.checkError).map((event) {
      return event.toIntensify(createData: (resultEntity) {
        return DeptTree.fromJsonList(resultEntity.data);
      });
    }).single;
  }

  static Future<IntensifyEntity<List<User>>> userListByDept(int deptId, CancelToken cancelToken) {
    return _userApiClient
        .userListByDept(deptId, cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(createData: (resultEntity) {
        return User.formJsonList(resultEntity.data);
      });
    }).single;
  }

  static Future<IntensifyEntity<UserInfoVo>> getUserById(int? userId, CancelToken cancelToken) {
    return _userApiClient
        .getUserById(userId?.toString() ?? '', cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify<UserInfoVo>(createData: (resultEntity) {
        UserInfoVo userInfo = UserInfoVo.fromJson(resultEntity.data);
        userInfo.user?.sexName =
            LocalDictLib.findDictByCodeKey(LocalDictLib.CODE_SEX, userInfo.user?.sex)?.tdDictLabel;
        userInfo.user?.statusName =
            LocalDictLib.findDictByCodeKey(LocalDictLib.CODE_SYS_NORMAL_DISABLE, userInfo.user?.status)
                ?.tdDictLabel;
        fillUserPosts(userInfo);
        return userInfo;
      });
    }).single;
  }

  static void fillUserPosts(UserInfoVo userInfo) {
    if (userInfo.postIds == null) {
      return;
    }
    List<Post> userPost = List.empty(growable: true);
    userInfo.postIds!.forEach((postId) {
      Post target = userInfo.posts?.firstWhere((post) {
            return postId == post.postId;
          }) ??
          Post(postId: postId, postName: postId.toString());
      userPost.add(target);
    });
    userInfo.user!.posts = userPost;
  }

  static Future<IntensifyEntity<dynamic>> submit(User user, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = user.userId == null
        ? _userApiClient.add(user, cancelToken)
        : _userApiClient.edit(user, cancelToken);
    return resultFuture.asStream().map(DataTransformUtils.checkError).map((event) {
      return event.toIntensify();
    }).single;
  }
}
