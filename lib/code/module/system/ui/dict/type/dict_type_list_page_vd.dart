import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_dict_type.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/system/repository/remote/dict_type_api.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/dict/data/dict_data_list_browser_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/dict/type/dict_type_add_edit_page.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../../res/styles.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../../../../base/config/constant_base.dart';
import '../../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../../lib/fast/provider/fast_select.dart';
import '../../../../../lib/fast/utils/widget_utils.dart';
import '../../../../../lib/fast/vd/list_data_component.dart';
import '../../../../../lib/fast/vd/refresh/content_empty.dart';
import 'package:dio/dio.dart';

import '../../../../../lib/fast/widget/form/fast_form_builder_text_field.dart';
import '../../../../../lib/fast/widget/form/form_operate_with_provider.dart';
import '../../../../../lib/fast/widget/form/input_decoration_utils.dart';
import '../../../config/constant_sys.dart';

///@author slc
///字典类型列表
class DictTypeListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(
      ThemeData themeData,
      DictTypeListDataVmSub listVmSub,
      Widget Function(SysDictType currentItem) buildTrailing) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysDictType listItem = listVmSub.dataList[index];
          return getDataListItem(
              themeData, listVmSub, buildTrailing, index, listItem);
        },
        separatorBuilder: (context, index) {
          return SlcStyles.tidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
    ThemeData themeData,
    ListenerItemClick<dynamic> listenerItemClick,
    Widget? Function(SysDictType currentItem) buildTrailing,
    int index,
    SysDictType listItem,
  ) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.dictName!),
        subtitle: Text(listItem.dictType!),
        trailing: buildTrailing.call(listItem),
        visualDensity: VisualDensity.compact,
        //根据card规则实现
        onTap: () {
          listenerItemClick.onItemClick(index, listItem);
          //getVm().nextByDept(listItem);
        });
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer<A>(BuildContext context, ThemeData themeData,
      DictTypeListDataVmSub listVmSub,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<SysDictType>(builder: (context, value, child) {
          return FormBuilder(
              key: listVmSub.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.sys_label_dict_type_search_title,
                          style: SlcStyles.tidyUpStyle.getTitleTextStyle(themeData))),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "dictName",
                      initialValue: listVmSub.currentSearch.dictName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_dict_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(
                              builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(
                                value,
                                formOperate: listVmSub.formOperate,
                                formFieldName: "dictName");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.dictName;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.dictName = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  FormBuilderTextField(
                      name: "dictType",
                      initialValue: listVmSub.currentSearch.dictType,
                      decoration: MyInputDecoration(
                          contentPadding: EdgeInsets.zero,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_dict_type,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(
                              builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(
                                value,
                                formOperate: listVmSub.formOperate,
                                formFieldName: "dictType");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.dictType;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.dictType = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
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
                        SlcStyles.getSizedBox(width: SlcDimens.appDimens16),
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

///字典类型数据VmSub
class DictTypeListDataVmSub extends FastBaseListDataPageVmSub<SysDictType> with CancelTokenAssist{
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysDictType _currentDictTypeSearch = SysDictType();

  SysDictType get currentSearch => _currentDictTypeSearch;

  void Function(SysDictType data)? onSuffixClick;

  DictTypeListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysDictType>> intensifyEntity =
            await DictTypeRepository.list(
                    loadMoreFormat.getOffset(),
                    loadMoreFormat.getSize(),
                    _currentDictTypeSearch,
                    defCancelToken)
                .asStream()
                .single;
        DataWrapper<PageModel<SysDictType>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DataWrapper.createFailed(
            code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      pushNamed(DictDataListBrowserPage.routeName,
          arguments: {ConstantBase.KEY_INTENT_TITLE: S.current.sys_label_dict_data_list,ConstantSys.KEY_DICT_TYPE: data.dictType});
    });
  }

  //重置
  void onResetSearch() {
    _currentDictTypeSearch = SysDictType();
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }
}
