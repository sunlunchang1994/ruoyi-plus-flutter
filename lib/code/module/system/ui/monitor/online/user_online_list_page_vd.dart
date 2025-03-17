import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_user_online.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../base/api/base_dio.dart';
import '../../../../../base/api/result_entity.dart';
import '../../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../../lib/fast/provider/fast_select.dart';
import '../../../../../lib/fast/utils/widget_utils.dart';
import '../../../../../lib/fast/vd/list_data_component.dart';
import '../../../../../lib/fast/vd/refresh/content_empty.dart';

import '../../../../../lib/form/fast_form_builder_text_field.dart';
import '../../../../../lib/form/form_operate_with_provider.dart';
import '../../../../../lib/form/input_decoration_utils.dart';
import '../../../repository/remote/sys_user_online_api.dart';

///@author slc
///在线用户列表
class NoticeListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, UserOnlineListDataVmSub listVmSub,
      Widget? Function(SysUserOnline currentItem) buildTrailing) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysUserOnline listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, buildTrailing, index, listItem);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(
    ThemeData themeData,
    ListenerItemSelect<dynamic> listenerItemSelect,
    Widget? Function(SysUserOnline currentItem) buildTrailing,
    int index,
    SysUserOnline listItem,
  ) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text("${listItem.userName} / ${listItem.deptName}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: () {
            List<Widget> widgets = [];
            widgets.add(Text(listItem.loginTime ?? ""));
            widgets.add(AnimatedSize(
              duration: const Duration(milliseconds: 300),
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
        trailing: buildTrailing.call(listItem),
        visualDensity: WidgetUtils.minimumDensity,
        //根据card规则实现
        onTap: () {
          listenerItemSelect.onItemClick(index, listItem);
          //getVm().nextByDept(listItem);
        });
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer<A>(
      BuildContext context, ThemeData themeData, UserOnlineListDataVmSub listVmSub,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Consumer<A>(builder: (context, value, child) {
          return FormBuilder(
              key: listVmSub.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.sys_label_notice_search_title,
                          style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData))),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "ipaddr",
                      initialValue: listVmSub.ipaddr,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_online_login_address,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "ipaddr");
                          }, selector: (context, vm) {
                            return listVmSub.ipaddr;
                          })),
                      onChanged: (value) {
                        listVmSub.ipaddr = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "userName",
                      initialValue: listVmSub.userName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_online_login_user_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "userName");
                          }, selector: (context, vm) {
                            return listVmSub.userName;
                          })),
                      onChanged: (value) {
                        listVmSub.userName = value;
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
        }));
  }
}

///在线用户数据VmSub
class UserOnlineListDataVmSub extends FastBaseListDataPageVmSub<SysUserOnline>
    with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  //显示详情
  final Map<String, bool> showDetailsStatusMap = {};

  String? ipaddr;
  String? userName;

  void Function(SysUserOnline data)? onSuffixClick;

  UserOnlineListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysUserOnline>> intensifyEntity =
            await SysUserOnlineRepository.list(
                    loadMoreFormat.offset, loadMoreFormat.size, ipaddr, userName, defCancelToken)
                .asStream()
                .map((result) {
          result.data?.getListNoNull().forEach((dataItem) {
            dataItem.showDetail = showDetailsStatusMap[dataItem.tokenId!] ?? false;
          });
          return result;
        }).single;
        DataWrapper<PageModel<SysUserOnline>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerError(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      onHandlerShowDetails(data);
    });
  }

  //重置
  void onResetSearch() {
    ipaddr = null;
    userName = null;
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }

  void onHandlerShowDetails(SysUserOnline itemData) {
    itemData.showDetail = !itemData.showDetail;
    showDetailsStatusMap[itemData.tokenId!] = itemData.showDetail;
    shouldSetState.updateVersion();
    notifyListeners();
  }
}
