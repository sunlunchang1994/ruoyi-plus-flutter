import 'package:json_annotation/json_annotation.dart';

part 'sys_oss_upload_vo.g.dart';

///@author sunlunchang
///文件上传返回信息
@JsonSerializable()
class SysOssUploadVo {
  ///url地址
  String? url;

  ///文件名
  String? fileName;

  ///对象存储主键
  String? ossId;

  SysOssUploadVo({this.url, this.fileName, this.ossId});

  factory SysOssUploadVo.fromJson(Map<String, dynamic> json) => _$SysOssUploadVoFromJson(json);

  Map<String, dynamic> toJson() => _$SysOssUploadVoToJson(this);
}
