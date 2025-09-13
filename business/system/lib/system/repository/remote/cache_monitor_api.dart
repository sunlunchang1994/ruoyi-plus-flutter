import 'package:dio/dio.dart' hide Headers;
import 'package:boxes_flutter/flutter/slc/common/slc_color_util.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';

import 'package:base/base/api/result_entity.dart';
import 'package:system/system/entity/redis_cache_info.dart';

part 'cache_monitor_api.g.dart';

@RestApi()
abstract class CacheMonitorApi {
  factory CacheMonitorApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _CacheMonitorApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取缓存监控列表
  @GET("/monitor/cache")
  Future<ResultEntity> getInfo(@CancelRequest() CancelToken cancelToken);
}

class CacheMonitorRepository {
  //实例
  static final CacheMonitorApi _cacheMonitorApi = CacheMonitorApi();

  ///获取缓存监控列表
  static Future<IntensifyEntity<RedisCacheInfo>> getInfo(CancelToken cancelToken) {
    return _cacheMonitorApi
        .getInfo(cancelToken)
        .successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        RedisCacheInfo redisCacheInfo = RedisCacheInfo.fromJson(resultEntity.data);
        //填充命令的颜色
        int count = redisCacheInfo.commandStats?.length ?? 0;
        if (count != 0) {
          List<int> colors =
              SlcColorUtil.getColorByAverage(count, colorArray: SlcColorUtil.COLOR_ARRAY_MD);
          for (int i = 0; i < count; i++) {
            redisCacheInfo.commandStats![i].color = colors[i];
          }
        }
        return redisCacheInfo;
      });
    });
  }
}
