import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_oss_vo.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/repository/local/local_dict_lib.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/entity/tree_dict.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/utils/dict_ui_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_client.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/client/sys_client_add_edit_page.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import '../../../../lib/form/fast_form_builder_text_field.dart';
import '../../../../lib/form/form_operate_with_provider.dart';
import '../../../../lib/form/input_decoration_utils.dart';
import 'package:dio/dio.dart';

import '../../config/constant_sys.dart';
import '../../repository/remote/sys_client_api.dart';

///@author slc
///客户端列表
class OssConfigListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, SysClientListDataVmSub listVmSub,
      {Widget? Function(SysClient currentItem)? buildTrailing}) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysClient listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, index, listItem,
              buildTrailing: buildTrailing);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(ThemeData themeData, ListenerItemSelect<dynamic> listenerItemSelect,
      int index, SysClient listItem,
      {Widget? Function(SysClient currentItem)? buildTrailing}) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.clientKey!),
        subtitle: Text(listItem.clientId!),
        trailing: WidgetUtils.getAnimCrossFade(
            Checkbox(
              value: listItem.isBoxChecked(),
              onChanged: (value) {
                listItem.boxChecked = value;
                listenerItemSelect.onItemSelect(index, listItem, value);
              },
            ),
            buildTrailing?.call(listItem) ?? WidgetUtils.getBoxStandard(),
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
      BuildContext context, ThemeData themeData, SysClientListDataVmSub listVmSub,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<SysClient>(builder: (context, value, child) {
          return FormBuilder(
              key: listVmSub.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.sys_label_oss_search,
                          style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData))),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "clientKey",
                      initialValue: listVmSub.currentSearch.clientKey,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_sys_client_client_key,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "clientKey");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.clientKey;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.clientKey = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "clientSecret",
                      initialValue: listVmSub.currentSearch.clientSecret,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_sys_client_client_secret,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "clientSecret");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.clientSecret;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.clientSecret = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderSelect(
                      name: "statusName",
                      initialValue: listVmSub.currentSearch.statusName,
                      onTap: () {
                        DictUiUtils.showSelectDialog(context, LocalDictLib.CODE_SYS_NORMAL_DISABLE,
                            (value) {
                          listVmSub.onSelectStatus(value);
                        });
                      },
                      decoration: MySelectDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_sys_client_status,
                          hintText: S.current.app_label_please_choose,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixBySelectVal(value, onPressed: () {
                              listVmSub.onSelectStatus(null);
                            });
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.statusName;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.statusName = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
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

///客户端VmSub
class SysClientListDataVmSub extends FastBaseListDataPageVmSub<SysClient> with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysClient _currentSysClientSearch = SysClient();

  SysClient get currentSearch => _currentSysClientSearch;

  void Function(SysOssVo data)? onSuffixClick;

  SysClientListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysClient>> intensifyEntity = await SysClientRepository.list(
                loadMoreFormat.offset, loadMoreFormat.size, currentSearch, defCancelToken)
            .asStream()
            .single;
        DataWrapper<PageModel<SysClient>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      pushNamed(SysClientAddEditPage.routeName, arguments: {ConstantSys.KEY_SYS_CLIENT: data})
          .then((result) {
        if (result != null) {
          sendRefreshEvent();
        }
      });
    });
  }

  void onSelectStatus(ITreeDict<dynamic>? dict) {
    formOperate.formBuilderState?.save();
    _currentSysClientSearch.status = dict?.tdDictValue;
    _currentSysClientSearch.statusName = dict?.tdDictLabel;
    notifyListeners();
  }

  //重置
  void onResetSearch() {
    _currentSysClientSearch = SysClient();
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }
}
