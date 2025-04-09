import 'package:json_annotation/json_annotation.dart';

import '../../../feature/component/adapter/app_select_box.dart';

part 'dept_tree.g.dart';

///@author sunlunchang
///部门树信息
@JsonSerializable()
class DeptTree with AppSelectBoxMixin<DeptTree> {
  //部门id
  int id;

  //标题
  String label;

  //父id
  int? parentId;

  //部门树子结构
  List<DeptTree>? children;

  DeptTree(this.id, this.label, this.parentId, {this.children});

  factory DeptTree.fromJson(Map<String, dynamic> json) => _$DeptTreeFromJson(json);

  Map<String, dynamic> toJson() => _$DeptTreeToJson(this);

  static List<DeptTree> fromJsonList(List<dynamic>? data) {
    return data?.map((json) => DeptTree.fromJson(json)).toList() ?? List.empty();
  }

  static void deptTree2Tile(List<DeptTree>? targetData, List<DeptTree> collection) {
    if (targetData == null) {
      return;
    }
    for (var item in targetData) {
      collection.add(item);
      deptTree2Tile(item.children, collection);
    }
  }
}
