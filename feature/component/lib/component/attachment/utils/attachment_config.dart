import 'package:boxes_flutter/flutter/slc/common/text_util.dart';

/// @author sunlunchang
/// 附件配置类，辅助处理网络文件，如补齐ip、端口等
class AttachmentConfig {

  AttachmentConfig._privateConstructor();

  static final AttachmentConfig _instance =
  AttachmentConfig._privateConstructor();

  factory AttachmentConfig() {
    return _instance;
  }


}
