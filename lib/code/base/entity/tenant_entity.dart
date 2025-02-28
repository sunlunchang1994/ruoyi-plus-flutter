import 'package:ruoyi_plus_flutter/code/base/entity/base_entity.dart';

///@author sunlunchang
///租户实体类基础类
class TenantEntity extends BaseEntity {
  String? tenantId;

  TenantEntity(
      {this.tenantId,
      super.searchValue,
      super.createDept,
      super.createBy,
      super.createTime,
      super.updateBy,
      super.updateTime,
      super.params});
}
