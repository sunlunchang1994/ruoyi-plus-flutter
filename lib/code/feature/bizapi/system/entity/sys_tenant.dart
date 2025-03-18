import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/api/json_converter.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/adapter/app_select_box.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_tenant_package.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/base_entity.dart';

part 'sys_tenant.g.dart';

@JsonSerializable()
class SysTenant extends BaseEntity with AppSelectBoxMixin<SysTenant> {
  @IntConverter()
  int? id;

  ///租户编号
  String? tenantId;

  ///联系人姓名
  String? contactUserName;

  ///联系人电话
  String? contactPhone;

  ///公司名称
  String? companyName;

  ///营业执照号
  String? licenseNumber;

  ///地址
  String? address;

  ///域名
  String? domain;

  ///简介
  String? intro;

  ///备注
  String? remark;

  ///套餐ID
  int? packageId;

  ///到期时间
  String? expireTime;

  ///账户数量
  int? accountCount;

  ///状态
  String? status;

  ///删除标志
  String? delFlag;

  ///租户套餐
  SysTenantPackage? sysTenantPackage;

  //仅新增时使用
  ///用户名
  String? username;

  ///password
  String? password;

  //本地

  ///套餐名称
  String? packageName;

  SysTenant({
    this.id,
    this.tenantId,
    this.contactUserName,
    this.contactPhone,
    this.companyName,
    this.licenseNumber,
    this.address,
    this.domain,
    this.intro,
    this.remark,
    this.packageId,
    this.expireTime,
    this.accountCount,
    this.status,
    this.delFlag,
    this.sysTenantPackage,
  });

  factory SysTenant.fromJson(Map<String, dynamic> json) => _$SysTenantFromJson(json);

  Map<String, dynamic> toJson() => _$SysTenantToJson(this);

  static List<SysTenant> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => SysTenant.fromJson(json)).toList() ?? List.empty();
  }
}
