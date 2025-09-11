import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/*extension FormFieldStateHelper on FormBuilderFieldState {
  static FormFieldState? findFormFieldState<T extends FormFieldState<dynamic>>(BuildContext context) =>
      context.findAncestorStateOfType<T>();

  //清除某个
  void clearField({bool clear2Empty = true}) {
    didChange(clear2Empty ? '' : null);
  }
}*/

extension FormBuilderStateHelper on FormBuilderState {
  //重置某个
  void resetField(String name) {
    fields[name]?.reset();
  }

  //清除所有
  void clearAll() {
    fields.forEach((key, value) {
      clearField(key);
    });
  }

  //清除某个
  void clearField(String name) {
    patchField(name, null);
  }

  //插入数据
  void patchField(String name, dynamic value) {
    //formKey.currentState?.fields[name]?.setValue(value, populateForm: populateForm);
    patchValue({name: value});
  }
}

///为方便配置Provider操作表单
class FormOperateWithProvider {
  late GlobalKey<FormBuilderState> _formKey;

  GlobalKey<FormBuilderState> get formKey => _formKey;

  FormOperateWithProvider({GlobalKey<FormBuilderState>? formKey}) {
    _formKey = formKey ?? GlobalKey<FormBuilderState>();
  }

  FormBuilderState? get formBuilderState => _formKey.currentState;

  //重置所有
  void reset() {
    formKey.currentState?.reset();
  }

  //重置某个
  void resetField(String name) {
    formKey.currentState?.resetField(name);
  }

  //清除所有
  void clearAll() {
    formKey.currentState?.clearAll();
  }

  //清除某个
  void clearField(String name) {
    formKey.currentState?.clearField(name);
  }

  //插入数据
  void patchField(String name, dynamic value) {
    formKey.currentState?.patchField(name,value);
  }
}
