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
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/app_toast.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_oss_config.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/oss/oss_details_page.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../../base/vm/global_vm.dart';
import '../../../../../lib/fast/provider/fast_select.dart';
import '../../../../../lib/fast/utils/widget_utils.dart';
import '../../../../../lib/fast/vd/list_data_component.dart';
import '../../../../../lib/fast/vd/refresh/content_empty.dart';
import '../../../../../lib/fast/vd/request_token_manager.dart';
import '../../../../../lib/form/fast_form_builder_text_field.dart';
import '../../../../../lib/form/form_operate_with_provider.dart';
import '../../../../../lib/form/input_decoration_utils.dart';
import 'package:dio/dio.dart';

import '../../../config/constant_sys.dart';
import '../../../repository/remote/sys_oss_config_api.dart';
import 'oss_config_add_edit_page.dart';

///@author slc
///Oss列表
class OssConfigListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, OssConfigListDataVmSub listVmSub,
      {Widget? Function(SysOssConfig currentItem)? buildTrailing}) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysOssConfig listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, index, listItem,
              buildTrailing: buildTrailing);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(ThemeData themeData, ListenerItemSelect<dynamic> listenerItemSelect,
      int index, SysOssConfig listItem,
      {Widget? Function(SysOssConfig currentItem)? buildTrailing}) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.configKey!),
        subtitle: Text("${listItem.endpoint} / ${listItem.bucketName}"),
        trailing: WidgetUtils.getAnimCrossFade(
            Checkbox(
              value: listItem.isBoxChecked(),
              onChanged: (value) {
                listItem.boxChecked = value;
                listenerItemSelect.onItemSelect(index, listItem, value);
              },
            ),
            ThemeUtil.getBoxStandard(
              child: Transform.scale(
                  scale: 0.7,
                  origin: Offset(6, 0),
                  alignment: Alignment.centerLeft,
                  child: Switch(
                      value: listItem.isDefStatus(),
                      onChanged: (value) {
                        (listenerItemSelect as OssConfigListDataVmSub)
                            .onChangeDefStatus(listItem, value);
                      })),
            ),
            showOne: listenerItemSelect.selectModelIsRun),
        visualDensity: VisualDensity.compact,
        //tileColor: SlcColors.getCardColorByTheme(themeData),
        onTap: () {
          listenerItemSelect.onItemClick(index, listItem);
        },
        onLongPress: () {
          GlobalVm().userShareVm.execPermiAny(
              ["system:ossConfig:remove"], () => listenerItemSelect.onItemLongClick(index, listItem));
        });
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer<A>(
      BuildContext context, ThemeData themeData, OssConfigListDataVmSub listVmSub,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<SysOssConfig>(builder: (context, value, child) {
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
                      name: "configKey",
                      initialValue: listVmSub.currentSearch.configKey,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oss_config_key,
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
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "bucketName",
                      initialValue: listVmSub.currentSearch.bucketName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oss_config_bucket_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "bucketName");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.bucketName;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.bucketName = value;
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

///Oss数据VmSub
class OssConfigListDataVmSub extends FastBaseListDataPageVmSub<SysOssConfig>
    with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysOssConfig _currentSysOssConfigSearch = SysOssConfig();

  SysOssConfig get currentSearch => _currentSysOssConfigSearch;

  void Function(SysOssVo data)? onSuffixClick;

  OssConfigListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysOssConfig>> intensifyEntity =
            await SysOssConfigRepository.list(
                    loadMoreFormat.offset, loadMoreFormat.size, currentSearch, defCancelToken)
                .asStream()
                .single;
        DataWrapper<PageModel<SysOssConfig>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      pushNamed(OssConfigAddEditPage.routeName, arguments: {ConstantSys.KEY_SYS_OSS_CONFIG: data})
          .then((result) {
        if (result != null) {
          sendRefreshEvent();
        }
      });
    });
  }

  //改变status
  void onChangeDefStatus(SysOssConfig ossConfig, bool value) {
    ossConfig.status =
        value ? LocalDictLib.KEY_SYS_YES_NO_INT_Y : LocalDictLib.KEY_SYS_YES_NO_INT_N;
    showLoading(text: S.current.label_submit_ing);
    SysOssConfigRepository.changeStatus(ossConfig, defCancelToken).then((result) {
      dismissLoading();
      shouldSetState.updateVersion();
      notifyListeners();
    }, onError: (e) {
      dismissLoading();
      BaseDio.handlerErr(e);
    });
  }

  //重置
  void onResetSearch() {
    _currentSysOssConfigSearch = SysOssConfig();
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }
}
