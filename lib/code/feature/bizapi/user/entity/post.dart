import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../base/api/json_converter.dart';
import '../../../../base/entity/tenant_entity.dart';
import '../../../component/adapter/app_select_box.dart';

part 'post.g.dart';

@JsonSerializable()
class Post extends TenantEntity with AppSelectBoxMixin<Post> {
  @IntConverter()
  int? postId;
  @IntConverter()
  int? deptId;
  String? postCode;
  String? postName;
  String? postCategory;
  int? postSort;
  String? status;
  String? remark;
  String? deptName;

  String? statusName;

  Post(
      {this.postId,
      this.deptId,
      this.postCode,
      this.postName,
      this.postCategory,
      this.postSort,
      this.status,
      this.remark,
      this.deptName,
      this.statusName,
      super.tenantId,
      super.searchValue,
      super.createDept,
      super.createBy,
      super.createTime,
      super.updateBy,
      super.updateTime,
      super.params});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  static List<Post> formJsonList(List<dynamic>? data) {
    return data?.map((json) => Post.fromJson(json)).toList() ?? List.empty();
  }

  static List<int>? toPostIdList(List<Post>? values) {
    return values?.map((value) {
      return value.postId!;
    }).toList();
  }
}
