import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_oss_vo.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import 'package:dio/dio.dart';

import '../../../../lib/fast/widget/form/fast_form_builder_text_field.dart';
import '../../../../lib/fast/widget/form/form_operate_with_provider.dart';
import '../../../../lib/fast/widget/form/input_decoration_utils.dart';
import '../../repository/remote/sys_oss_api.dart';

///@author slc
///Oss列表
class OssListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, OssListDataVmSub listVmSub,
      {Widget? Function(SysOssVo currentItem)? buildTrailing}) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysOssVo listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, index, listItem, buildTrailing: buildTrailing);
        },
        separatorBuilder: (context, index) {
          return SlcStyles.tidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
      ThemeData themeData, ListenerItemClick<dynamic> listenerItemClick, int index, SysOssVo listItem,
      {Widget? Function(SysOssVo currentItem)? buildTrailing}) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.originalName!),
        trailing: buildTrailing?.call(listItem),
        visualDensity: VisualDensity.compact,
        onTap: () {
          listenerItemClick.onItemClick(index, listItem);
        });
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer<A>(BuildContext context, ThemeData themeData, OssListDataVmSub listVmSub,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<SysOssVo>(builder: (context, value, child) {
          return FormBuilder(
              key: listVmSub.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.sys_label_config_search_title,
                          style: SlcStyles.tidyUpStyle.getTitleTextStyle(themeData))),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "fileName",
                      initialValue: listVmSub.currentSearch.fileName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_notice_title,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "fileName");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.fileName;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.fileName = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "originalName",
                      initialValue: listVmSub.currentSearch.originalName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oss_original_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "originalName");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.originalName;
                          })),
                      textInputAction: TextInputAction.next),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "fileSuffix",
                      initialValue: listVmSub.currentSearch.fileSuffix,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oss_file_suffix,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "fileSuffix");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.fileSuffix;
                          })),
                      textInputAction: TextInputAction.next),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "service",
                      initialValue: listVmSub.currentSearch.service,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oss_service,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "service");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.service;
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
}

///Oss数据VmSub
class OssListDataVmSub extends FastBaseListDataPageVmSub<SysOssVo> {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  final CancelToken cancelToken = CancelToken();

  SysOssVo _currentSysOssSearch = SysOssVo();

  SysOssVo get currentSearch => _currentSysOssSearch;

  void Function(SysOssVo data)? onSuffixClick;

  OssListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysOssVo>> intensifyEntity = await SysOssRepository.list(
                loadMoreFormat.getOffset(), loadMoreFormat.getSize(), currentSearch, cancelToken)
            .asStream()
            .single;
        DataWrapper<PageModel<SysOssVo>> dateWrapper = DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dateWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      /*pushNamed(NoticeAddEditPage.routeName,
          arguments: {ConstantSys.KEY_SYS_NOTICE: data}).then((result) {
        if (result != null) {
          //更新列表
          sendRefreshEvent();
        }
      });*/
    });
  }

  //重置
  void onResetSearch() {
    _currentSysOssSearch = SysOssVo();
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }
}
