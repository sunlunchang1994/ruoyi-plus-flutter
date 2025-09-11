import '../api/json_converter.dart';

///@author sunlunchang
///后端数据实体类基础类
class BaseEntity {
  String? searchValue;

  @IntConverter()
  int? createDept;

  @IntConverter()
  int? createBy;

  String? createTime;

  @IntConverter()
  int? updateBy;

  String? updateTime;

  Map<String, dynamic>? params;

  String? createDeptName;
  String? createByName;
  String? updateByName;

  BaseEntity(
      {this.searchValue,
      this.createDept,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.params,
      this.createDeptName,
      this.createByName,
      this.updateByName});
}
