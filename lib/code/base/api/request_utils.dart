class RequestUtils {
  //转成分页查询
  static Map<String, dynamic> toPageQuery(
      Map<String, dynamic>? queryParams, int offset, int size) {
    queryParams ??= <String, dynamic>{};
    queryParams["pageNum"] = offset;
    queryParams["pageSize"] = size;
    queryParams.removeWhere((k, v) => v == null);
    return queryParams;
  }
}
