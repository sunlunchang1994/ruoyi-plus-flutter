import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/request_utils.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';
import 'package:boxes_flutter/flutter/slc/adapter/page_model.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:fast/fast/retorfit/retorfit_expand.dart';
import 'package:retrofit/retrofit.dart';

import '../entity/{{feature}}.dart';

part '{{feature}}_api.g.dart';

@RestApi()
abstract class {{Feature}}Api {
  factory {{Feature}}Api({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _{{Feature}}Api(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  @GET('/{{feature}}/list')
  Future<ResultPageModel> list(
    @Queries() Map<String, dynamic>? queryParams,
    @CancelRequest() CancelToken cancelToken,
  );

  @GET('/{{feature}}/{id}')
  Future<ResultEntity> getInfo(
    @Path('id') String id,
    @CancelRequest() CancelToken cancelToken,
  );

  @POST('/{{feature}}')
  Future<ResultEntity> add(@Body() {{Entity}} data, @CancelRequest() CancelToken cancelToken);

  @PUT('/{{feature}}')
  Future<ResultEntity> edit(@Body() {{Entity}} data, @CancelRequest() CancelToken cancelToken);

  @DELETE('/{{feature}}/{ids}')
  Future<ResultEntity> delete(@Path('ids') String ids, @CancelRequest() CancelToken cancelToken);
}

class {{Feature}}Repository {
  static final {{Feature}}Api _api = {{Feature}}Api();

  static Future<IntensifyEntity<PageModel<{{Entity}}>>> list(
    int offset,
    int size,
    {{Entity}}? search,
    CancelToken cancelToken,
  ) {
    return _api
        .list(RequestUtils.toPageQuery(search?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toPage2Intensify(offset, size, createData: (data) => {{Entity}}.fromJson(data));
    });
  }

  static Future<IntensifyEntity<{{Entity}}>> getInfo(BigInt id, CancelToken cancelToken) {
    return _api.getInfo(id.toString(), cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (entity) => {{Entity}}.fromJson(entity.data));
    });
  }

  static Future<IntensifyEntity<dynamic>> submit({{Entity}} body, CancelToken cancelToken) {
    final resultFuture = body.id == null ? _api.add(body, cancelToken) : _api.edit(body, cancelToken);
    return resultFuture.successMap2Single((event) => event.toIntensify());
  }

  static Future<IntensifyEntity<dynamic>> delete(
    CancelToken cancelToken, {
    BigInt? id,
    List<BigInt>? ids,
  }) {
    assert(id != null && ids == null || id == null && ids != null);
    ids ??= [id!];
    return _api.delete(ids.map((e) => e.toString()).join(TextUtil.comma), cancelToken)
        .successMap2Single((event) => event.toIntensify());
  }
}
