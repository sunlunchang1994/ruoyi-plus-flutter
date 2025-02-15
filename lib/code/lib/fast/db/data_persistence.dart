///数据持久化接口
///@author slc
abstract class DataPersistence<T extends DataPersistence<T>> {
  int getInt(String key, {int? defValue, bool? autoSaveDefValue}) {
    autoSaveDefValue ??= defValue != null;
    defValue ??= -1;
    return getIntInternal(key, defValue, autoSaveDefValue);
  }

  int getIntInternal(String key, int defValue, bool autoSaveDefValue);

  double getDouble(String key, {double? defValue, bool? autoSaveDefValue}) {
    autoSaveDefValue ??= defValue != null;
    defValue ??= -1.0;
    return getDoubleInternal(key, defValue, autoSaveDefValue);
  }

  double getDoubleInternal(String key, double defValue, bool autoSaveDefValue);

  bool getBool(String key, {bool? defValue, bool? autoSaveDefValue}) {
    autoSaveDefValue ??= defValue != null;
    defValue ??= false;
    return getBoolInternal(key, defValue, autoSaveDefValue);
  }

  bool getBoolInternal(String key, bool defValue, bool autoSaveDefValue);

  String getString(String key, {String? defValue, bool? autoSaveDefValue}) {
    autoSaveDefValue ??= defValue != null;
    defValue ??= '';
    return getStringInternal(key, defValue, autoSaveDefValue);
  }

  String getStringInternal(String key, String defValue, bool autoSaveDefValue);

  List<String>? getStringList(String key, {List<String>? defValue, bool? autoSaveDefValue}) {
    autoSaveDefValue ??= defValue != null;
    return getStringListInternal(key, defValue, autoSaveDefValue);
  }

  List<String>? getStringListInternal(String key, List<String>? defValue, bool autoSaveDefValue);

  bool containsKey(String key);

  DataPersistence<dynamic> putValue(String key, dynamic value, {bool submit = true});

  DataPersistence<dynamic> putIfAbsent(String key, dynamic value, {bool submit = true}) {
    final contains = containsKey(key);
    if (!contains) {
      putValue(key, value, submit: submit);
    }
    return this;
  }

  void clear();

  static int? toInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static int? toLong(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? toFloat(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static bool toBoolean(dynamic value, [bool defValue = false]) {
    if (value == null) return defValue;
    return value == true;
  }

  static bool checkValueType(dynamic value) {
    if (value == null) return true;
    if (value is int || value is double || value is bool || value is String || value is List<String>) {
      return true;
    }
    throw Exception('不允许的类型');
  }
}
