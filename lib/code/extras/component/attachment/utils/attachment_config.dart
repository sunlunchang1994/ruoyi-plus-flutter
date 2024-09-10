
class AttachmentConfig {

  String? _downloadIpPort;
  String? _downloadApiPart;

  AttachmentConfig._privateConstructor();

  static final AttachmentConfig _instance = AttachmentConfig._privateConstructor();

  factory AttachmentConfig() {
    return _instance;
  }

  void setDownloadIpPort(String downloadIpPort) {
    this._downloadIpPort = downloadIpPort;
  }

  String? getDownloadIpPort() {
    return _downloadIpPort;
  }

  void setDownloadApiPart(String downloadApiPart) {
    this._downloadApiPart = downloadApiPart;
  }

  String? getDownloadApiPart() {
    return _downloadApiPart;
  }

  String getDownloadApiPartNotNull() {
    if (getDownloadApiPart()?.isEmpty??false) {
      return '';
    }
    return getDownloadApiPart()!;
  }

  String getDownloadRequestUrl() {
    return (getDownloadIpPort()??"") + getDownloadApiPartNotNull();
  }

  /// 根据文件相对路径获取文件
  ///
  /// @param relativePath
  /// @return
  String getDownloadPathByRelative(String relativePath) {
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