// 将 SelectBox 改为可混入的 Mixin
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:json_annotation/json_annotation.dart';

mixin AppSelectBoxMixin<T> implements ISelectBox<T> {
  // 使用 late 延迟初始化，由混入类负责初始化

  @JsonKey(includeFromJson: false, includeToJson: false)
  final Map<String, dynamic> _map = {};

  // 初始化方法（由混入类调用）
  void initSelectBox({int index = -1, bool checked = false}) {
    _map.addAll({
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
    //此处什么都不用做
  }

  //此处可以是空是为了防止json序列化报错
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int? get boxSelectIndex => _map['selectIndex'] as int? ?? -1;

  int getBoxSelectIndex() {
    //因为上面代码表示selectIndex不会为空，故有此方法
    return boxSelectIndex!;
  }

  @override
  set boxSelectIndex(int? value) => _map['selectIndex'] = value;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  bool get boxChecked => _map['checked'] as bool? ?? false;

  bool isBoxChecked() {
    //因为上面代码表示selectIndex不会为空，故有此方法
    return boxChecked!;
  }

  @override
  set boxChecked(bool value) => _map['checked'] = value;
}
