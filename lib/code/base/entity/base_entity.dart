///@Author sunlunchang
///后端数据实体类基础类
class BaseEntity {
  int? id;

  int? createUser;

  int? createDept;

  String? createTime;

  int? updateUser;

  String? updateTime;

  int? status;

  int? isDeleted;

  BaseEntity(
      {this.id,
      this.createUser,
      this.createDept,
      this.createTime,
      this.updateUser,
      this.updateTime,
      this.status,
      this.isDeleted});
}
