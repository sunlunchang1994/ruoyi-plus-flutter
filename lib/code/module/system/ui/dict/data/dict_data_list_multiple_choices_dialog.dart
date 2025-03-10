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
import '../../../../../base/repository/remote/page_transform_utils.dart';
import '../../../../../feature/bizapi/system/entity/sys_dict_data.dart';
import '../../../../../lib/fast/vd/list_data_component.dart';
import '../../../../../lib/fast/vd/list_data_vd.dart';
import '../../../config/constant_sys.dart';
import '../../../repository/remote/dict_data_api.dart';
import 'dict_data_add_edit_page.dart';
import 'dict_data_list_page_vd.dart';

///
/// @author slc
/// 字典数据多选对话框
class DictDataListMultipleChoicesDialog
    extends AppBaseStatelessWidget<_DictDataListMultipleChoicesVm> {
  final String title;
  final String dictType;

  DictDataListMultipleChoicesDialog(this.title, this.dictType, {super.key});

  static Widget getDictDataSelectDialog(String title, String dictType,
      {Key? key, List<String>? selectedData}) {
    _DictDataListMultipleChoicesVm vm = _DictDataListMultipleChoicesVm(
        selectedData: selectedData, loadMoreFormat: LoadMoreFormat(size: 1000));
    return ChangeNotifierProvider(
        create: (context) => vm,
        builder: (context, child) {
          return AlertDialog(
            title: Text(title),
            titlePadding: EdgeInsets.only(
                left: SlcDimens.appDimens16,
                right: SlcDimens.appDimens16,
                top: SlcDimens.appDimens16,
                bottom: SlcDimens.appDimens8),
            content: DictDataListMultipleChoicesDialog(title, dictType, key: key),
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            actions: [
              TextButton(
                  onPressed: () {
                    vm.finish();
                  },
                  child: Text(S.current.action_cancel)),
              TextButton(
                  onPressed: () {
                    vm.finish(result: SelectUtils.getSelect(vm.listVmSub.dataList,convert: ((item){
                      return item as ITreeDict<dynamic>;
                    })));
                  },
                  child: Text(S.current.action_ok))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    registerEvent(context);
    getVm().initVm(dictType);
    return SizedBox(
        width: ScreenUtil.getInstance().screenWidthDpr,
        child: ListDataVd(getVm().listVmSub, getVm(),
            refreshOnStart: true,
            child: NqSelector<_DictDataListMultipleChoicesVm, int>(builder: (context, vm, child) {
              return DictTypeListPageWidget.getDataListWidget(
                  themeData, getVm().listVmSub.dataList, getVm().listVmSub, (currentItem) {
                return NqSelector<_DictDataListMultipleChoicesVm, bool>(
                    builder: (context, value, child) {
                  return Checkbox(
                      value: value,
                      onChanged: (checkValue) {
                        currentItem.boxChecked = !currentItem.isBoxChecked();
                        getVm().notifyListeners();
                      });
                }, selector: (context, vm) {
                  return currentItem.isBoxChecked();
                });
              });
            }, selector: (context, vm) {
              return vm.listVmSub.shouldSetState.version;
            })));
  }
}

class _DictDataListMultipleChoicesVm extends AppBaseVm {
  late DictDataListVmSub listVmSub;

  _DictDataListMultipleChoicesVm(
      {List<String>? selectedData, LoadMoreFormat<SysDictData>? loadMoreFormat}) {
    //重新配置loadMoreFormat，一次性加在所有数据
    listVmSub = DictDataListVmSub(refresh: () async {
      try {
        IntensifyEntity<List<SysDictData>> intensifyEntity = await DictDataRepository.list(
                LoadMoreFormat.DEF_OFFICE, 9999, listVmSub.currentSearch, listVmSub.defCancelToken)
            .asStream()
            .map((event) {
          IntensifyEntity<List<SysDictData>> intensifyEntity = IntensifyEntity(
              data: PageTransformUtils.page2List(event.data),
              createSucceed: ResultEntity.createSucceedEntity);
          if (intensifyEntity.isSuccess() && selectedData != null) {
            intensifyEntity.data?.forEach((item) {
              item.initSelectBox(checked: selectedData.contains(item.tdDictValue));
            });
          }
          return intensifyEntity;
        }).single;
        DataWrapper<List<SysDictData>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
  }

  void initVm(String dictType) {
    registerVmSub(listVmSub);
    listVmSub.currentSearch.dictType = dictType;
  }
}
