import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/base_entity.dart';

part 'dept.g.dart';

@JsonSerializable()
class Dept extends BaseEntity {
  int? deptId;
  int? parentId;
  String? deptName;
  String? deptCategory;
  int? orderNum;
  int? leader;
  String? leaderName;
  String? phone;
  String? email;
  String? status;

  Dept(
      {this.deptId,
      this.parentId,
      this.deptName,
      this.deptCategory,
      this.orderNum,
      this.leader,
      this.leaderName,
      this.phone,
      this.email,
      this.status,
      super.createDept,
      super.createBy,
      super.createTime,
      super.updateBy,
      super.updateTime});

  String deptNameVo() {
    return deptName!;
  }

  int deptIdVo() {
    return deptId!;
  }

  int parentIdVo() {
    return parentId!;
  }

  factory Dept.fromJson(Map<String, dynamic> json) => _$DeptFromJson(json);

  Map<String, dynamic> toJson() => _$DeptToJson(this);

  static List<Dept> formJsonList(List<dynamic>? data) {
    return data?.map((json) => Dept.fromJson(json)).toList() ?? List.empty();
  }
}
