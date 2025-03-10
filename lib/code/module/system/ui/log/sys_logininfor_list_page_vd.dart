import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/dict/utils/dict_ui_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_logininfor.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/log/sys_log_page.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../../res/styles.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/bizapi/system/repository/local/local_dict_lib.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import 'package:dio/dio.dart';

import '../../../../lib/fast/widget/form/fast_form_builder_text_field.dart';
import '../../../../lib/fast/widget/form/input_decoration_utils.dart';
import '../../repository/remote/sys_logininfor_api.dart';

///@author slc
///登录日志列表
class SysLogininforListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(
      ThemeData themeData, LogininforListDataVmSub listVmSub) {
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
          return getDataListItem(themeData, listVmSub, index, listItem);
        },
        separatorBuilder: (context, index) {
          return SlcStyles.tidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
    ThemeData themeData,
    ListenerItemClick<dynamic> listenerItemClick,
    int index,
    SysLogininfor listItem,
  ) {
    Color statusColor = DictUiUtils.getDictStyle(LocalDictLib.CODE_SYS_COMMON_STATUS, listItem.status);
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
            SlcStyles.getSizedBox(width: SlcDimens.appDimens16)
          ],
        ),
        subtitle: Padding(
            padding: EdgeInsets.only(right: SlcDimens.appDimens16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "${listItem.ipaddr} / ${listItem.loginLocation} / ${listItem.os} / ${listItem.browser}",
                    softWrap: true),
                Text(listItem.loginTime ?? "--"),
              ],
            )),
        visualDensity: VisualDensity.compact,
        //根据card规则实现
        onTap: () {
          listenerItemClick.onItemClick(index, listItem);
          //getVm().nextByDept(listItem);
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
                          style: SlcStyles.tidyUpStyle.getTitleTextStyle(themeData))),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
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
                            return InputDecUtils.autoClearSuffixByInputVal(
                                value,
                                formOperate: searchVm.formOperate,
                                formFieldName: "ipaddr");
                          }, selector: (context, vm) {
                            return searchVm.currentSearch.ipaddr;
                          })),
                      onChanged: (value) {
                        searchVm.currentSearch.ipaddr = value;
                        searchVm.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
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
                            return InputDecUtils.autoClearSuffixByInputVal(
                                value,
                                formOperate: searchVm.formOperate,
                                formFieldName: "userName");
                          }, selector: (context, vm) {
                            return searchVm.currentSearch.userName;
                          })),
                      onChanged: (value) {
                        searchVm.currentSearch.userName = value;
                        searchVm.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderSelect(
                      name: "statusName",
                      initialValue: searchVm.currentSearch.statusName,
                      onTap: () {
                        DictUiUtils.showSelectDialog(
                            context, LocalDictLib.CODE_SYS_COMMON_STATUS,
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
                            return InputDecUtils.autoClearSuffixBySelectVal(
                                value, onPressed: () {
                              searchVm.setSelectStatus(null);
                            });
                          }, selector: (context, vm) {
                            return searchVm.currentSearch.statusName;
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
                                  searchVm.onResetSearch();
                                },
                                child: Text(S.current.action_reset))),
                        SlcStyles.getSizedBox(width: SlcDimens.appDimens16),
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
class LogininforListDataVmSub extends FastBaseListDataPageVmSub<SysLogininfor> {
  final CancelToken cancelToken = CancelToken();

  SysLogininfor currentSearch = SysLogininfor();

  void Function(SysLogininfor data)? onSuffixClick;

  LogininforListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysLogininfor>> intensifyEntity =
            await SysLogininforRepository.list(loadMoreFormat.getOffset(),
                    loadMoreFormat.getSize(), currentSearch, cancelToken)
                .asStream()
                .single;
        DataWrapper<PageModel<SysLogininfor>> dataWrapper =
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
      /*pushNamed(NoticeAddEditPage.routeName,
          arguments: {ConstantSys.KEY_SYS_NOTICE: data}).then((result) {
        if (result != null) {
          //更新列表
          sendRefreshEvent();
        }
      });*/
    });
  }
}
