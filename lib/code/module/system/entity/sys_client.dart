import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';

import '../../../base/api/json_converter.dart';

part 'sys_client.g.dart';

///@auther sunlunchang
///客户端 sys_client
@JsonSerializable()
class SysClient extends TenantEntity {
  ///id
  @IntConverter()
  int? id;

  ///客户端id
  String? clientId;

  ///客户端key
  String? clientKey;

  ///客户端秘钥
  String? clientSecret;

  ///授权类型
  String? grantType;

  ///设备类型
  String? deviceType;

  ///token活跃超时时间
  @IntConverter()
  int? activeTimeout;

  ///token固定超时时间
  @IntConverter()
  int? timeout;

  ///状态（0正常 1停用）
  String? status;

  ///删除标志（0代表存在 1代表删除）
  String? delFlag;

  //本地的
  String? statusName;

  ///授权类型
  ///
  @JsonKey(includeFromJson: false, includeToJson: true)
  List<String>? get grantTypeList => TextUtil.split(grantType, TextUtil.COMMA);

  set grantTypeList(List<String>? value) => grantType = value?.join(TextUtil.COMMA);

  ///授权类型
  @JsonKey(includeFromJson: false, includeToJson: true)
  List<String>? get deviceTypeList => TextUtil.split(deviceType, TextUtil.COMMA);

  set deviceTypeList(List<String>? value) => deviceType = value?.join(TextUtil.COMMA);

  SysClient(
      {this.id,
      this.clientId,
      this.clientKey,
      this.clientSecret,
      this.grantType,
      this.deviceType,
      this.activeTimeout,
      this.timeout,
      this.status,
      this.delFlag});

  factory SysClient.fromJson(Map<String, dynamic> json) => _$SysClientFromJson(json);

  Map<String, dynamic> toJson() => _$SysClientToJson(this);

  static List<SysClient> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => SysClient.fromJson(json)).toList() ?? List.empty();
  }
}
