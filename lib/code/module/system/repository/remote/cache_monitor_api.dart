import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/material.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/slc_color_util.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/redis_cache_info.dart';

import '../../../../base/api/result_entity.dart';
import '../../../../feature/bizapi/system/entity/sys_dict_data.dart';

part 'cache_monitor_api.g.dart';

@RestApi()
abstract class CacheMonitorApiClient {
  factory CacheMonitorApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _CacheMonitorApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取缓存监控列表
  @GET("/monitor/cache")
  Future<ResultEntity> getInfo(@CancelRequest() CancelToken cancelToken);
}

class CacheMonitorRepository {
  //实例
  static final CacheMonitorApiClient _cacheMonitorApiClient = CacheMonitorApiClient();

  ///获取缓存监控列表
  static Future<IntensifyEntity<RedisCacheInfo>> getInfo(CancelToken cancelToken) {
    return _cacheMonitorApiClient
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
