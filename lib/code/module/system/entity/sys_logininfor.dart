import 'package:json_annotation/json_annotation.dart';

import '../../../base/api/json_converter.dart';

part 'sys_logininfor.g.dart';

///系统访问记录表 sys_logininfor
@JsonSerializable()
class SysLogininfor {
  ///ID
  @IntConverter()
  int? infoId;

  ///租户编号
  String? tenantId;

  ///用户账号
  String? userName;

  ///客户端
  String? clientKey;

  ///设备类型
  String? deviceType;

  ///登录状态 0成功 1失败
  String? status;

  ///登录IP地址
  String? ipaddr;

  ///登录地点
  String? loginLocation;

  ///浏览器类型
  String? browser;

  ///操作系统
  String? os;

  ///提示消息
  String? msg;

  ///访问时间
  String? loginTime;

  //本地的
  String? statusName;

  //显示详情
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool showDetail = false;

  SysLogininfor(
      {this.infoId,
      this.tenantId,
      this.userName,
      this.clientKey,
      this.deviceType,
      this.status,
      this.ipaddr,
      this.loginLocation,
      this.browser,
      this.os,
      this.msg,
      this.loginTime});

  factory SysLogininfor.fromJson(Map<String, dynamic> json) => _$SysLogininforFromJson(json);

  Map<String, dynamic> toJson() => _$SysLogininforToJson(this);

  static List<SysLogininfor> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => SysLogininfor.fromJson(json)).toList() ?? List.empty();
  }
}
