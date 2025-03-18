import 'package:json_annotation/json_annotation.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/base_entity.dart';
import 'package:ruoyi_plus_flutter/code/base/entity/tenant_entity.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/adapter/app_select_box.dart';

import '../../../../base/api/json_converter.dart';

part 'dept.g.dart';

@JsonSerializable()
class Dept extends TenantEntity with AppSelectBoxMixin<Dept> {
  @IntConverter()
  int? deptId;
  @IntConverter()
  int? parentId;
  String? parentName;
  String? deptName;
  String? deptCategory;
  int? orderNum;
  int? leader;
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
