import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// @author sunlunchang
class AttachmentUtils {
  ///构建文件保存路径
  static Future<String?> buildSaveFileDir() async {
    if (kIsWeb) {
      //web平台暂时先返回空
      return null;
    } else if (Platform.isAndroid || Platform.isIOS) {
      String? selectPath = (await FilePicker.platform.getDirectoryPath());
      if (selectPath == null) {
        return null;
      }
      //允许为空，为空表示放弃选择
      return selectPath;
      // 获取下载目录  下面获取的是app内置文件
      /*final directory = await getDownloadsDirectory();
      if (directory == null) {
        return null;
      }
      final filePath = '${directory.path}${Platform.pathSeparator}$fileName';
      return filePath;*/
    } else {
      //win、mac、linux
      // 弹出文件保存对话框
      String? selectPath = (await FilePicker.platform.getDirectoryPath());
      if (selectPath == null) {
        return null;
      }
      //允许为空，为空表示放弃选择
      return selectPath;
    }
  }

}
