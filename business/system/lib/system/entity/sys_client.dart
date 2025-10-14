import 'package:base/base/api/json_converter.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:base/base/entity/tenant_entity.dart';
import 'package:component/component/adapter/app_select_box.dart';

part 'sys_client.g.dart';

///@auther sunlunchang
///客户端 sys_client
@JsonSerializable()
class SysClient extends TenantEntity with AppSelectBoxMixin<SysClient> {
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
  List<String>? get grantTypeList => TextUtil.split(grantType, TextUtil.comma);

  set grantTypeList(List<String>? value) => grantType = value?.join(TextUtil.comma);

  ///授权类型
  @JsonKey(includeFromJson: false, includeToJson: true)
  List<String>? get deviceTypeList => TextUtil.split(deviceType, TextUtil.comma);

  set deviceTypeList(List<String>? value) => deviceType = value?.join(TextUtil.comma);

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
