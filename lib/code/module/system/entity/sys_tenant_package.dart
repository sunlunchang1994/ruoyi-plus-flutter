import 'package:flutter_slc_boxes/flutter/slc/common/slc_num_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/base_entity.dart';

import '../../../base/api/json_converter.dart';

part 'sys_tenant_package.g.dart';

@JsonSerializable()
class SysTenantPackage extends BaseEntity {
  @IntConverter()
  int? packageId;

  String? packageName;

  //提交时是List<int>，获取时是String
  Object? menuIds;

  String? remark;

  //菜单树选择项是否关联显示（ 0：父子不互相关联显示 1：父子互相关联显示）
  bool? menuCheckStrictly;

  String? status;

  String? delFlag;

  @JsonKey(includeFromJson: false, includeToJson: true)
  List<int>? get menuIdList {
    if (menuIds is List<int>) {
      return menuIds as List<int>;
    }
    return TextUtil.split(menuIds as String, TextUtil.COMMA)
        .map((e) => SlcNumUtil.getIntByValueStr(e.trim()))
        .nonNulls
        .toList();
  }

  set menuIdList(List<int>? menuIdList) {
    if (menuIds is List<int>) {
      this.menuIds = menuIdList as Object;
      return;
    }
    menuIds = menuIdList?.join(TextUtil.COMMA) as String;
  }

  SysTenantPackage({
    this.packageId,
    this.packageName,
    this.menuIds,
    this.remark,
    this.menuCheckStrictly,
    this.status,
    this.delFlag,
  });

  factory SysTenantPackage.fromJson(Map<String, dynamic> json) => _$SysTenantPackageFromJson(json);

  Map<String, dynamic> toJson() => _$SysTenantPackageToJson(this);

  static List<SysTenantPackage> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => SysTenantPackage.fromJson(json)).toList() ?? List.empty();
  }
}
