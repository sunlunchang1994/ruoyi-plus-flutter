import 'package:base/base/api/result_entity.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:boxes_flutter/flutter/slc/adapter/page_model.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:base/base/api/api_config.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/request_utils.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';
import 'package:base/base/vm/global_vm.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_dict_type.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';

import '../../../../component/dict/entity/tree_dict.dart';
import '../../../../component/dict/vm/dict_share_vm.dart';
import '../../entity/sys_dict_data.dart';

part 'pub_dict_data_api.g.dart';

/// @author sunlunchang
/// 字典数据服务
@RestApi()
abstract class PubDictDataApi {
  factory PubDictDataApi({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _PubDictDataApi(dio, baseUrl: baseUrl ?? ApiConfig().getServiceApiAddress());
  }

  ///获取字典数据列表
  @GET("/system/dict/data/list")
  Future<ResultPageModel> list(
      @Queries() Map<String, dynamic>? queryParams, @CancelRequest() CancelToken cancelToken);

  ///获取字典类型列表
  @GET("/system/dict/type/optionselect")
  Future<ResultEntity> optionSelect(@CancelRequest() CancelToken cancelToken);
}

class PubDictDataRepository {
  //实例
  static final PubDictDataApi _pubDictDataApi = PubDictDataApi();

  static Future<IntensifyEntity<PageModel<SysDictData>>> list(
      int offset, int size, SysDictData? sysDictType, CancelToken cancelToken) {
    return _pubDictDataApi
        .list(RequestUtils.toPageQuery(sysDictType?.toJson(), offset, size), cancelToken)
        .successMap2Single((event) {
      return event.toPage2Intensify(offset, size,
          createData: (dataItem) => SysDictData.fromJson(dataItem));
    });
  }

  static Future<IntensifyEntity<List<SysDictType>>> optionSelect(CancelToken cancelToken) {
    //获取类型
    return _pubDictDataApi.optionSelect(cancelToken).successMap2Single((event) {
      return event.toIntensify(
          createData: (resultEntity) => SysDictType.fromJsonList(resultEntity.data));
    });
  }

  ///获取所有字典
  static Future<IntensifyEntity<Map<String, List<ITreeDict<dynamic>>>>> cacheDict(
      CancelToken cancelToken) {
    //获取类型
    return getAllDictInfo(cancelToken).then((result) {
      //缓存字典数据
      if (result.data != null) {
        DictShareVm().dictMap.clear();
        DictShareVm().dictMap.addAll(LocalDictLib.LOCAL_DICT_MAP);
        DictShareVm().dictMap.addAll(result.data!);
      }
      return result;
    });
  }

  ///获取所有字典
  static Future<IntensifyEntity<Map<String, List<ITreeDict<dynamic>>>>> getAllDictInfo(
      CancelToken cancelToken) {
    //获取类型
    return list(0, 99999999, null, cancelToken).asStream().map((dictDataEvent) {
      //构建字典最终类型
      Map<String, List<ITreeDict<dynamic>>> dictMap = {};
      //遍历结果
      dictDataEvent.data?.getListNoNull().forEach((dictDataItem) {
        List<ITreeDict<dynamic>> dictDataListByType = dictMap[dictDataItem.dictType!] ??
            () {
              //不存在则创建
              List<ITreeDict<dynamic>> createList = List.empty(growable: true);
              dictMap[dictDataItem.dictType!] = createList;
              return createList;
            }.call();
        //如果是空则创建
        dictDataListByType.add(dictDataItem);
      });
      return IntensifyEntity(
          createSucceed: () {
            return ResultEntity(code: ApiConfig.VALUE_CODE_SUCCEED);
          },
          data: dictMap);
    }).single;
  }
}
