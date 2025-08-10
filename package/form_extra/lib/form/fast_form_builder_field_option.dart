import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

///
/// Value Label选项
/// @author slc
///
class VLFormBuilderFieldOption<T> extends FormBuilderFieldOption<OptionVL<T>> {
  const VLFormBuilderFieldOption({
    super.key,
    required super.value,
    super.child,
  });

  @override
  Widget build(BuildContext context) {
    return child ?? Text(value.label);
  }
}

class OptionVL<T> {
  final T value;
  final String label;

  OptionVL(this.value, this.label);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptionVL &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
