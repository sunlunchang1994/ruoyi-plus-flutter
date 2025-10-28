/// Web下载的实际实现（仅用于Web平台）
/// 
/// 这个文件只在Web平台上使用
import 'dart:html' as html;
import 'dart:typed_data';

void downloadFileOnWeb(List<int> bytes, String fileName) {
  // 根据文件扩展名确定MIME类型
  final mimeType = _getMimeType(fileName);
  
  // 将List<int>转换为Uint8List
  final uint8List = Uint8List.fromList(bytes);
  
  // 创建Blob对象，指定正确的MIME类型
  final blob = html.Blob([uint8List], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  
  // 创建下载链接
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..style.display = 'none';
  
  // 添加到DOM并触发点击
  html.document.body?.append(anchor);
  anchor.click();
  
  // 清理
  anchor.remove();
  html.Url.revokeObjectUrl(url);
}

/// 根据文件扩展名获取MIME类型
String _getMimeType(String fileName) {
  final extension = fileName.toLowerCase().split('.').last;
  
  switch (extension) {
    // Excel文件
    case 'xlsx':
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    case 'xls':
      return 'application/vnd.ms-excel';
    
    // Word文件
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    case 'doc':
      return 'application/msword';
    
    // PDF文件
    case 'pdf':
      return 'application/pdf';
    
    // 图片文件
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'webp':
      return 'image/webp';
    
    // 文本文件
    case 'txt':
      return 'text/plain';
    case 'csv':
      return 'text/csv';
    case 'json':
      return 'application/json';
    case 'xml':
      return 'application/xml';
    
    // 压缩文件
    case 'zip':
      return 'application/zip';
    case 'rar':
      return 'application/x-rar-compressed';
    case '7z':
      return 'application/x-7z-compressed';
    
    // 视频文件
    case 'mp4':
      return 'video/mp4';
    case 'avi':
      return 'video/x-msvideo';
    case 'mov':
      return 'video/quicktime';
    
    // 音频文件
    case 'mp3':
      return 'audio/mpeg';
    case 'wav':
      return 'audio/wav';
    
    // 默认二进制流
    default:
      return 'application/octet-stream';
  }
}

