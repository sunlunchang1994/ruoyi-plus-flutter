// 将 SelectBox 改为可混入的 Mixin
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:json_annotation/json_annotation.dart';

mixin AppSelectBoxMixin<T> implements ISelectBox<T> {
  // 使用 late 延迟初始化，由混入类负责初始化

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Map<String, dynamic> _boxMap = {};

  // 初始化方法（由混入类调用）
  void initSelectBox({int index = -1, bool checked = false}) {
    _boxMap.addAll({
      'selectIndex': index,
      'checked': checked,
    });
  }

  // 接口实现

  //混入时，data就是本身
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  T? get boxData => this as T;

  @override
  set boxData(T? value) {
    //混入时，data就是本身，所以此处什么都不用做
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int? get boxSelectIndex => _boxMap['selectIndex'] as int?;

  @override
  set boxSelectIndex(int? value) => _boxMap['selectIndex'] = value;

  @override
  int getBoxSelectIndex() {
    return boxSelectIndex ?? -1;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  bool? get boxChecked => _boxMap['checked'] as bool?;

  @override
  set boxChecked(bool? value) => _boxMap['checked'] = value;

  @override
  bool isBoxChecked() {
    return boxChecked ?? false;
  }

  @override
  set boxChildren(List<T>? value) {
    //此处什么都不用做
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  List<T>? get boxChildren => null;
}
