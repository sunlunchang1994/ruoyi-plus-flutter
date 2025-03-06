import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../../base/api/api_config.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../../../../base/repository/remote/data_transform_utils.dart';
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
}

///OSS存储服务
class PubOssRepository {
  static final PubOssApiClient _ossApiClient = PubOssApiClient();

  ///上传文件
  static Future<IntensifyEntity<SysOssUploadVo>> upload(String filePath) async {
    return _ossApiClient
        .upload(File(filePath))
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<SysOssUploadVo>(
              resultEntity: event, createData: (resultEntity) => SysOssUploadVo.fromJson(resultEntity.data));
          return intensifyEntity;
        })
        .map(DataTransformUtils.checkErrorIe)
        .single;
  }
}
