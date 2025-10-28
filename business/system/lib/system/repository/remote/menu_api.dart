import 'package:bizapi/system/entity/sys_menu_tree.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';

import 'package:base/base/api/result_entity.dart';
import '../../entity/sys_menu.dart';

part 'menu_api.g.dart';

@RestApi()
abstract class MenuApi {
  factory MenuApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _MenuApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取菜单树信息
  @GET("/system/menu/treeselect")
  Future<ResultEntity> treeselect(
      @Queries() SysMenu? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取菜单列表
  @GET("/system/menu/list")
  Future<ResultEntity> list(
      @Queries() SysMenu? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取菜单信息
  @GET("/system/menu/{menuId}")
  Future<ResultEntity> getInfo(
      @Path("menuId") String menuId, @CancelRequest() CancelToken cancelToken);

  ///添加菜单
  @POST("/system/menu")
  Future<ResultEntity> add(@Body() SysMenu? data, @CancelRequest() CancelToken cancelToken);

  ///编辑菜单
  @PUT("/system/menu")
  Future<ResultEntity> edit(@Body() SysMenu? data, @CancelRequest() CancelToken cancelToken);

  ///删除菜单
  @DELETE("/system/menu/{typeIds}")
  Future<ResultEntity> delete(
      @Path("typeIds") String typeIds, @CancelRequest() CancelToken cancelToken);
}

class MenuRepository {
  //实例
  static final MenuApi _menuApi = MenuApi();

  ///获取菜单树信息
  static Future<IntensifyEntity<List<SysMenuTree>>> treeselect(
      SysMenu? queryParams, CancelToken cancelToken) {
    return _menuApi.treeselect(queryParams, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysMenuTree.fromJsonList(resultEntity.data);
      });
    });
  }

  ///获取菜单列表
  static Future<IntensifyEntity<List<SysMenu>>> list(SysMenu? sysMenuVo, CancelToken cancelToken) {
    return _menuApi.list(sysMenuVo, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        List<SysMenu> sysMenuTreeWrapper = SysMenu.fromJsonList(resultEntity.data);
        return sysMenuTreeWrapper;
      });
    });
  }

  ///获取菜单信息
  static Future<IntensifyEntity<SysMenu?>> getInfo(BigInt menuId, CancelToken cancelToken,
      {bool fillParentName = false}) {
    return _menuApi.getInfo(menuId.toString(), cancelToken).successMap((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysMenu.fromJson(resultEntity.data);
      });
    }).asyncMap<IntensifyEntity<SysMenu?>>((event) {
      if (fillParentName && event.data != null) {
        return MenuRepository.getInfo(event.data!.parentId!, cancelToken)
            .asStream()
            .map((parentMenuEvent) {
          event.data!.parentName = parentMenuEvent.data?.menuName;
          return event;
        }).single;
      }
      return event;
    }).single;
  }

  ///提交菜单信息
  static Future<IntensifyEntity<SysMenu>> submit(SysMenu body, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = body.menuId == null
        ? _menuApi.add(body, cancelToken)
        : _menuApi.edit(body, cancelToken);
    return resultFuture.successMap2Single((event) {
      return event.toIntensify<SysMenu>();
    });
  }

  ///删除菜单
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {BigInt? menuId, List<BigInt>? menuIds}) {
    //参数校验
    assert(menuId != null && menuIds == null || menuId == null && menuIds != null);
    menuIds ??= [menuId!];
    return _menuApi
        .delete(menuIds.map((e) => e.toString()).join(TextUtil.comma), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
