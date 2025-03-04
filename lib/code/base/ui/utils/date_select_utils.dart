import 'package:flutter/material.dart';

///@author sunlunchang
///日期选择工具类
class DateSelectUtils {
  static Future<DateTime> showDefaultYearPickerByStr(BuildContext context,
      {String? dateStr}) async {
    return showDefaultYearPicker(context,
        initialDate: DateTime.parse(dateStr ?? DateTime.now().toString()));
  }

  static Future<DateTime> showDefaultDateTimePicker(BuildContext context,
      {DateTime? initialDate,
        DateTime? firstDate,
        DateTime? lastDate,
        TimeOfDay? initialTime}) async {
    DateTime dateTime = await showDefaultYearPicker(context,
        initialDate: initialDate, firstDate: firstDate, lastDate: lastDate);
    TimeOfDay timeOfDay =
    await showDefaultTime(context, initialTime: initialTime);
    dateTime =
        dateTime.copyWith(hour: timeOfDay.hour, minute: timeOfDay.minute);
    return dateTime;
  }

  static Future<DateTime> showDefaultYearPicker(BuildContext context,
      {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    initialDate ??= DateTime.now();
    firstDate ??= DateTime(2000);
    lastDate ??= DateTime(2028);
    final DateTime? dateTime = await showDatePicker(
        locale: const Locale('zh'),
        context: context,
        //定义控件打开时默认选择日期
        initialDate: initialDate,
        //定义控件最早可以选择的日期
        firstDate: firstDate,
        //定义控件最晚可以选择的日期
        lastDate: lastDate);
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
