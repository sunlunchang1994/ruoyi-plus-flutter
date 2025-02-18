import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormOperate {
  final GlobalKey<FormBuilderState> formKey;

  FormOperate(this.formKey) {}

  void reset() {
    formKey.currentState?.reset();
  }

  //重置
  void resetField(String name, {bool reset2Null = false}) {
    formKey.currentState?.fields[name]?.reset();
  }

  //重置
  void clearAll() {
    formKey.currentState?.fields.forEach((key, value) {
      clearField(key);
    });
  }

  //重置
  void clearField(String name) {
    patchField(name, null);
  }

  //插入数据
  void patchField(String name, dynamic value, {bool populateForm = true}) {
    //formKey.currentState?.fields[name]?.setValue(value, populateForm: populateForm);
    formKey.currentState?.patchValue({name: value});
  }
}
