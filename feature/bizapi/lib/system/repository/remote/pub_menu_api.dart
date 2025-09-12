import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';
import 'package:bizapi/system/entity/router_vo.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../user/vm/user_share_vm.dart';

part 'pub_menu_api.g.dart';

/// @author sunlunchang
/// 菜单服务
@RestApi()
abstract class PubMenuApi {
  factory PubMenuApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PubMenuApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取路由信息
  @GET("/system/menu/getRouters")
  Future<ResultEntity> getRouters(@CancelRequest() CancelToken cancelToken);
}

///菜单服务
class PubMenuPublicRepository {
  static final PubMenuApi _pubMenuApi = PubMenuApi();

  static Future<IntensifyEntity<List<RouterVo>>> getRouters(CancelToken cancelToken) {
    return _pubMenuApi.getRouters(cancelToken).successMap((event) {
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
    }).map((event) {
      List<RouterVo> routerVoList = event.data ?? List.empty(growable: true);
      UserShareVm().routerVoOf.setValue(routerVoList);
      return event;
    }).single;
  }
}
