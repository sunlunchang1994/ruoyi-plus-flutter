import '../../../../../lib/fast/db/dp_manager.dart';

class AttachmentConfig extends DpManager {
  static const String SP_NAME = "attachment_config";

  AttachmentConfig._privateConstructor() : super(SP_NAME);

  static final AttachmentConfig _instance = AttachmentConfig._privateConstructor();

  factory AttachmentConfig() {
    return _instance;
  }

  String? getPathByKey(String key) {
    return getDp().getString(key,defValue: null);
  }

  void setPathByKey(String key, String path) {
    getDp().putValue(key, path);
  }

  String? getDownloadPath() {
    return getPathByKey("download");
  }

  void setDownloadPath(String path) {
    setPathByKey('download', path);
  }

  void clearDownloadPath() {
    getDp().remove("download");
  }
}
