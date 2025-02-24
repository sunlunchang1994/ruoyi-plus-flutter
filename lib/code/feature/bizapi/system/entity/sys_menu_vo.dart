import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';

import '../../../../base/api/json_converter.dart';

part 'sys_menu_vo.g.dart';
///@author slc
///菜单实体类
@JsonSerializable()
class SysMenuVo extends TenantEntity {
  //菜单ID
  int? menuId;

  //父菜单ID
  int? parentId;

  //菜单名称
  String? menuName;

  //显示顺序
  int? orderNum;

  //路由地址
  String? path;

  //组件路径
  String? component;

  //路由参数
  String? queryParam;

  //是否为外链（0是 1否）
  String? isFrame;

  //是否缓存（0缓存 1不缓存）
  String? isCache;

  //类型（M目录 C菜单 F按钮）
  String? menuType;

  //显示状态（0显示 1隐藏）
  String? visible;

  //菜单状态（0正常 1停用）
  String? status;

  //权限字符串
  String? perms;

  //菜单图标
  String? icon;

  //备注
  String? remark;

  //父菜单名称
  String? parentName;

  //子菜单
  List<SysMenuVo>? children;

  SysMenuVo(
      {this.menuId,
      this.parentId,
      this.menuName,
      this.orderNum,
      this.path,
      this.component,
      this.queryParam,
      this.isFrame,
      this.isCache,
      this.menuType,
      this.visible,
      this.status,
      this.perms,
      this.icon,
      this.remark,
      this.parentName,
      this.children});

  factory SysMenuVo.fromJson(Map<String, dynamic> json) =>
      _$SysMenuVoFromJson(json);

  Map<String, dynamic> toJson() => _$SysMenuVoToJson(this);


  static List<SysMenuVo> fromJsonList(List<dynamic>? data){
    return data?.map((json) => SysMenuVo.fromJson(json)).toList() ??
        List.empty();
  }
}
