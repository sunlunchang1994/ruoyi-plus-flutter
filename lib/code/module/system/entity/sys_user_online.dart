import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/api/json_converter.dart';

part 'sys_user_online.g.dart';

/// 当前在线会话
///
/// @author slc
@JsonSerializable()
class SysUserOnline {
  /// 会话编号
  String? tokenId;

  /// 部门名称
  String? deptName;

  /// 用户名称
  String? userName;

  /// 客户端
  String? clientKey;

  /// 设备类型
  String? deviceType;

  /// 登录IP地址
  String? ipaddr;

  /// 登录地址
  String? loginLocation;

  /// 浏览器类型
  String? browser;

  /// 操作系统
  String? os;

  /// 登录时间
  @MillisecondConverter()
  String? loginTime;

  // 本地添加的字段
  bool showDetail = false;
  
  SysUserOnline({
    this.tokenId,
    this.deptName,
    this.userName,
    this.clientKey,
    this.deviceType,
    this.ipaddr,
    this.loginLocation,
    this.browser,
    this.os,
    this.loginTime,
  });

  factory SysUserOnline.fromJson(Map<String, dynamic> json) => _$SysUserOnlineFromJson(json);

  Map<String, dynamic> toJson() => _$SysUserOnlineToJson(this);

  static List<SysUserOnline> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => SysUserOnline.fromJson(json)).toList() ?? List.empty();
  }
}