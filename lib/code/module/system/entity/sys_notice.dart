import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';

import '../../../base/api/json_converter.dart';

part 'sys_notice.g.dart';

///@author slc
///通知公告实体类
@JsonSerializable()
class SysNotice extends TenantEntity {
  //菜单ID
  @IntConverter()

  ///公告ID
  int? noticeId;

  ///公告标题
  String? noticeTitle;

  ///公告类型（1通知 2公告）
  String? noticeType;

  ///公告内容
  String? noticeContent;

  ///公告状态（0正常 1关闭）
  String? status;

  ///备注
  String? remark;

  //本地
  String? noticeTypeName;

  SysNotice(
      {this.noticeId,
      this.noticeTitle,
      this.noticeType,
      this.noticeContent,
      this.status,
      this.remark});

  factory SysNotice.fromJson(Map<String, dynamic> json) =>
      _$SysNoticeFromJson(json);

  Map<String, dynamic> toJson() => _$SysNoticeToJson(this);

  static List<SysNotice> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => SysNotice.fromJson(json)).toList() ??
        List.empty();
  }
}
