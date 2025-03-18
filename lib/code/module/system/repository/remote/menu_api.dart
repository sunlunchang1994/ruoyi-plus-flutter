import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_menu_tree.dart';

import '../../../../base/api/result_entity.dart';
import '../../entity/sys_menu.dart';

part 'menu_api.g.dart';

@RestApi()
abstract class MenuApiClient {
  factory MenuApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _MenuApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取菜单树信息
  @GET("/system/menu/treeselect")
  Future<ResultEntity> treeselect(
      @Queries() SysMenu? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取角色菜单树信息
  @GET("/system/menu/roleMenuTreeselect/{roleId}")
  Future<ResultEntity> roleMenuTreeselect(
      @Path("roleId") int? roleId, @CancelRequest() CancelToken cancelToken);

  ///获取租户套餐菜单树信息
  @GET("/system/menu/tenantPackageMenuTreeselect/{packageId}")
  Future<ResultEntity> tenantPackageMenuTreeselect(
      @Path("packageId") int? packageId, @CancelRequest() CancelToken cancelToken);

  ///获取菜单列表
  @GET("/system/menu/list")
  Future<ResultEntity> list(
      @Queries() SysMenu? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取菜单信息
  @GET("/system/menu/{menuId}")
  Future<ResultEntity> getInfo(
      @Path("menuId") int menuId, @CancelRequest() CancelToken cancelToken);

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
  static final MenuApiClient _menuApiClient = MenuApiClient();

  ///获取菜单树信息
  static Future<IntensifyEntity<List<SysMenuTree>>> treeselect(
      SysMenu? queryParams, CancelToken cancelToken) {
    return _menuApiClient.treeselect(queryParams, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        return SysMenuTree.fromJsonList(resultEntity.data);
      });
    });
  }

  ///获取角色菜单树信息
  static Future<IntensifyEntity<List<SysMenuTree>>> roleMenuTreeselect(
      int? roleId, CancelToken cancelToken) {
    return _menuApiClient.roleMenuTreeselect(roleId, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        SysMenuTreeWrapper sysMenuTreeWrapper = SysMenuTreeWrapper.fromJson(resultEntity.data);
        SelectUtils.fillSelect(
            sysMenuTreeWrapper.menus, sysMenuTreeWrapper.checkedKeys ?? List.empty(growable: true),
            predicate: (src, target) {
          return src!.id == target;
        }, penetrate: true);
        return sysMenuTreeWrapper.menus;
      });
    });
  }

  ///获取角色菜单树id信息
  static Future<IntensifyEntity<List<int>>> roleMenuCheckedList(
      int? roleId, CancelToken cancelToken) {
    return _menuApiClient.roleMenuTreeselect(roleId, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        SysMenuTreeWrapperOnlyCheckedKeys sysMenuTreeWrapper =
            SysMenuTreeWrapperOnlyCheckedKeys.fromJson(resultEntity.data);
        return sysMenuTreeWrapper.checkedKeys;
      });
    });
  }

  ///获取租户套餐菜单树信息
  static Future<IntensifyEntity<List<SysMenuTree>>> tenantPackageMenuTreeselect(
      int? tenantPackageId, CancelToken cancelToken) {
    return _menuApiClient
        .tenantPackageMenuTreeselect(tenantPackageId, cancelToken)
        .successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        SysMenuTreeWrapper sysMenuTreeWrapper = SysMenuTreeWrapper.fromJson(resultEntity.data);
        SelectUtils.fillSelect(
            sysMenuTreeWrapper.menus, sysMenuTreeWrapper.checkedKeys ?? List.empty(growable: true),
            predicate: (src, target) {
          return src!.id == target;
        }, penetrate: true);
        return sysMenuTreeWrapper.menus;
      });
    });
  }

  ///获取菜单列表
  static Future<IntensifyEntity<List<SysMenu>>> list(SysMenu? sysMenuVo, CancelToken cancelToken) {
    return _menuApiClient.list(sysMenuVo, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        List<SysMenu> sysMenuTreeWrapper = SysMenu.fromJsonList(resultEntity.data);
        return sysMenuTreeWrapper;
      });
    });
  }

  ///获取菜单信息
  static Future<IntensifyEntity<SysMenu?>> getInfo(int menuId, CancelToken cancelToken,
      {bool fillParentName = false}) {
    return _menuApiClient.getInfo(menuId, cancelToken).successMap((event) {
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
        ? _menuApiClient.add(body, cancelToken)
        : _menuApiClient.edit(body, cancelToken);
    return resultFuture.successMap2Single((event) {
      return event.toIntensify<SysMenu>();
    });
  }

  ///删除菜单
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? menuId, List<int>? menuIds}) {
    //参数校验
    assert(menuId != null && menuIds == null || menuId == null && menuIds != null);
    menuIds ??= [menuId!];
    return _menuApiClient
        .delete(menuIds.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
