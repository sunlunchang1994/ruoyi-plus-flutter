import 'package:flutter_slc_boxes/flutter/slc/code/value_wrapper.dart';
import 'package:provider/provider.dart';

///@author slc

///
/// 不等于
///
class NqSelector0<A> extends Selector0<A> {
  /// {@macro provider.selector}
  NqSelector0({
    super.key,
    required super.builder,
    required super.selector,
    super.child,
  }) : super(shouldRebuild: (oldVal, newVal) {
          return oldVal != newVal;
        });
}

///不等于且不为空
class NqNullSelector0<A> extends Selector0<A> {
  NqNullSelector0({
    super.key,
    required super.builder,
    required super.selector,
    super.child,
  }) : super(shouldRebuild: (oldVal, newVal) {
          return oldVal != newVal && (oldVal == null || newVal == null);
        });
}

///
/// 不等于
///
class NqSelector<A, S> extends Selector<A, S> {
  /// {@macro provider.selector}
  NqSelector({
    super.key,
    required super.builder,
    required super.selector,
    super.child,
  }) : super(shouldRebuild: (oldVal, newVal) {
          return oldVal != newVal;
        });
}

///不等于且不为空
class NqNullSelector<A, S> extends Selector<A, S> {
  NqNullSelector({
    super.key,
    required super.builder,
    required super.selector,
    super.child,
  }) : super(shouldRebuild: (oldVal, newVal) {
          return oldVal != newVal && (oldVal == null || newVal == null);
        });
}