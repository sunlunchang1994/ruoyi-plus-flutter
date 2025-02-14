import 'package:json_annotation/json_annotation.dart';

part 'tenant_list_vo.g.dart';

///@Author sunlunchang
///租户列表信息
@JsonSerializable()
class TenantListVo {
  ///租户编号
  String? tenantId;

  ///企业名称
  String? companyName;

  ///域名
  String? domain;

  TenantListVo(this.tenantId, this.companyName, this.domain);

  factory TenantListVo.fromJson(Map<String, dynamic> json) =>
      _$TenantListVoFromJson(json);

  Map<String, dynamic> toJson() => _$TenantListVoToJson(this);
}
