import 'package:flutter/material.dart';

class DateSelectUtils {
  static Future<DateTime> showDefaultYearPickerByStr(BuildContext context,
      {String? dateStr}) {
    return showDefaultYearPicker(context,
        initialDate: DateTime.parse(dateStr ?? DateTime.now().toString()));
  }

  static Future<DateTime> showDefaultYearPicker(BuildContext context,
      {DateTime? initialDate}) async {
    initialDate ??= DateTime.now();
    final DateTime? dateTime = await showDatePicker(
        locale: const Locale('zh'),
        context: context,
        //定义控件打开时默认选择日期
        initialDate: initialDate,
        //定义控件最早可以选择的日期
        firstDate: DateTime(2000),
        //定义控件最晚可以选择的日期
        lastDate: DateTime(2028));
    if (dateTime == null) {
      throw "dateTime 为空";
    }
    return dateTime;
  }

  static Future<TimeOfDay> showDefaultTime(BuildContext context,
      {TimeOfDay? initialTime}) async {
    initialTime ??= TimeOfDay.now();
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        //定义控件打开时默认选择日期
        initialTime: initialTime);
    if (timeOfDay == null) {
      throw "timeOfDay 为空";
    }
    return timeOfDay;
  }
}
