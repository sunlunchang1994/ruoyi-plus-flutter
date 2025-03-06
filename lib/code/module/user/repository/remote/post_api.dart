import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/user/entity/post.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';

part 'post_api.g.dart';

@RestApi()
abstract class PostApiClient {
  factory PostApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PostApiClient(dio,
        baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取岗位列表
  @GET("/system/post/list")
  Future<ResultPageModel> list(@Queries() Map<String, dynamic>? data,
      @CancelRequest() CancelToken cancelToken);

  ///获取岗位信息
  @GET("/system/post/{postId}")
  Future<ResultEntity> getInfo(
      @Path("postId") int postId, @CancelRequest() CancelToken cancelToken);

  ///添加岗位
  @POST("/system/post")
  Future<ResultEntity> add(
      @Body() Post? data, @CancelRequest() CancelToken cancelToken);

  ///编辑岗位
  @PUT("/system/post")
  Future<ResultEntity> edit(
      @Body() Post? data, @CancelRequest() CancelToken cancelToken);
}

///岗位服务
class PostRepository {
  //实例
  static final PostApiClient _deptApiClient = PostApiClient();

  ///获取岗位列表
  static Future<IntensifyEntity<PageModel<Post>>> list(
      int offset, int size, Post? post, CancelToken cancelToken) {
    Map<String, dynamic> queryParams =
        RequestUtils.toPageQuery(post?.toJson(), offset, size);
    queryParams["orderByColumn"] = "deptId,postId";
    queryParams["isAsc"] = "asc";
    return _deptApiClient
        .list(queryParams, cancelToken)
        .asStream()
        .map((event) {
          return event.toIntensify(createData: (resultEntity) {
            /*AppPageModel appPageModel = AppPageModel(
                current: offset,
                size: size,
                rows: event.rows,
                total: event.total);
            List<Post> dataList = Post.formJsonList(event.rows); //列表为空时创建默认的
            PageModel<Post> pageModel =
                PageTransformUtils.appPm2Pm(appPageModel, records: dataList);
            return pageModel;*/
            return resultEntity.toPageModel(offset, size,
                createRecords: (rows) => Post.formJsonList(rows));
          });
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }

  ///获取岗位信息
  static Future<IntensifyEntity<Post>> getInfo(
      int postId, CancelToken cancelToken) {
    return _deptApiClient
        .getInfo(postId, cancelToken)
        .asStream()
        .map((event) {
          return event.toIntensify(createData: (resultEntity) {
            return Post.fromJson(resultEntity.data);
          });
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }

  ///提交岗位信息
  static Future<IntensifyEntity<dynamic>> submit(
      Post post, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = post.postId == null
        ? _deptApiClient.add(post, cancelToken)
        : _deptApiClient.edit(post, cancelToken);
    return resultFuture
        .asStream()
        .map((event) {
          return event.toIntensify<dynamic>();
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }
}
