import 'package:json_annotation/json_annotation.dart';

part 'oss_upload_vo.g.dart';

///@Author sunlunchang
///文件上传返回信息
@JsonSerializable()
class OssUploadVo {
  ///url地址
  String? url;

  ///文件名
  String? fileName;

  ///对象存储主键
  String? ossId;

  OssUploadVo({this.url, this.fileName, this.ossId});

  factory OssUploadVo.fromJson(Map<String, dynamic> json) => _$OssUploadVoFromJson(json);

  Map<String, dynamic> toJson() => _$OssUploadVoToJson(this);
}
