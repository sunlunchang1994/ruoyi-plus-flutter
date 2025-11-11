import 'dart:io';

import 'package:boxes_flutter/flutter/slc/common/slc_file_util.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:component/component/attachment/entity/progress.dart';
import 'package:component/component/attachment/repository/local/attachment_config.dart';
import 'package:fast/fast/permission/permission_compat.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fast/gen/fast_l10n.dart';
import 'package:base/gen/base_l10n.dart' as base_l10n;
import 'package:component/gen/component_l10n.dart';
import 'package:component/component/attachment/utils/web_download_stub.dart'
    if (dart.library.html) 'package:component/component/attachment/utils/web_download_impl.dart';

/// @author sunlunchang
/// 附件工具类
class AttachmentUtils {
  ///构建文件保存路径
  static Future<String?> buildSaveFileDir() async {
    if (kIsWeb) {
      // Web端不需要选择目录，直接返回默认下载路径标识
      return 'web_downloads';
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

  ///TODO 下面方法未同步到基础框架，业务代码也需要统计基础框架
  /// 通用文件下载方法
  ///
  /// [fileName] 要保存的文件名
  /// [downloadFunc] 下载函数，返回文件的字节数据或下载结果
  /// [onProgress] 下载进度回调（可选）
  /// [onPermissionDenied] 权限被拒绝回调（可选）
  /// [onDirectoryNotSelected] 未选择目录回调（可选）
  /// [onFileExists] 文件已存在回调（可选），返回true表示继续下载覆盖，false表示取消
  /// [overrideIfExists] 文件已存在时是否直接覆盖（可选），默认为false
  ///
  /// 返回下载完成的文件路径，失败返回null
  static Future<String?> downloadFile({
    required String fileName,
    required Future<dynamic> Function(String savePath) downloadFunc,
    void Function(Progress progress)? onProgress,
    void Function()? onPermissionDenied,
    void Function()? onDirectoryNotSelected,
    Future<bool> Function(String filePath)? onFileExists,
    bool overrideIfExists = false,
  }) async {
    // Web端特殊处理
    if (kIsWeb) {
      return _downloadFileForWeb(
        fileName: fileName,
        downloadFunc: downloadFunc,
        onProgress: onProgress,
      );
    }

    // 1. 请求存储权限
    final status = await PermissionCompat.requestStorage;
    if (!status.isGranted) {
      onPermissionDenied?.call();
      return null;
    }

    // 2. 获取下载目录
    String? fileDir = AttachmentConfig().getDownloadPath() ?? await buildSaveFileDir();
    if (fileDir == null) {
      if (Platform.isAndroid || Platform.isIOS) {
        onDirectoryNotSelected?.call();
      }
      return null;
    }

    // 3. 保存下载目录配置
    AttachmentConfig().setDownloadPath(fileDir);

    // 4. 构建完整文件路径
    String filePath = "${TextUtil.addSuffixIfNot(fileDir, Platform.pathSeparator)}$fileName";

    // 5. 检查文件是否已存在
    if (SlcFileUtil.isFileExistsFromPath(filePath)) {
      if (overrideIfExists) {
        // 直接覆盖，继续下载
      } else if (onFileExists != null) {
        bool shouldContinue = await onFileExists(filePath);
        if (!shouldContinue) {
          return null;
        }
      } else {
        // 默认行为：文件存在则直接返回路径
        return filePath;
      }
    }

    // 6. 执行下载
    try {
      onProgress?.call(Progress(status: DownloadStatus.waiting));

      dynamic result = await downloadFunc(filePath);

      // 如果返回的是字节数组，则写入文件
      if (result is List<int>) {
        final file = File(filePath);
        await file.writeAsBytes(result);
      }
      // 如果返回的是Progress对象，使用其文件路径
      else if (result is Progress) {
        filePath = result.filePath ?? filePath;
      }

      onProgress?.call(Progress(filePath: filePath, status: DownloadStatus.finish));
      return filePath;
    } catch (e) {
      onProgress?.call(Progress(status: DownloadStatus.error, error: e));
      rethrow;
    }
  }

  /// Web端文件下载的内部实现
  static Future<String?> _downloadFileForWeb({
    required String fileName,
    required Future<dynamic> Function(String savePath) downloadFunc,
    void Function(Progress progress)? onProgress,
  }) async {
    try {
      onProgress?.call(Progress(status: DownloadStatus.waiting));

      // Web端传入虚拟路径
      dynamic result = await downloadFunc('web://$fileName');

      List<int> bytes;
      if (result is List<int>) {
        bytes = result;
      } else if (result is Progress && result.bytes != null) {
        bytes = result.bytes!;
      } else {
        throw Exception('Web端下载失败：返回的数据格式不正确');
      }

      // 触发浏览器下载（使用条件导入的实现）
      downloadFileOnWeb(bytes, fileName);

      onProgress?.call(Progress(filePath: fileName, status: DownloadStatus.finish));
      return fileName;
    } catch (e) {
      onProgress?.call(Progress(status: DownloadStatus.error, error: e));
      rethrow;
    }
  }

  /// 简化版文件下载方法（下载字节数组）
  ///
  /// [fileName] 要保存的文件名
  /// [downloadBytesFunc] 下载函数，返回文件的字节数据
  /// [onPermissionDenied] 权限被拒绝回调（可选）
  /// [onDirectoryNotSelected] 未选择目录回调（可选）
  /// [onFileExists] 文件已存在回调（可选）
  /// [overrideIfExists] 文件已存在时是否直接覆盖（可选），默认为false
  ///
  /// 返回下载完成的文件路径，失败返回null
  static Future<String?> downloadFileBytes({
    required String fileName,
    required Future<List<int>> Function() downloadBytesFunc,
    void Function()? onPermissionDenied,
    void Function()? onDirectoryNotSelected,
    void Function()? onFileExists,
    bool overrideIfExists = false,
  }) async {
    return downloadFile(
      fileName: fileName,
      downloadFunc: (savePath) async {
        return await downloadBytesFunc();
      },
      onPermissionDenied: onPermissionDenied,
      onDirectoryNotSelected: onDirectoryNotSelected,
      onFileExists: onFileExists != null
          ? (filePath) async {
              onFileExists();
              return false; // 文件存在时取消下载
            }
          : null,
      overrideIfExists: overrideIfExists,
    );
  }

  /// 显示文件保存成功弹框
  ///
  /// [context] 上下文
  /// [filePath] 文件保存路径
  /// [fileName] 文件名（可选，用于显示）
  static Future<void> showFileSavedDialog(
    BuildContext context,
    String filePath, {
    String? fileName,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(FastS.current.label_success_saved),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(kIsWeb
                  ? TextUtil.format(
                      ComponentS.current.comp_label_file_downloaded, [fileName ?? filePath])
                  : TextUtil.format(
                      base_l10n.BaseS.current.ab_toast_storage_file_saved_2, [filePath])),
              if (kIsWeb) ...[
                const SizedBox(height: 8),
                Text(
                  ComponentS.current.comp_label_check_browser_downloads,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(FastS.current.action_close),
            ),
            if (!kIsWeb)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  OpenFile.open(filePath);
                },
                child: Text(base_l10n.BaseS.current.ab_toast_storage_file_open_fast),
              ),
          ],
        );
      },
    );
  }
}
