import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';

import '../../../../base/api/json_converter.dart';
import '../../../component/adapter/app_select_box.dart';

part 'sys_oss_vo.g.dart';

///@author sunlunchang
///文件上传返回信息
@JsonSerializable()
class SysOssVo extends TenantEntity with AppSelectBoxMixin<SysOssVo> {
  ///对象存储主键
  @IntConverter()
  int? ossId;

  ///文件名
  String? fileName;

  ///原名
  String? originalName;

  ///文件后缀名
  String? fileSuffix;

  ///URL地址
  String? url;

  ///服务商
  String? service;

  SysOssVo({this.ossId, this.fileName, this.originalName, this.fileSuffix, this.url, this.service});

  factory SysOssVo.fromJson(Map<String, dynamic> json) => _$SysOssVoFromJson(json);

  Map<String, dynamic> toJson() => _$SysOssVoToJson(this);

  static List<SysOssVo> fromJsonList(List<dynamic>? json) {
    return json?.map((item) {
          return SysOssVo.fromJson(item);
        }).toList() ??
        List.empty(growable: true);
  }
}
