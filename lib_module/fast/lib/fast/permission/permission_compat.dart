import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// @author sunlunchang
/// 权限兼容类
class PermissionCompat {
  static Future<PermissionStatus> get requestStorage async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status;
    }
    return PermissionStatus.granted;
  }
}
