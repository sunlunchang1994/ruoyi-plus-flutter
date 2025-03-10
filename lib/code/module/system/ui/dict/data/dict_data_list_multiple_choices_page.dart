import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/load_more_format.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/select_box.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/entity/tree_dict.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../../feature/bizapi/system/entity/sys_dict_data.dart';
import '../../../../../lib/fast/vd/list_data_component.dart';
import '../../../../../lib/fast/vd/list_data_vd.dart';
import '../../../config/constant_sys.dart';
import '../../../repository/remote/dict_data_api.dart';
import 'dict_data_add_edit_page.dart';
import 'dict_data_list_page_vd.dart';

///
/// @author slc
/// 字典数据多选列表
class DictDataListMultipleChoicesPage
    extends AppBaseStatelessWidget<_DictDataListMultipleChoicesVm> {
  static const String routeName = '/system/dict/data/multiple';
  final String title;
  final String dictType;
  final List<String>? selectedData;

  DictDataListMultipleChoicesPage(this.title, this.dictType, {super.key, this.selectedData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _DictDataListMultipleChoicesVm(selectedData: selectedData),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(dictType);
          return SizedBox(
              width: ScreenUtil.getInstance().screenWidthDpr,
              child: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_DictDataListMultipleChoicesVm, int>(
                      builder: (context, vm, child) {
                    return DictTypeListPageWidget.getDataListWidget(
                        themeData, getVm().listVmSub.dataList, getVm().listVmSub, (currentItem) {
                      return Ink(
                          child: InkWell(
                              child: Padding(
                                  padding: EdgeInsets.all(SlcDimens.appDimens12),
                                  child: const Icon(Icons.chevron_right, size: 24)),
                              onTap: () {
                                //点击更多事件
                                getVm().listVmSub.onSuffixClick?.call(currentItem);
                              }));
                    });
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }
}

class _DictDataListMultipleChoicesVm extends AppBaseVm {
  late DictDataPageVmSub listVmSub;

  _DictDataListMultipleChoicesVm(
      {List<String>? selectedData, LoadMoreFormat<SysDictData>? loadMoreFormat}) {
    //重新配置loadMoreFormat，一次性加在所有数据
    listVmSub = DictDataPageVmSub(
        loadMoreFormat: loadMoreFormat,
        loadMore: (loadMoreFormat) async {
          try {
            IntensifyEntity<PageModel<SysDictData>> intensifyEntity = await DictDataRepository.list(
                    loadMoreFormat.getOffset(),
                    loadMoreFormat.getSize(),
                    listVmSub.currentSearch,
                    listVmSub.defCancelToken)
                .asStream()
                .single;
            DataWrapper<PageModel<SysDictData>> dataWrapper =
                DataTransformUtils.entity2LDWrapper(intensifyEntity);

            if (dataWrapper.isSuccess() && selectedData != null) {
              dataWrapper.data?.records?.forEach((item) {
                item.initSelectBox(checked: selectedData.contains(item.tdDictValue));
              });
            }
            return dataWrapper;
          } catch (e) {
            ResultEntity resultEntity = BaseDio.getError(e);
            return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
          }
        });
    listVmSub.onSuffixClick = (itemData) {};
  }

  void initVm(String dictType) {
    registerVmSub(listVmSub);
    listVmSub.currentSearch.dictType = dictType;
  }
}
