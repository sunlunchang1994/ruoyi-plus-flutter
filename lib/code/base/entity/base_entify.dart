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
