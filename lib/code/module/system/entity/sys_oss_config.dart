import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';

import '../../../base/api/json_converter.dart';

part 'sys_oss_config.g.dart';

///oss配置
@JsonSerializable()
class SysOssConfig extends TenantEntity {
  ///主键
  @IntConverter()
  int? ossConfigId;

  ///配置key
  String? configKey;

  ///accessKey
  String? accessKey;

  ///秘钥
  String? secretKey;

  ///桶名称
  String? bucketName;

  ///前缀
  String? prefix;

  ///访问站点
  String? endpoint;

  ///自定义域名
  String? domain;

  ///是否https（0否 1是）
  String? isHttps;

  ///域
  String? region;

  ///是否默认（0=是,1=否）
  String? status;

  ///扩展字段
  String? ext1;

  ///备注
  String? remark;

  ///桶权限类型(0private 1public 2custom)
  String? accessPolicy;

  SysOssConfig(
      {this.ossConfigId,
      this.configKey,
      this.accessKey,
      this.secretKey,
      this.bucketName,
      this.prefix,
      this.endpoint,
      this.domain,
      this.isHttps,
      this.region,
      this.status,
      this.ext1,
      this.remark,
      this.accessPolicy});

  bool isDefStatus() {
    return status == LocalDictLib.KEY_SYS_YES_NO_INT_Y.toString();
  }

  factory SysOssConfig.fromJson(Map<String, dynamic> json) => _$SysOssConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SysOssConfigToJson(this);

  static List<SysOssConfig> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => SysOssConfig.fromJson(json)).toList() ?? List.empty();
  }
}
