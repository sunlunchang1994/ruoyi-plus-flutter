///@Author sunlunchang
///后端数据实体类基础类
class BaseEntity {
  String? searchValue;

  int? createDept;

  int? createBy;

  String? createTime;

  int? updateBy;

  String? updateTime;

  Map<String, dynamic>? params;

  BaseEntity(
      {this.searchValue,
      this.createDept,
      this.createBy,
      this.createTime,
      this.updateBy,
      this.updateTime,
      this.params});
}
