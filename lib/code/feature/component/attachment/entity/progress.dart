// 使用枚举替代 int 类型状态，提升类型安全性和可读性
import 'dart:io';

import 'package:flutter_slc_boxes/flutter/slc/common/slc_file_util.dart';

///@author slc
enum DownloadStatus {
  none, // 无状态
  waiting, // 等待
  loading, // 下载中
  pause, // 暂停
  error, // 错误
  finish, // 完成
}

class Progress {
  final String? tag; // 下载的唯一标识符
  final String? url; // 资源 URL
  final String? _folder; // 存储目录
  final String? _fileName; // 文件名
  final String? _filePath; // 文件名
  final int? _fraction; // 进度百分比 (0-100)
  final int totalSize; // 总字节数
  final int currentSize; // 已下载字节数
  final int speedBytesPerSecond; // 下载速度 (字节/秒)
  final DownloadStatus status; // 当前状态
  final Object? error; // 错误信息 (类型安全替代 dynamic)
  final Map<String, dynamic> extras; // 扩展数据 (替代 extra1/extra2)

  // 计算属性：文件完整路径（按需生成，避免冗余存储）
  String? get filePath {
    if (_filePath != null) {
      return _filePath;
    }
    if (_folder != null && _fileName != null) {
      return '$_folder${Platform.pathSeparator}$_fileName';
    }
    return null;
  }

  String? get folder {
    if (_folder != null) {
      return _folder;
    }
    if (filePath != null) {
      return SlcFileUtil.getDirName(filePath!);
    }
    return null;
  }

  String? get fileName {
    if (_fileName != null) {
      return _fileName;
    }
    if (filePath != null) {
      return SlcFileUtil.getFileName(filePath!);
    }
    return null;
  }

  // 计算属性：进度百分比 (0-100)
  int get fraction {
    if (_fraction != null) return _fraction; // 如果显式提供了进度，直接返回
    return (fractionFloat * 100).round();
  }

  double get fractionFloat {
    if (totalSize <= 0) return 0; // 避免除以零
    return currentSize / totalSize;
  }

  // 主构造器
  Progress({
    this.tag,
    this.url,
    String? folder,
    String? fileName,
    String? filePath,
    this.totalSize = 0,
    this.currentSize = 0,
    this.speedBytesPerSecond = 0, // 可选的显式速度
    this.status = DownloadStatus.none,
    this.error,
    Map<String, dynamic>? extras,
    int? fraction, // 可选的显式进度
  })  : _folder = folder,
        _fileName = fileName,
        _filePath = filePath,
        _fraction = fraction,
        extras = extras ?? {},
        assert(totalSize >= 0, '总大小不能为负'),
        assert(currentSize >= 0, '当前大小不能为负'),
        assert(fraction == null || (fraction >= 0 && fraction <= 100), '进度必须在 0-100 之间'),
        assert(speedBytesPerSecond >= 0, '速度不能为负');

  // 便捷构造器：快速创建错误状态实例
  factory Progress.error({
    required String tag,
    required Object error,
    String? url,
    String? folder,
    String? fileName,
    int totalSize = 0,
    int currentSize = 0,
  }) =>
      Progress(
        tag: tag,
        error: error,
        url: url,
        folder: folder,
        fileName: fileName,
        totalSize: totalSize,
        currentSize: currentSize,
        status: DownloadStatus.error,
      );
}
