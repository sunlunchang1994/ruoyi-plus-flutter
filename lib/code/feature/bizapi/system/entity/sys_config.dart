import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';

import '../../../../base/api/json_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sys_config.g.dart';

///@author sunlunchang
///参数配置
@JsonSerializable()
class SysConfig extends TenantEntity {
  ///参数主键
  int? configId;

  ///参数名称
  String? configName;

  ///参数键名
  String? configKey;

  ///参数键值
  String? configValue;

  ///系统内置（Y是 N否）
  String? configType;

  ///备注
  String? remark;

  SysConfig(
      {this.configId,
      this.configName,
      this.configKey,
      this.configValue,
      this.configType,
      this.remark});

  factory SysConfig.fromJson(Map<String, dynamic> json) =>
      _$SysConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SysConfigToJson(this);

  static List<SysConfig> fromJsonList(List<dynamic>? json) {
    return json?.map((item) {
          return SysConfig.fromJson(item);
        }).toList(growable: true) ??
        List.empty(growable: true);
  }
}
