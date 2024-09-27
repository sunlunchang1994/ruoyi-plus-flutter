import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/extras/system/entity/router_vo.dart';

import '../../../../base/api/api_config.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../entity/captcha.dart';

part 'menu_api.g.dart';

@RestApi()
abstract class MenuApiClient {
  factory MenuApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _MenuApiClient(dio, baseUrl: baseUrl ?? ApiConfig().apiUrl);
  }

  ///获取路由信息
  @GET("/system/menu/getRouters")
  Future<ResultEntity> getRouters();
}

///菜单服务
class MenuServiceRepository {
  static final MenuApiClient _menuApiClient = MenuApiClient();

  static Future<IntensifyEntity<List<RouterVo>>> getRouters() {
    return _menuApiClient
        .getRouters()
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<List<RouterVo>>(
              resultEntity: event,
              createData: (resultEntity) {
                List<RouterVo> dataList = (resultEntity.data as List<Map<String, dynamic>>?)?.map((item) {
                      return RouterVo.fromJson(item);
                    }).toList() ??
                    List.empty(growable: true);//列表为空时创建默认的
                return dataList;
              });
          return intensifyEntity;
        })
        .map(DateTransformUtils.checkErrorIe)
        .single;
  }
}
