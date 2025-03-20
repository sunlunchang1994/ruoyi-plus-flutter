import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/colors.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/utils/dict_ui_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_log_page.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_oper_log_details_page.dart';

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
import 'package:dio/dio.dart';

import '../../../../lib/form/fast_form_builder_text_field.dart';
import '../../../../lib/form/input_decoration_utils.dart';
import '../../config/constant_sys.dart';
import '../../entity/sys_oper_log.dart';
import '../../repository/remote/sys_oper_log_api.dart';

///@author slc
///操作日志列表
class SysOperLogListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, SysOperLogListDataVmSub listVmSub) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysOperLog listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, index, listItem);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(ThemeData themeData, ListenerItemSelect<dynamic> listenerItemSelect,
      int index, SysOperLog listItem) {
    Color statusColor =
        DictUiUtils.getDictStyle(LocalDictLib.CODE_SYS_COMMON_STATUS, listItem.status);
    return Builder(builder: (context) {
      return ListTile(
          contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
          //title: Text("${listItem.operId.toString()}·${listItem.title!}"),
          title: Row(
            children: [
              RichText(
                  text: TextSpan(
                      style: themeData.slcListTileStyle.getItemTitleStyleByThemeData(themeData),
                      children: [
                    TextSpan(text: listItem.title!),
                    TextSpan(text: "·"),
                    TextSpan(
                        text: listItem.businessTypeName,
                        style: TextStyle(
                            color: DictUiUtils.getDictStyle(LocalDictLib.CODE_SYS_OPER_TYPE,
                                listItem.businessType?.toString())))
                  ])),
              Spacer(),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  decoration: BoxDecoration(
                      border: Border.all(color: statusColor, width: 1),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    textAlign: TextAlign.center,
                    listItem.statusName ?? "-",
                    style: SysStyle.sysLogListStatusText.copyWith(color: statusColor),
                    strutStyle: SysStyle.sysLogListStatusTextStrutStyle,
                  )),
              ThemeUtil.getSizedBox(width: SlcDimens.appDimens16)
            ],
          ),
          subtitle: Padding(
              padding: EdgeInsets.only(right: SlcDimens.appDimens16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${listItem.operName} / ${listItem.deptName} / ${listItem.operIp} / ${listItem.operLocation} ",
                      softWrap: true),
                  Text(listItem.operTime ?? "--"),
                ],
              )),
          /*trailing: WidgetUtils.getAnimCrossFade(
              Checkbox(
                value: listItem.isBoxChecked(),
                onChanged: (value) {
                  listItem.boxChecked = value;
                  listenerItemSelect.onItemSelect(index, listItem, value);
                },
              ),
              WidgetUtils.getBoxStandard(),
              showOne: listenerItemSelect.selectModelIsRun),*/
          visualDensity: VisualDensity.compact,
          //tileColor: SlcColors.getCardColorByTheme(themeData),
          onTap: () {
            listenerItemSelect.onItemClick(index, listItem);
          },
          onLongPress: () {
            FastDialogUtils.showDelConfirmDialog(context,
                    contentText:
                        TextUtil.format(S.current.sys_label_log_del_prompt, [listItem.operId]))
                .then((confirm) {
              if (confirm == true) {
                listenerItemSelect as SysOperLogListDataVmSub;
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
    LogOperSearchVm searchVm = Provider.of<LogOperSearchVm>(context);
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<SysOperLog>(builder: (context, value, child) {
          return FormBuilder(
              key: searchVm.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.sys_label_oper_search,
                          style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData))),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "operIp",
                      initialValue: searchVm.currentSearch.operIp,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oper_ip,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<LogOperSearchVm, String?>(
                              builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: searchVm.formOperate, formFieldName: "operIp");
                          }, selector: (context, vm) {
                            return searchVm.currentSearch.operIp;
                          })),
                      onChanged: (value) {
                        searchVm.currentSearch.operIp = value;
                        searchVm.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "title",
                      initialValue: searchVm.currentSearch.title,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oper_title,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<LogOperSearchVm, String?>(
                              builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: searchVm.formOperate, formFieldName: "title");
                          }, selector: (context, vm) {
                            return searchVm.currentSearch.title;
                          })),
                      onChanged: (value) {
                        searchVm.currentSearch.title = value;
                        searchVm.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "operName",
                      initialValue: searchVm.currentSearch.operName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oper_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<LogOperSearchVm, String?>(
                              builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: searchVm.formOperate, formFieldName: "operName");
                          }, selector: (context, vm) {
                            return searchVm.currentSearch.operName;
                          })),
                      onChanged: (value) {
                        searchVm.currentSearch.operName = value;
                        searchVm.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderSelect(
                      name: "businessType",
                      initialValue: searchVm.currentSearch.businessTypeName,
                      onTap: () {
                        DictUiUtils.showSelectDialog(context, LocalDictLib.CODE_SYS_OPER_TYPE,
                            (value) {
                          searchVm.setSelectBusinessType(value);
                        });
                      },
                      decoration: MySelectDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oper_business_type,
                          hintText: S.current.app_label_please_choose,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqSelector<LogOperSearchVm, String?>(
                              builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixBySelectVal(value, onPressed: () {
                              searchVm.setSelectBusinessType(null);
                            });
                          }, selector: (context, vm) {
                            return searchVm.currentSearch.businessTypeName;
                          })),
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

///操作日志数据VmSub
class SysOperLogListDataVmSub extends FastBaseListDataPageVmSub<SysOperLog> with CancelTokenAssist {
  SysOperLog currentSearch = SysOperLog();

  void Function(SysOperLog data)? onSuffixClick;

  SysOperLogListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysOperLog>> intensifyEntity = await SysOperLogRepository.list(
                loadMoreFormat.offset, loadMoreFormat.size, currentSearch, defCancelToken)
            .asStream()
            .single;
        DataWrapper<PageModel<SysOperLog>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      pushNamed(SysOperLogDetailsPage.routeName, arguments: {ConstantSys.KEY_SYS_LOG: data});
    });
  }

  //删除日志
  void onDelete(SysOperLog itemData) {
    showLoading(text: S.current.label_delete_ing);
    SysOperLogRepository.delete(defCancelToken, id: itemData.operId).then((value) {
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
