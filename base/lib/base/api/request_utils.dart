/// @author sunlunchang
class RequestUtils {
  //转成分页查询
  static Map<String, dynamic> toPageQuery(Map<String, dynamic>? queryParams, int offset, int size) {
    queryParams ??= <String, dynamic>{};
    queryParams["pageNum"] = offset;
    queryParams["pageSize"] = size;
    queryParams.removeWhere((k, v) => v == null);
    return compatibleJson(queryParams);
  }

  static Map<String, dynamic> compatibleJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value is BigInt) {
        json[key] = value.toString();
      } else if (value is List<BigInt>) {
        json[key] = value.map((e) => e.toString()).toList();
      }
    });
    return json;
  }
}

class RequestBodyWrapper {
  Map<String, dynamic>? data;

  RequestBodyWrapper(this.data);

  Map<String, dynamic> toJson() {
    if (data == null) {
      return {};
    }
    return RequestUtils.compatibleJson(data!);
  }
}
