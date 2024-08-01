import 'package:flutter/services.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';

class DecimalTextInputFormatter extends FilteringTextInputFormatter {
  DecimalTextInputFormatter() : super(RegExp(r'[0-9.]'), allow: true);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final textEditingValue = super.formatEditUpdate(oldValue, newValue);
    if (TextUtil.isEmpty(textEditingValue.text)) {
      return textEditingValue;
    }
    double? value = double.tryParse(textEditingValue.text);
    return value == null ? oldValue : newValue;
  }
}
