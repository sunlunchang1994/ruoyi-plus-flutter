import 'package:bizapi/user/entity/post.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:boxes_flutter/flutter/slc/adapter/page_model.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:base/base/api/request_utils.dart';

import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';

part 'post_api.g.dart';

@RestApi()
abstract class PostApi {
  factory PostApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PostApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取岗位列表
  @GET("/system/post/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? data, @CancelRequest() CancelToken cancelToken);

  ///获取岗位信息
  @GET("/system/post/{postId}")
  Future<ResultEntity> getInfo(
      @Path("postId") String postId, @CancelRequest() CancelToken cancelToken);

  ///添加岗位
  @POST("/system/post")
  Future<ResultEntity> add(@Body() Post? data, @CancelRequest() CancelToken cancelToken);

  ///编辑岗位
  @PUT("/system/post")
  Future<ResultEntity> edit(@Body() Post? data, @CancelRequest() CancelToken cancelToken);

  ///删除岗位
  @DELETE("/system/post/{postIds}")
  Future<ResultEntity> delete(
      @Path("postIds") String postIds, @CancelRequest() CancelToken cancelToken);
}

///岗位服务
class PostRepository {
  //实例
  static final PostApi _postApi = PostApi();

  ///获取岗位列表
  static Future<IntensifyEntity<PageModel<Post>>> list(
      int offset, int size, Post? post, CancelToken cancelToken) {
    Map<String, dynamic> queryParams = RequestUtils.toPageQuery(post?.toJson(), offset, size);
    queryParams["orderByColumn"] = "deptId,postId";
    queryParams["isAsc"] = "asc";
    return _postApi.list(queryParams, cancelToken).successMap2Single((event) {
      return event.toPage2Intensify(offset, size,
          createData: (dataItem) => Post.fromJson(dataItem));
    });
  }

  ///获取岗位信息
  static Future<IntensifyEntity<Post>> getInfo(BigInt postId, CancelToken cancelToken) {
    return _postApi.getInfo(postId.toString(), cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return Post.fromJson(resultEntity.data);
      });
    });
  }

  ///提交岗位信息
  static Future<IntensifyEntity<dynamic>> submit(Post post, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = post.postId == null
        ? _postApi.add(post, cancelToken)
        : _postApi.edit(post, cancelToken);
    return resultFuture.successMap2Single((event) {
      return event.toIntensify<dynamic>();
    });
  }

  //删除岗位
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {BigInt? postId, List<BigInt>? postIds}) {
    //参数校验
    assert(postId != null && postIds == null || postId == null && postIds != null);
    postIds ??= [postId!];
    return _postApi
        .delete(postIds.map((e) => e.toString()).join(TextUtil.comma), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
