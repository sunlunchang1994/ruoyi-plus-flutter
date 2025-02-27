import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/adapter/app_select_box.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_menu_tree.dart';

import '../../../base/api/json_converter.dart';

part 'sys_menu_tree.g.dart';

///@author slc
///菜单树结构
@JsonSerializable()
class SysMenuTree with AppSelectBoxMixin<SysMenuTree> {
  @IntConverter()
  int id;
  @IntConverter()
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

  static void getSelectAll2Ids(
      List<int> collection, List<SysMenuTree>? dataList,
      {bool penetrate = false, bool linkageEnable = true}) {
    if (linkageEnable) {
      SelectUtils.getSelectListWithLinkage(dataList, collection: collection,
          convert: (src) {
        return src.boxData!.id;
      });
    } else {
      SelectUtils.getSelect(dataList, collection: collection, convert: (src) {
        return src.boxData!.id;
      }, penetrate: penetrate);
    }
  }

  //获取选择状态：分为三种状态
  bool? getCheckedStatus() {
    if (isBoxChecked()) {
      return true;
    }
    if (boxChildren == null) {
      return false;
    }
    for (var item in boxChildren!) {
      if (item.isBoxChecked()) {
        return null;
      }
    }
    return false;
  }

  @override
  List<SysMenuTree>? get boxChildren => children;
}

///@author slc
///菜单树结构
@JsonSerializable()
class SysMenuTreeWrapper {
  List<int>? checkedKeys;
  List<SysMenuTree>? menus;

  SysMenuTreeWrapper({this.checkedKeys, this.menus});

  factory SysMenuTreeWrapper.fromJson(Map<String, dynamic> json) =>
      _$SysMenuTreeWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$SysMenuTreeWrapperToJson(this);
}

///@author slc
///菜单树结构
@JsonSerializable()
class SysMenuTreeWrapperOnlyCheckedKeys {
  List<int>? checkedKeys;

  SysMenuTreeWrapperOnlyCheckedKeys({this.checkedKeys});

  factory SysMenuTreeWrapperOnlyCheckedKeys.fromJson(
          Map<String, dynamic> json) =>
      _$SysMenuTreeWrapperOnlyCheckedKeysFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SysMenuTreeWrapperOnlyCheckedKeysToJson(this);
}
