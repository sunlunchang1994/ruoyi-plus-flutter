import 'package:db_base/db_base/dp_manager.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';

/// @author sunlunchang
/// 附件配置
class AttachmentConfig extends DpManager {
  static const String SP_NAME = "attachment_config";

  static const String _separate = "/";

  AttachmentConfig._privateConstructor() : super(SP_NAME);

  static final AttachmentConfig _instance = AttachmentConfig._privateConstructor();

  factory AttachmentConfig() {
    return _instance;
  }

  //文件下载相关
  String? _downloadIpPort;
  String? _downloadApiPart;

  void setDownloadIpPort(String downloadIpPort) {
    this._downloadIpPort = downloadIpPort;
  }

  String? getDownloadIpPort() {
    return _downloadIpPort;
  }

  String getDownloadIpPortNotNull() {
    if (getDownloadIpPort()?.isEmpty ?? false) {
      return '';
    }
    return getDownloadIpPort()!;
  }

  void setDownloadApiPart(String downloadApiPart) {
    this._downloadApiPart = downloadApiPart;
  }

  String? getDownloadApiPart() {
    return _downloadApiPart;
  }

  String getDownloadApiPartNotNull() {
    if (getDownloadApiPart()?.isEmpty ?? false) {
      return '';
    }
    return getDownloadApiPart()!;
  }

  String getDownloadRequestUrl() {
    String downloadIpPort = getDownloadIpPortNotNull();
    downloadIpPort = TextUtil.addSuffixIfNot(downloadIpPort, _separate);
    String downloadApiPart = getDownloadApiPartNotNull();
    downloadApiPart = TextUtil.removePrefix(downloadApiPart, _separate);
    return downloadIpPort + downloadApiPart;
  }

  /// 根据文件相对路径获取文件
  ///
  /// @param relativePath
  /// @return
  String getDownloadPathByRelative(String relativePath) {
    relativePath = TextUtil.removePrefix(relativePath, _separate);
    String downloadPath = getDownloadRequestUrl() + relativePath;
    return downloadPath;
  }

  String explicitDownloadPathAuto(String downloadPath) {
    if (downloadPath.startsWith('http') || downloadPath.startsWith('https')) {
      return downloadPath;
    }
    return getDownloadPathByRelative(downloadPath);
  }

  //文件存储位置相关

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
