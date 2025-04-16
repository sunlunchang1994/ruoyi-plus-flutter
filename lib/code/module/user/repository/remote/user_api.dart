import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/dept.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/user.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/request_utils.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/page_transform_utils.dart';
import '../../../../base/vm/global_vm.dart';
import '../../../../feature/bizapi/user/entity/post.dart';
import '../../../../feature/bizapi/user/entity/user_info_vo.dart';
import '../../../../feature/bizapi/system/repository/local/local_dict_lib.dart';
import '../../entity/dept_tree.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _UserApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///用户列表
  @GET("/system/user/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic> queries, @CancelRequest() CancelToken cancelToken);

  ///获取部门树列表
  @GET("/system/user/deptTree")
  Future<ResultEntity> deptTree(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///部门下的用户列表
  @GET("/system/user/list/dept/{deptId}")
  Future<ResultEntity> userListByDept(
      @Path("deptId") int deptId, @CancelRequest() CancelToken cancelToken);

  ///获取用户信息
  @GET("/system/user/{userId}")
  Future<ResultEntity> getUserById(
      @Path("userId") String userId, @CancelRequest() CancelToken cancelToken);

  ///新增用户
  @POST("/system/user")
  Future<ResultEntity> add(@Body() User body, @CancelRequest() CancelToken cancelToken);

  ///更新用户
  @PUT("/system/user")
  Future<ResultEntity> edit(@Body() User body, @CancelRequest() CancelToken cancelToken);

  ///删除用户
  @DELETE("/system/user/{userIds}")
  Future<ResultEntity> delete(
      @Path("userIds") String userIds, @CancelRequest() CancelToken cancelToken);

  ///重置密码
  @Headers(<String, dynamic>{ApiConfig.KEY_APPLY_ENCRYPT: true})
  @PUT("/system/user/resetPwd")
  Future<ResultEntity> resetPwd(@Body() User body, @CancelRequest() CancelToken cancelToken);
}

///用户服务
class UserServiceRepository {
  static final UserApi _userApiClient = UserApi();

  static Future<IntensifyEntity<List<User>>> queryNoPage(User? user, CancelToken cancelToken) {
    return list(0, 10000, user, cancelToken).asStream().map((event) {
      return IntensifyEntity<List<User>>(
          createSucceed: () => ResultEntity.createSucceedEntity(),
          data: PageTransformUtils.page2List(event.data));
    }).single;
  }

  static Future<IntensifyEntity<PageModel<User>>> list(
      int offset, int size, User? user, CancelToken cancelToken) {
    Map<String, dynamic> queryParams = RequestUtils.toPageQuery(user?.toJson(), offset, size);
    return _userApiClient.list(queryParams, cancelToken).successMap2Single((event) {
      return event.toPage2Intensify(offset, size, createData: (dataItem) {
        return User.fromJson(dataItem);
      });
    });
  }

  static Future<IntensifyEntity<List<DeptTree>>> deptTree(Dept? dept, CancelToken cancelToken,
      {bool removeParentId = false}) {
    Map<String, dynamic>? queryParams = dept?.toJson();
    queryParams?.removeWhere((k, v) => v == null);
    if (removeParentId) {
      queryParams?.remove("parentId");
    }
    return _userApiClient.deptTree(queryParams, cancelToken).successMap2Single((event) {
      return event.toListIntensify(createData: (dateItem) {
        return DeptTree.fromJson(dateItem);
      });
    });
  }

  static Future<IntensifyEntity<List<User>>> userListByDept(int deptId, CancelToken cancelToken) {
    return _userApiClient.userListByDept(deptId, cancelToken).successMap2Single((event) {
      return event.toListIntensify(createData: (dateItem) {
        return User.fromJson(dateItem);
      });
    });
  }

  static Future<IntensifyEntity<UserInfoVo>> getUserById(int? userId, CancelToken cancelToken) {
    return _userApiClient
        .getUserById(userId?.toString() ?? '', cancelToken)
        .successMap2Single((event) {
      return event.toIntensify<UserInfoVo>(createData: (resultEntity) {
        UserInfoVo userInfo = UserInfoVo.fromJson(resultEntity.data);
        userInfo.user?.sexName = GlobalVm()
            .dictShareVm
            .findDict(LocalDictLib.CODE_SYS_USER_SEX, userInfo.user?.sex)
            ?.tdDictLabel;
        userInfo.user?.statusName = GlobalVm()
            .dictShareVm
            .findDict(LocalDictLib.CODE_SYS_NORMAL_DISABLE, userInfo.user?.status)
            ?.tdDictLabel;
        fillUserPosts(userInfo);
        return userInfo;
      });
    });
  }

  static void fillUserPosts(UserInfoVo userInfo) {
    if (userInfo.postIds == null) {
      return;
    }
    List<Post> userPost = List.empty(growable: true);
    for (var postId in userInfo.postIds!) {
      Post target = userInfo.posts?.firstWhere((post) {
            return postId == post.postId;
          }) ??
          Post(postId: postId, postName: postId.toString());
      userPost.add(target);
    }
    userInfo.user!.posts = userPost;
  }

  static Future<IntensifyEntity<dynamic>> submit(User user, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = user.userId == null
        ? _userApiClient.add(user, cancelToken)
        : _userApiClient.edit(user, cancelToken);
    return resultFuture.successMap2Single((event) {
      return event.toIntensify();
    });
  }

  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? userId, List<int>? userIds}) {
    //参数校验
    assert(userId != null && userIds == null || userId == null && userIds != null);
    userIds ??= [userId!];
    return _userApiClient
        .delete(userIds.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }

  static Future<IntensifyEntity<dynamic>> resetPwd(User user, CancelToken cancelToken) {
    return _userApiClient.resetPwd(user, cancelToken).successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
