import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/load_more_format.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/repository/remote/page_transform_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/list_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../../res/styles.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../../feature/bizapi/system/entity/sys_dict_data.dart';
import '../../../../../lib/fast/provider/fast_select.dart';
import '../../../../../lib/fast/utils/widget_utils.dart';
import '../../../../../lib/fast/vd/list_data_component.dart';
import '../../../../../lib/fast/vd/refresh/content_empty.dart';
import 'package:dio/dio.dart';

import '../../../../../lib/form/fast_form_builder_text_field.dart';
import '../../../../../lib/form/form_operate_with_provider.dart';
import '../../../../../lib/form/input_decoration_utils.dart';
import '../../../config/constant_sys.dart';
import '../../../repository/remote/dict_data_api.dart';
import 'dict_data_add_edit_page.dart';

///@author slc
///字典数据列表
class DictTypeListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(
      ThemeData themeData,
      List<SysDictData> dataList,
      ListenerItemSelect<dynamic> listenerItemSelect,
      Widget Function(SysDictData currentItem) buildTrailing) {
    if (dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: dataList.length,
        itemBuilder: (ctx, index) {
          SysDictData listItem = dataList[index];
          return getDataListItem(themeData, listenerItemSelect, buildTrailing, index, listItem);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
    ThemeData themeData,
    ListenerItemSelect<dynamic> listenerItemSelect,
    Widget? Function(SysDictData currentItem) buildTrailing,
    int index,
    SysDictData listItem,
  ) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.dictLabel!),
        subtitle: Text(listItem.dictValue!),
        trailing: WidgetUtils.getAnimCrossFade(
            Checkbox(
              value: listItem.isBoxChecked(),
              onChanged: (value) {
                listItem.boxChecked = value;
                listenerItemSelect.onItemSelect(index, listItem, value);
              },
            ),
            buildTrailing.call(listItem) ?? ThemeUtil.getBoxStandard(),
            showOne: listenerItemSelect.selectModelIsRun),
        visualDensity: VisualDensity.compact,
        //tileColor: SlcColors.getCardColorByTheme(themeData),
        onTap: () {
          listenerItemSelect.onItemClick(index, listItem);
        },
        onLongPress: () {
          listenerItemSelect.onItemLongClick(index, listItem);
        });
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer<A>(
      BuildContext context, ThemeData themeData, DictDataPageVmSub listVmSub,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<SysDictData>(builder: (context, value, child) {
          return FormBuilder(
              key: listVmSub.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.sys_label_dict_data_search_title,
                          style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData))),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "dictLabel",
                      initialValue: listVmSub.currentSearch.dictLabel,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_dict_data_label,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "dictLabel");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.dictLabel;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.dictLabel = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  Expanded(child: Builder(builder: (context) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  listVmSub.onResetSearch();
                                },
                                child: Text(S.current.action_reset))),
                        ThemeUtil.getSizedBox(width: SlcDimens.appDimens16),
                        Expanded(
                            child: FilledButton(
                                onPressed: () {
                                  WidgetUtils.autoHandlerSearchDrawer(context);
                                  listVmSub.onSearch();
                                },
                                child: Text(S.current.action_search)))
                      ],
                    );
                  }))
                ],
              ));
        }, selector: (context) {
          return listVmSub.currentSearch;
        }, shouldRebuild: (oldVal, newVal) {
          return false;
        }));
  }
}

///字典数据分页VmSub
class DictDataPageVmSub extends FastBaseListDataPageVmSub<SysDictData> with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysDictData _currentDictTypeSearch = SysDictData();

  SysDictData get currentSearch => _currentDictTypeSearch;

  void Function(SysDictData data)? onSuffixClick;

  DictDataPageVmSub({super.loadMoreFormat, LoadMore<SysDictData>? loadMore}) {
    //设置刷新方法主体
    setLoadData(loadMore ??
        (loadMoreFormat) async {
          try {
            IntensifyEntity<PageModel<SysDictData>> intensifyEntity = await DictDataRepository.list(
                    loadMoreFormat.offset,
                    loadMoreFormat.size,
                    _currentDictTypeSearch,
                    defCancelToken)
                .asStream()
                .single;
            DataWrapper<PageModel<SysDictData>> dataWrapper =
                DataTransformUtils.entity2LDWrapper(intensifyEntity);
            return dataWrapper;
          } catch (e) {
            ResultEntity resultEntity = BaseDio.getError(e);
            return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
          }
        });
    //设置点击item事件主体
    setItemClick((index, data) {
      pushNamed(DictDataAddEditPage.routeName, arguments: {ConstantSys.KEY_DICT_DATA: data})
          .then((result) {
        if (result != null) {
          //更新列表
          sendRefreshEvent();
        }
      });
    });
  }

  //重置
  void onResetSearch() {
    String? dictType = _currentDictTypeSearch.dictType;
    _currentDictTypeSearch = SysDictData();
    _currentDictTypeSearch.dictType = dictType;
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }
}

///字典数据分页VmSub
class DictDataListVmSub extends FastBaseListDataVmSub<SysDictData> with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysDictData _currentDictTypeSearch = SysDictData();

  SysDictData get currentSearch => _currentDictTypeSearch;

  void Function(SysDictData data)? onSuffixClick;

  DictDataListVmSub({Refresh<SysDictData>? refresh}) {
    //设置刷新方法主体
    setRefresh(refresh ??
        () async {
          try {
            IntensifyEntity<List<SysDictData>> intensifyEntity = await DictDataRepository.list(
                    LoadMoreFormat.DEF_OFFICE, 9999, _currentDictTypeSearch, defCancelToken)
                .asStream()
                .map((event) {
              return IntensifyEntity(
                  data: PageTransformUtils.page2List(event.data),
                  createSucceed: ResultEntity.createSucceedEntity);
            }).single;
            DataWrapper<List<SysDictData>> dataWrapper =
                DataTransformUtils.entity2LDWrapper(intensifyEntity);
            return dataWrapper;
          } catch (e) {
            ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
            return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
          }
        });
    //设置点击item事件主体
    setItemClick((index, data) {
      data.boxChecked = !data.isBoxChecked();
      notifyListeners();
    });
  }

  //重置
  void onResetSearch() {
    String? dictType = _currentDictTypeSearch.dictType;
    _currentDictTypeSearch = SysDictData();
    _currentDictTypeSearch.dictType = dictType;
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }
}
