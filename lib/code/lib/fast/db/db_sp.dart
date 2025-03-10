import 'package:flutter_slc_boxes/flutter/slc/common/sp_cache_util.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/db/data_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

///基于SharedPreferences的数据持久化
///@author slc
class DbSp extends DataPersistence<DbSp> {
  final String spName;
  late SharedPreferencesWithCache spUtils;

  DbSp(this.spName) {
    spUtils = SpCacheUtil.getSp()!;
  }

  String _formatKey(String key) {
    return "$spName:$key";
  }

  @override
  bool? getBoolInternal(String key, bool? defValue, bool autoSaveDefValue) {
    bool? value = spUtils.getBool(_formatKey(key));
    if (autoSaveDefValue && value == null && defValue != null) {
      spUtils.setBool(_formatKey(key), defValue);
    }
    value ??= defValue;
    return value;
  }

  @override
  double? getDoubleInternal(String key, double? defValue, bool autoSaveDefValue) {
    double? value = spUtils.getDouble(_formatKey(key));
    if (autoSaveDefValue && value == null && defValue != null) {
      spUtils.setDouble(_formatKey(key), defValue);
    }
    value ??= defValue;
    return value;
  }

  @override
  int? getIntInternal(String key, int? defValue, bool autoSaveDefValue) {
    int? value = spUtils.getInt(_formatKey(key));
    if (autoSaveDefValue && value == null && defValue != null) {
      spUtils.setInt(_formatKey(key), defValue);
    }
    value ??= defValue;
    return value;
  }

  @override
  String? getStringInternal(String key, String? defValue, bool autoSaveDefValue) {
    String? value = spUtils.getString(_formatKey(key));
    if (autoSaveDefValue && value == null && defValue != null) {
      spUtils.setString(_formatKey(key), defValue);
    }
    value ??= defValue;
    return value;
  }

  @override
  List<String>? getStringListInternal(String key, List<String>? defValue, bool autoSaveDefValue) {
    List<String>? value = spUtils.getStringList(_formatKey(key));
    if (autoSaveDefValue && value == null && defValue != null) {
      spUtils.setStringList(_formatKey(key), defValue);
    }
    value ??= defValue;
    return value;
  }

  @override
  bool containsKey(String key) {
    return spUtils.containsKey(_formatKey(key));
  }

  @override
  DataPersistence<dynamic> putValue(String key, dynamic value, {bool submit = true}) {
    if (value == null) {
      remove(key);
    }
    DataPersistence.checkValueType(value);
    if (value is int) {
      spUtils.setInt(_formatKey(key), value);
      return this;
    }
    if (value is double) {
      spUtils.setDouble(_formatKey(key), value);
      return this;
    }
    if (value is bool) {
      spUtils.setBool(_formatKey(key), value);
      return this;
    }
    if (value is String) {
      spUtils.setString(_formatKey(key), value);
      return this;
    }
    if (value is List<String>) {
      spUtils.setStringList(_formatKey(key), value);
      return this;
    }
    return this;
  }

  @override
  void remove(String key){
    spUtils.remove(_formatKey(key));
  }
  
  @override
  void clear() {
    Set<String> keys = spUtils.keys;
    for (var item in keys) {
      if (item.startsWith("$spName:")) {
        spUtils.remove(item);
      }
    }
    return;
  }
}
