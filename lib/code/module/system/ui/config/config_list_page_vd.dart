import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_config.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/entity/tree_dict.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../../res/styles.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/component/dict/repository/local/local_dict_lib.dart';
import '../../../../feature/component/dict/utils/dict_ui_utils.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import 'package:dio/dio.dart';

import '../../../../lib/fast/widget/form/fast_form_builder_text_field.dart';
import '../../../../lib/fast/widget/form/form_operate_with_provider.dart';
import '../../../../lib/fast/widget/form/input_decoration_utils.dart';
import '../../config/constant_sys.dart';
import '../../repository/remote/sys_config_api.dart';
import 'config_add_edit_page.dart';

///@author slc
///参数配置列表
class ConfigListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, ConfigListDataVmSub listVmSub,
      Widget Function(SysConfig currentItem) buildTrailing) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysConfig listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, buildTrailing, index, listItem);
        },
        separatorBuilder: (context, index) {
          return AppStyles.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
    ThemeData themeData,
    ListenerItemClick<dynamic> listenerItemClick,
    Widget? Function(SysConfig currentItem) buildTrailing,
    int index,
    SysConfig listItem,
  ) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.configName!),
        subtitle: Text(listItem.configKey!),
        trailing: buildTrailing.call(listItem),
        visualDensity: VisualDensity.compact,
        //根据card规则实现
        onTap: () {
          listenerItemClick.onItemClick(index, listItem);
          //getVm().nextByDept(listItem);
        });
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer<A>(
      BuildContext context, ThemeData themeData, ConfigListDataVmSub listVmSub,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<SysConfig>(builder: (context, value, child) {
          return FormBuilder(
              key: listVmSub.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.user_label_search_role,
                          style: SlcStyles.getTitleTextStyle(themeData))),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "configName",
                      initialValue: listVmSub.currentSearch.configName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_config_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "configName");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.configName;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.configName = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "configKey",
                      initialValue: listVmSub.currentSearch.configKey,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_config_key,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "configKey");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.configKey;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.configKey = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderSelect(
                      name: "configTypeName",
                      initialValue: listVmSub.currentSearch.configTypeName,
                      onTap: (){
                        _onSelectConfigType(context,listVmSub);
                      },
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_config_type,
                          hintText: S.current.app_label_please_choose,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixBySelectVal(value, onPressed: () {
                              listVmSub.setSelectConfigType(null);
                            });
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.configTypeName;
                          })),
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


  static void _onSelectConfigType(
      BuildContext context, ConfigListDataVmSub listVmSub) {
    showDialog(
        context: context,
        builder: (context) {
          List<SimpleDialogOption> dialogItem = DictUiUtils.dictList2DialogItem(
              context,
              LocalDictLib.DICT_MAP[LocalDictLib.CODE_SYS_YES_NO]!,
                  (value) {
                //选择后设置性别
                listVmSub.setSelectConfigType(value);
              });
          return SimpleDialog(
              title: Text(S.current.sys_label_config_type_select),
              children: dialogItem);
        });
  }
}

///参数配置数据VmSub
class ConfigListDataVmSub extends FastBaseListDataPageVmSub<SysConfig> {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  final CancelToken cancelToken = CancelToken();

  SysConfig _currentSysConfigSearch = SysConfig();

  SysConfig get currentSearch => _currentSysConfigSearch;

  void Function(SysConfig data)? onSuffixClick;

  ConfigListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysConfig>> intensifyEntity = await SysConfigRepository.list(
                loadMoreFormat.getOffset(), loadMoreFormat.getSize(), currentSearch, cancelToken)
            .asStream()
            .single;
        DataWrapper<PageModel<SysConfig>> dateWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dateWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      pushNamed(ConfigAddEditPage.routeName,
          arguments: {ConstantSys.KEY_SYS_CONFIG: data}).then((result) {
        if (result != null) {
          //更新列表
          sendRefreshEvent();
        }
      });
    });
  }

  void setSelectConfigType(ITreeDict<dynamic>? data) {
    _currentSysConfigSearch.configType = data?.tdDictValue;
    _currentSysConfigSearch.configTypeName = data?.tdDictLabel;
    formOperate.patchField("configTypeName", _currentSysConfigSearch.configTypeName);
    notifyListeners();
  }

  //重置
  void onResetSearch() {
    _currentSysConfigSearch = SysConfig();
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }
}
