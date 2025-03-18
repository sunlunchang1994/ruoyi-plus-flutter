import 'package:json_annotation/json_annotation.dart';

import '../../../base/api/json_converter.dart';
import '../../../feature/component/adapter/app_select_box.dart';

part 'sys_oper_log.g.dart';

///操作日志记录表 oper_log
@JsonSerializable()
class SysOperLog with AppSelectBoxMixin<SysOperLog> {
  ///日志主键
  @IntConverter()
  int? operId;

  ///租户编号
  String? tenantId;

  ///操作模块
  String? title;

  ///业务类型（0其它 1新增 2修改 3删除）
  int? businessType;

  ///请求方法
  String? method;

  ///请求方式
  String? requestMethod;

  ///操作类别（0其它 1后台用户 2手机端用户）
  int? operatorType;

  ///操作人员
  String? operName;

  ///部门名称
  String? deptName;

  ///请求url
  String? operUrl;

  ///操作地址
  String? operIp;

  ///操作地点
  String? operLocation;

  ///请求参数
  String? operParam;

  ///返回参数
  String? jsonResult;

  ///操作状态（0正常 1异常）
  @StringConverter()
  String? status;

  ///错误消息
  String? errorMsg;

  ///操作时间
  String? operTime;

  ///消耗时间
  @IntConverter()
  int? costTime;

  //本地
  String? businessTypeName;

  String? statusName;

  SysOperLog(
      {this.operId,
      this.tenantId,
      this.title,
      this.businessType,
      this.method,
      this.requestMethod,
      this.operatorType,
      this.operName,
      this.deptName,
      this.operUrl,
      this.operIp,
      this.operLocation,
      this.operParam,
      this.jsonResult,
      this.status,
      this.errorMsg,
      this.operTime,
      this.costTime});

  factory SysOperLog.fromJson(Map<String, dynamic> json) => _$SysOperLogFromJson(json);

  Map<String, dynamic> toJson() => _$SysOperLogToJson(this);

  static List<SysOperLog> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => SysOperLog.fromJson(json)).toList() ?? List.empty();
  }
}
