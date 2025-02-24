import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_menu_tree.dart';

import '../../../../base/api/result_entity.dart';
import '../../../../feature/bizapi/system/entity/sys_menu_vo.dart';

part 'menu_api.g.dart';

@RestApi()
abstract class MenuApiClient {
  factory MenuApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _MenuApiClient(dio,
        baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取菜单信息
  @GET("/system/menu/treeselect")
  Future<ResultEntity> treeselect(@Queries() SysMenuVo? queryParams,
      @CancelRequest() CancelToken cancelToken);
}

class MenuRepository {
  //实例
  static final MenuApiClient _menuApiClient = MenuApiClient();

  static Future<IntensifyEntity<List<SysMenuTree>>> treeselect(
      SysMenuVo? queryParams, CancelToken cancelToken) {
    return _menuApiClient
        .treeselect(queryParams, cancelToken)
        .asStream()
        .map(DataTransformUtils.checkError)
        .map((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysMenuTree.fromJsonList(resultEntity.data);
      });
    }).single;
  }
}
