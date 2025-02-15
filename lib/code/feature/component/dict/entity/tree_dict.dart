abstract class ITreeDict<T extends ITreeDict<T>> {
  String? get tdId;

  String? get tdParentId => null;

  String? get tdCode;

  String? get tdDictValue;

  String? get tdDictLabel;

  int? get tdSort => null;

  String? get tdRemark => null;

  int? get tdIsSealed => null;

  int? get tdIsDeleted => null;

  String? get tdParentName => null;

  List<T>? get tdChildren => null;
}

class TreeDict extends ITreeDict<TreeDict> {
  ///主键
  String? id;

  ///父主键
  String? parentId;

  ///字典码
  String? code;

  ///字典值
  String? dictKey;

  ///字典名称
  String? dictValue;

  ///排序
  int? sort;

  //字典备注
  String? remark;

  ///是否已封存
  int? isSealed;

  ///是否已删除
  int? isDeleted;

  ///子节点
  List<TreeDict>? children;

  ///上级字典名称
  String? parentName;

  TreeDict(
      {this.id,
      this.parentId,
      this.code,
      this.dictKey,
      this.dictValue,
      this.sort,
      this.remark,
      this.isSealed,
      this.isDeleted,
      this.children,
      this.parentName});

  @override
  String? get tdId => id;

  @override
  String? get tdCode => code;

  @override
  String? get tdDictLabel => dictValue;

  @override
  String? get tdDictValue => dictKey;

  @override
  String? get tdParentId => parentId;

  @override
  List<TreeDict>? get tdChildren {
    if (children == null) {
      return List.empty(growable: true);
    }
    return children;
  }
}
