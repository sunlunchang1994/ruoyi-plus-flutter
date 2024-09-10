import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';

class AttachmentConfig {
  static const String _separate = "/";

  String? _downloadIpPort;
  String? _downloadApiPart;

  AttachmentConfig._privateConstructor();

  static final AttachmentConfig _instance =
  AttachmentConfig._privateConstructor();

  factory AttachmentConfig() {
    return _instance;
  }

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
}
