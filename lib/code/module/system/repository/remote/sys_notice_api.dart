import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:ruoyi_plus_flutter/code/base/api/api_config.dart';
import 'package:ruoyi_plus_flutter/code/base/api/base_dio.dart';
import 'package:ruoyi_plus_flutter/code/base/api/request_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/data_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_notice.dart';

import '../../../../base/api/result_entity.dart';
import '../../../../feature/bizapi/system/entity/sys_config.dart';

part 'sys_notice_api.g.dart';

@RestApi()
abstract class SysNoticeApiClient {
  factory SysNoticeApiClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _SysNoticeApiClient(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取通知公告列表
  @GET("/system/notice/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取通知公告信息
  @GET("/system/notice/{dictId}")
  Future<ResultEntity> getInfo(
      @Path("dictId") int dictId, @CancelRequest() CancelToken cancelToken);

  ///添加通知公告
  @POST("/system/notice")
  Future<ResultEntity> add(@Body() SysNotice? data, @CancelRequest() CancelToken cancelToken);

  ///编辑通知公告
  @PUT("/system/notice")
  Future<ResultEntity> edit(@Body() SysNotice? data, @CancelRequest() CancelToken cancelToken);

  ///删除通知公告
  @DELETE("/system/notice/{ids}")
  Future<ResultEntity> delete(@Path("ids") String ids, @CancelRequest() CancelToken cancelToken);
}

class SysNoticeRepository {
  //实例
  static final SysNoticeApiClient _sysConfigApiClient = SysNoticeApiClient();

  static Future<IntensifyEntity<PageModel<SysNotice>>> list(
      int offset, int size, SysNotice? sysConfig, CancelToken cancelToken) {
    return _sysConfigApiClient
        .list(RequestUtils.toPageQuery(sysConfig?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify(
          createData: (resultEntity) =>
              resultEntity.toPageModel(offset, size, createRecords: (resultData) {
                List<SysNotice> sysNoticeList = SysNotice.fromJsonList(resultData);
                fillShowText(sysNoticeList);
                return sysNoticeList;
              }));
    });
  }

  ///获取通知公告信息
  static Future<IntensifyEntity<SysNotice?>> getInfo(int dictId, CancelToken cancelToken,
      {bool fillParentName = false}) {
    return _sysConfigApiClient.getInfo(dictId, cancelToken).successMap2Single((event) {
      return event.toIntensify(createData: (resultEntity) {
        SysNotice sysNotice = SysNotice.fromJson(resultEntity.data);
        fillShowText([sysNotice]);
        return sysNotice;
      });
    });
  }

  ///提交通知公告信息
  static Future<IntensifyEntity<SysNotice>> submit(SysNotice body, CancelToken cancelToken) {
    Future<ResultEntity> resultFuture = body.noticeId == null
        ? _sysConfigApiClient.add(body, cancelToken)
        : _sysConfigApiClient.edit(body, cancelToken);
    return resultFuture.successMap2Single((event) {
      var intensifyEntity = IntensifyEntity<SysNotice>(resultEntity: event);
      return intensifyEntity;
    });
  }

  static void fillShowText(List<SysNotice>? sysNoticeList) {
    if (sysNoticeList?.isNotEmpty ?? false) {
      for (var itemData in sysNoticeList!) {
        itemData.noticeTypeName = GlobalVm()
            .dictShareVm
            .findDict(LocalDictLib.CODE_SYS_NOTICE_TYPE, itemData.noticeType)
            ?.tdDictLabel;
      }
    }
  }

  ///删除通知公告
  static Future<IntensifyEntity<dynamic>> delete(CancelToken cancelToken,
      {int? id, List<int>? ids}) {
    //参数校验
    assert(id != null && ids == null || id == null && ids != null);
    ids ??= [id!];
    return _sysConfigApiClient
        .delete(ids.join(TextUtil.COMMA), cancelToken)
        .successMap2Single((event) {
      return event.toIntensify();
    });
  }
}
