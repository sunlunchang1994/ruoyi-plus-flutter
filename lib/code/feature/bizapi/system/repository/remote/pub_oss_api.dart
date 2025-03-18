import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart';
import 'package:flutter_slc_boxes/flutter/slc/network/api_constant.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../base/api/api_config.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../component/attachment/entity/progress.dart';
import '../../entity/sys_oss_upload_vo.dart';

part 'pub_oss_api.g.dart';

@RestApi()
abstract class PubOssApiClient {
  factory PubOssApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PubOssApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///上传文件
  @POST("/resource/oss/upload")
  Future<ResultEntity> upload(@Part(name: "file") File file);

  ///下载文件
  @POST("/resource/oss/download/{ossId}")
  Future<void> download(
      @Part(name: "ossId") String ossId,
      @CancelRequest() CancelToken? cancelToken,
      @ReceiveProgress() ProgressCallback? onReceiveProgress);
}

///OSS存储服务
class PubOssRepository {
  static final PubOssApiClient _ossApiClient = PubOssApiClient();

  ///上传文件
  static Future<IntensifyEntity<SysOssUploadVo>> upload(String filePath) async {
    return _ossApiClient.upload(File(filePath)).successMap2Single((event) {
      var intensifyEntity = IntensifyEntity<SysOssUploadVo>(
          resultEntity: event,
          createData: (resultEntity) => SysOssUploadVo.fromJson(resultEntity.data));
      return intensifyEntity;
    });
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
