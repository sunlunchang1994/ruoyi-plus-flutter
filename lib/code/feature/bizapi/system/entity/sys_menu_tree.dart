import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/adapter/app_select_box.dart';

part 'sys_menu_tree.g.dart';

///@author slc
///菜单树结构
@JsonSerializable()
class SysMenuTree with AppSelectBoxMixin {
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

  static List<SysMenuTree> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => SysMenuTree.fromJson(json)).toList() ??
        List.empty();
  }

  static selectAll(List<SysMenuTree>? dataList, bool isSelected,
      {bool penetrate = false}) {
    if (dataList == null) {
      return;
    }
    for (var item in dataList) {
      item.boxChecked = isSelected;
      if (item.children != null && penetrate) {
        selectAll(item.children, isSelected, penetrate: penetrate);
      }
    }
  }

  static void getSelectAll2Ids(
      List<int> collection, List<SysMenuTree>? dataList,
      {bool penetrate = false}) {
    dataList?.forEach((item) {
      if (item.boxChecked) {
        collection.add(item.id);
      }

      if (item.children != null && penetrate) {
        getSelectAll2Ids(collection, item.children, penetrate: penetrate);
      }
    });
  }
}
