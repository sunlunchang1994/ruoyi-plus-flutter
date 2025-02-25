
import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/adapter/app_select_box.dart';

part 'sys_menu_tree.g.dart';
///@author slc
///菜单树结构
@JsonSerializable()
class SysMenuTree with AppSelectBoxMixin{
  int id;
  int parentId;
  String label;
  int weight;
  String menuType;
  String icon;

  List<SysMenuTree>? children;

  SysMenuTree(
      this.id, this.parentId, this.label, this.weight, this.menuType, this.icon,
      {this.children});


  factory SysMenuTree.fromJson(Map<String, dynamic> json) =>
      _$SysMenuTreeFromJson(json);

  Map<String, dynamic> toJson() => _$SysMenuTreeToJson(this);


  static List<SysMenuTree> fromJsonList(List<dynamic>? data){
    return data?.map((json) => SysMenuTree.fromJson(json)).toList() ??
        List.empty();
  }
}
