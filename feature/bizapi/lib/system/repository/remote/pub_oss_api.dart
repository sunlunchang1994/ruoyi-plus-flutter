import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';
import 'package:component/component/attachment/entity/progress.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart';
import 'package:boxes_flutter/flutter/slc/network/api_constant.dart';
import 'package:retrofit/retrofit.dart';

import '../../entity/sys_oss_upload_vo.dart';

part 'pub_oss_api.g.dart';

/// @author sunlunchang
/// OSS存储服务
@RestApi()
abstract class PubOssApi {
  factory PubOssApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PubOssApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///上传文件（手动实现，不使用自动生成）
  // @POST("/resource/oss/upload")
  // Future<ResultEntity> upload(@Part(name: "file") File file);

  ///下载文件
  @POST("/resource/oss/download/{ossId}")
  Future<void> download(
      @Part(name: "ossId") String ossId,
      @CancelRequest() CancelToken? cancelToken,
      @ReceiveProgress() ProgressCallback? onReceiveProgress);
}

///OSS存储服务
class PubOssRepository {
  // static final PubOssApi _pubOssApi = PubOssApi(); // 暂时不使用自动生成的 API

  ///上传文件（支持 Web 平台）
  static Future<IntensifyEntity<SysOssUploadVo>> upload(MultipartFile file) async {
    try {
      // 手动构建 FormData
      final formData = FormData();
      formData.files.add(MapEntry('file', file));

      // 直接使用 Dio 发送请求
      final dio = BaseDio.getInstance().getDio();
      final response = await dio.post(
        '${ApiConfig().getServiceApiAddress()}/resource/oss/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      // 转换响应并检查错误
      final resultEntity = ResultEntity.fromJson(response.data);
      
      // 使用 successMap2Single 统一处理成功和错误响应
      return Future.value(resultEntity).successMap2Single((event) {
        var intensifyEntity = IntensifyEntity<SysOssUploadVo>(
            resultEntity: event,
            createData: (resultEntity) => SysOssUploadVo.fromJson(resultEntity.data));
        return intensifyEntity;
      });
    } catch (error) {
      return Future.error(error);
    }
  }

  ///下载文件
  static Future<Progress> download(String ossId, String savePath, CancelToken? cancelToken,
      {Function(Progress)? onReceiveProgress}) async {
    if (kIsWeb) {
      throw Exception("暂不支持web");
      //暂未支持web，且下载代码需要完善，如添加header
      /*final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final blob = html.Blob([bytes]);
      final downloadUrl = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = downloadUrl
        ..download = fileName
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(downloadUrl);
      return;*/
    }
    //通知开始
    onReceiveProgress?.call(Progress(status: DownloadStatus.waiting));
    Dio dio = BaseDio.getInstance().getDio();
    //下面参数中：
    // responseType：可不要，download底层已实现，
    // contentType: ApiConstant.VALUE_APPLICATION_STREAM，暂时不加，如果能正常下载则不加，或者加在headers中：headers: {ApiConstant.KEY_CONTENT_TYPE:ApiConstant.VALUE_APPLICATION_STREAM}
    await dio.download(_getOssDownloadPath(ossId), savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (int count, int total) => onReceiveProgress?.call(Progress(
            currentSize: count,
            totalSize: total,
            status: DownloadStatus.loading,
            filePath: savePath)),
        options: Options(
            method: 'GET',
            responseType: ResponseType.stream,
            contentType: ApiConstant.VALUE_APPLICATION_STREAM));
    return Progress(status: DownloadStatus.finish, filePath: savePath);
  }

  static String _getOssDownloadPath(String ossId) {
    return "${ApiConfig().getServiceApiAddress()}/resource/oss/download/$ossId";
  }
}
