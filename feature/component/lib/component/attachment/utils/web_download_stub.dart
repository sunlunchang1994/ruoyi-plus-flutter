/// Web下载的stub实现（用于非Web平台）
/// 
/// 这个文件在非Web平台（Android、iOS、Desktop）上使用
void downloadFileOnWeb(List<int> bytes, String fileName) {
  // 非Web平台不执行任何操作
  throw UnsupportedError('Web下载仅在Web平台上支持');
}

