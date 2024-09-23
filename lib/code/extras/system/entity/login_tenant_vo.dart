import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/extras/system/entity/tenant_list_vo.dart';

part 'login_tenant_vo.g.dart';

///@Author sunlunchang
///登录租户对象
@JsonSerializable()
class LoginTenantVo {
  ///租户编号
  bool? tenantEnabled;

  ///租户对象列表
  List<TenantListVo>? voList;

  LoginTenantVo(this.tenantEnabled, this.voList);

  factory LoginTenantVo.fromJson(Map<String, dynamic> json) =>
      _$LoginTenantVoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginTenantVoToJson(this);
}
