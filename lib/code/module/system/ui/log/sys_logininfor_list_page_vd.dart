import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/utils/dict_ui_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_logininfor.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_log_page.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../../res/styles.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../base/ui/utils/fast_dialog_utils.dart';
import '../../../../feature/bizapi/system/repository/local/local_dict_lib.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/utils/app_toast.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';

import '../../../../lib/form/fast_form_builder_text_field.dart';
import '../../../../lib/form/input_decoration_utils.dart';
import '../../repository/remote/sys_logininfor_api.dart';

///@author slc
///登录日志列表
class SysLogininforListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, LogininforListDataVmSub listVmSub,
      {Widget? Function(SysLogininfor currentItem)? buildTrailing}) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysLogininfor listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, buildTrailing, index, listItem);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
    ThemeData themeData,
    ListenerItemSelect<dynamic> listenerItemSelect,
    Widget? Function(SysLogininfor currentItem)? buildTrailing,
    int index,
    SysLogininfor listItem,
  ) {
    Color statusColor =
        DictUiUtils.getDictStyle(LocalDictLib.CODE_SYS_COMMON_STATUS, listItem.status);
    return Builder(builder: (context) {
      return ListTile(
          contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
          title: Row(
            children: [
              Text(listItem.userName!),
              Spacer(),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  decoration: BoxDecoration(
                      border: Border.all(color: statusColor, width: 1),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    listItem.statusName ?? "-",
                    style: SysStyle.sysLogListStatusText.copyWith(color: statusColor),
                    strutStyle: SysStyle.sysLogListStatusTextStrutStyle,
                  )),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: () {
              List<Widget> widgets = [];
              widgets.add(Text(listItem.loginTime ?? ""));
              widgets.add(AnimatedSize(
                duration: WidgetUtils.adminDurationNormal,
                alignment: Alignment.topLeft, // 设置对齐方式确保从上到下展开
                curve: Curves.easeInOut,
                child: Visibility(
                  visible: listItem.showDetail,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${listItem.browser} / ${listItem.os}"),
                      Text("${listItem.ipaddr} / ${listItem.loginLocation}")
                    ],
                  ),
                ),
              ));
              return widgets;
            }.call(),
          ),
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
            FastDialogUtils.showDelConfirmDialog(context,
                    contentText:
                        TextUtil.format(S.current.sys_label_dict_del_prompt, [listItem.infoId]))
                .then((confirm) {
              if (confirm == true) {
                listenerItemSelect as LogininforListDataVmSub;
                listenerItemSelect.onDelete(listItem);
              }
            });
            listenerItemSelect.onItemLongClick(index, listItem);
          });
    });
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer(BuildContext context, ThemeData themeData,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    LogLoginSearchVm searchVm = Provider.of<LogLoginSearchVm>(context);
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<SysLogininfor>(builder: (context, value, child) {
          return FormBuilder(
              key: searchVm.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.sys_label_logininfor_search,
                          style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData))),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "ipaddr",
                      initialValue: searchVm.currentSearch.ipaddr,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_logininfor_ip,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<LogLoginSearchVm, String?>(
                              builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: searchVm.formOperate, formFieldName: "ipaddr");
                          }, selector: (context, vm) {
                            return searchVm.currentSearch.ipaddr;
                          })),
                      onChanged: (value) {
                        searchVm.currentSearch.ipaddr = value;
                        searchVm.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "userName",
                      initialValue: searchVm.currentSearch.userName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oper_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<LogLoginSearchVm, String?>(
                              builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: searchVm.formOperate, formFieldName: "userName");
                          }, selector: (context, vm) {
                            return searchVm.currentSearch.userName;
                          })),
                      onChanged: (value) {
                        searchVm.currentSearch.userName = value;
                        searchVm.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderSelect(
                      name: "statusName",
                      initialValue: searchVm.currentSearch.statusName,
                      onTap: () {
                        DictUiUtils.showSelectDialog(context, LocalDictLib.CODE_SYS_COMMON_STATUS,
                            (value) {
                          searchVm.setSelectStatus(value);
                        });
                      },
                      decoration: MySelectDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_logininfor_status,
                          hintText: S.current.app_label_please_choose,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<LogLoginSearchVm, String?>(
                              builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixBySelectVal(value, onPressed: () {
                              searchVm.setSelectStatus(null);
                            });
                          }, selector: (context, vm) {
                            return searchVm.currentSearch.statusName;
                          })),
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  Expanded(child: Builder(builder: (context) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: OutlinedButton(
                                onPressed: () {
                                  searchVm.onResetSearch();
                                },
                                child: Text(S.current.action_reset))),
                        ThemeUtil.getSizedBox(width: SlcDimens.appDimens16),
                        Expanded(
                            child: FilledButton(
                                onPressed: () {
                                  WidgetUtils.autoHandlerSearchDrawer(context);
                                  searchVm.onSearch();
                                },
                                child: Text(S.current.action_search)))
                      ],
                    );
                  }))
                ],
              ));
        }, selector: (context) {
          return searchVm.currentSearch;
        }, shouldRebuild: (oldVal, newVal) {
          return false;
        }));
  }
}

///登录日志数据VmSub
class LogininforListDataVmSub extends FastBaseListDataPageVmSub<SysLogininfor>
    with CancelTokenAssist {
  SysLogininfor currentSearch = SysLogininfor();

  //显示详情
  final Map<int, bool> showDetailsStatusMap = {};

  void Function(SysLogininfor data)? onSuffixClick;

  LogininforListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysLogininfor>> intensifyEntity =
            await SysLogininforRepository.list(
                    loadMoreFormat.offset, loadMoreFormat.size, currentSearch, defCancelToken)
                .asStream()
                .map((result) {
          result.data?.getListNoNull().forEach((dataItem) {
            dataItem.showDetail = showDetailsStatusMap[dataItem.infoId!] ?? false;
          });
          return result;
        }).single;
        DataWrapper<PageModel<SysLogininfor>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      onHandlerShowDetails(data);
    });
  }

  void onHandlerShowDetails(SysLogininfor itemData) {
    itemData.showDetail = !itemData.showDetail;
    showDetailsStatusMap[itemData.infoId!] = itemData.showDetail;
    shouldSetState.updateVersion();
    notifyListeners();
  }

  //删除日志
  void onDelete(SysLogininfor itemData) {
    showLoading(text: S.current.label_delete_ing);
    SysLogininforRepository.delete(defCancelToken, id: itemData.infoId).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: S.current.label_delete_success);
      sendRefreshEvent();
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: S.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}
