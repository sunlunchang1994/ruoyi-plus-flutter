import 'package:base/base/api/json_converter.dart';
import 'package:base/base/entity/tenant_entity.dart';
import 'package:component/component/adapter/app_select_box.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dept.g.dart';

/// @author sunlunchang
/// 部门实体类
@JsonSerializable()
class Dept extends TenantEntity with AppSelectBoxMixin<Dept> {
  @BigIntConverter()
  BigInt? deptId;
  @BigIntConverter()
  BigInt? parentId;
  String? parentName;
  String? deptName;
  String? deptCategory;
  int? orderNum;
  @BigIntConverter()
  BigInt? leader;
  String? leaderName;
  String? phone;
  String? email;
  String? status;
  String? ancestors;

  Dept(
      {this.deptId,
      this.parentId,
      this.parentName,
      this.deptName,
      this.deptCategory,
      this.orderNum,
      this.leader,
      this.leaderName,
      this.phone,
      this.email,
      this.status,
      this.ancestors,
      super.tenantId,
      super.searchValue,
      super.createDept,
      super.createBy,
      super.createTime,
      super.updateBy,
      super.updateTime,
      super.params});

  String deptNameVo() {
    return deptName!;
  }

  BigInt deptIdVo() {
    return deptId!;
  }

  BigInt parentIdVo() {
    return parentId!;
  }

  factory Dept.fromJson(Map<String, dynamic> json) => _$DeptFromJson(json);

  Map<String, dynamic> toJson() => _$DeptToJson(this);

  static List<Dept> formJsonList(List<dynamic>? data) {
    return data?.map((json) => Dept.fromJson(json)).toList() ?? List.empty();
  }
}
