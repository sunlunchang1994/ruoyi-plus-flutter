import 'package:permission_handler/permission_handler.dart';

class PermissionCompat {
  //仅android执行
  static Future<PermissionStatus> get requestStorage async {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status;
  }
}
