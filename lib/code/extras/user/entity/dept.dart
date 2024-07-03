import 'package:json_annotation/json_annotation.dart';

part 'dept.g.dart';

@JsonSerializable()
class Dept {
  dynamic searchValue;
  dynamic createBy;
  dynamic createTime;
  dynamic updateBy;
  dynamic updateTime;
  dynamic remark;
  int? deptId;
  int? parentId;
  String? ancestors;
  String? deptName;
  int? orderNum;
  dynamic leader;
  dynamic phone;
  dynamic email;
  String? status;
  dynamic delFlag;
  dynamic parentName;
  List<Dept>? children;
  int? memberCount;

  Dept(
      {this.searchValue,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.remark,
      this.deptId,
      this.parentId,
      this.ancestors,
      this.deptName,
      this.orderNum,
      this.leader,
      this.phone,
      this.email,
      this.status,
      this.delFlag,
      this.parentName,
      this.children,
      this.memberCount});

  factory Dept.fromJson(Map<String, dynamic> json) => _$DeptFromJson(json);

  Map<String, dynamic> toJson() => _$DeptToJson(this);
}
