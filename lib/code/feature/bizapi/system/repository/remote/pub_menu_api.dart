import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/router_vo.dart';

import '../../../../../base/api/api_config.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../../base/vm/global_vm.dart';

part 'pub_menu_api.g.dart';

@RestApi()
abstract class PubMenuApiClient {
  factory PubMenuApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PubMenuApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取路由信息
  @GET("/system/menu/getRouters")
  Future<ResultEntity> getRouters(@CancelRequest() CancelToken cancelToken);
}

///菜单服务
class PubMenuPublicRepository {
  static final PubMenuApiClient _menuApiClient = PubMenuApiClient();

  static Future<IntensifyEntity<List<RouterVo>>> getRouters(CancelToken cancelToken) {
    return _menuApiClient
        .getRouters(cancelToken)
        .asStream()
        .map((event) {
          var intensifyEntity = IntensifyEntity<List<RouterVo>>(
              resultEntity: event,
              createData: (resultEntity) {
                List<RouterVo> dataList = (resultEntity.data as List<dynamic>?)?.map((item) {
                      return RouterVo.fromJson(item);
                    }).toList() ??
                    List.empty(growable: true); //列表为空时创建默认的
                return dataList;
              });
          return intensifyEntity;
        })
        .map(DataTransformUtils.checkErrorIe)
        .map((event) {
          List<RouterVo> routerVoList = event.data??List.empty(growable: true);
          GlobalVm().userShareVm.routerVoOf.setValue(routerVoList);
          return event;
        })
        .single;
  }
}
