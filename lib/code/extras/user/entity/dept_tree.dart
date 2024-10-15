import 'package:json_annotation/json_annotation.dart';

part 'dept_tree.g.dart';

///@Author sunlunchang
///部门树信息
@JsonSerializable()
class DeptTree {

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

  static List<DeptTree> fromJsonList(List<dynamic>? data){
    return data?.map((json) => DeptTree.fromJson(json)).toList() ??
        List.empty();
  }
}
