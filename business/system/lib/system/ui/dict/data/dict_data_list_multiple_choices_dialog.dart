import 'package:fast/gen/fast_l10n.dart' as fast_l10n;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:boxes_flutter/flutter/slc/adapter/load_more_format.dart';
import 'package:boxes_flutter/flutter/slc/adapter/select_box.dart';
import 'package:boxes_flutter/flutter/slc/common/screen_util.dart';
import 'package:provider/provider.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:component/component/dict/entity/tree_dict.dart';
import 'package:fast/fast/provider/fast_select.dart';

import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';
import 'package:base/base/repository/remote/page_transform_utils.dart';
import 'package:base/base/ui/utils/fast_dialog_utils.dart';
import 'package:bizapi/system/entity/sys_dict_data.dart';
import 'package:fast/fast/vd/list_data_component.dart';
import 'package:fast/fast/vd/list_data_vd.dart';
import 'package:system/system/repository/remote/dict_data_api.dart';
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
          return FastDialogUtils.getBottomAlertDialog(
            title: Text(title),
            content: DictDataListMultipleChoicesDialog(title, dictType, key: key),
            actions: [
              TextButton(
                  onPressed: () {
                    vm.finish();
                  },
                  child: Text(fast_l10n.FastS.current.action_cancel)),
              TextButton(
                  onPressed: () {
                    vm.finish(
                        result: SelectUtils.getSelect<SysDictData, ITreeDict<dynamic>>(
                            vm.listVmSub.dataList));
                  },
                  child: Text(fast_l10n.FastS.current.action_ok))
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
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
  }

  void initVm(String dictType) {
    registerVmSub(listVmSub);
    listVmSub.currentSearch.dictType = dictType;
  }
}
