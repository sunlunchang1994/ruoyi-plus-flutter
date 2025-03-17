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
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_oss_vo.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/tenant/tenant_add_edit_page.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../base/repository/remote/data_transform_utils.dart';
import '../../../../feature/bizapi/system/entity/sys_tenant.dart';
import '../../../../lib/fast/provider/fast_select.dart';
import '../../../../lib/fast/utils/widget_utils.dart';
import '../../../../lib/fast/vd/list_data_component.dart';
import '../../../../lib/fast/vd/refresh/content_empty.dart';
import '../../../../lib/fast/vd/request_token_manager.dart';
import '../../../../lib/form/fast_form_builder_text_field.dart';
import '../../../../lib/form/form_operate_with_provider.dart';
import '../../../../lib/form/input_decoration_utils.dart';
import 'package:dio/dio.dart';

import '../../config/constant_sys.dart';
import '../../repository/remote/sys_tenant_api.dart';

///@author slc
///租户管理
class TenantListPageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, TenantListDataVmSub listVmSub,
      {Widget? Function(SysTenant currentItem)? buildTrailing}) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysTenant listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub, index, listItem,
              buildTrailing: buildTrailing);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(ThemeData themeData, ListenerItemSelect<dynamic> listenerItemSelect,
      int index, SysTenant listItem,
      {Widget? Function(SysTenant currentItem)? buildTrailing}) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text("${listItem.tenantId} / ${listItem.companyName}"),
        subtitle: Text(TextUtil.isEmpty(listItem.expireTime)
            ? "-"
            : listItem.expireTime! + S.current.sys_label_sys_tenant_x_expire_time),
        visualDensity: VisualDensity.compact,
        onTap: () {
          listenerItemSelect.onItemClick(index, listItem);
        });
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer<A>(
      BuildContext context, ThemeData themeData, TenantListDataVmSub listVmSub,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<SysTenant>(builder: (context, value, child) {
          return FormBuilder(
              key: listVmSub.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.sys_label_sys_tenant_search,
                          style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData))),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "tenantId",
                      initialValue: listVmSub.currentSearch.tenantId,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_sys_tenant_id,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "tenantId");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.tenantId;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.tenantId = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "contactUserName",
                      initialValue: listVmSub.currentSearch.contactUserName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_sys_tenant_contact_user_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate,
                                formFieldName: "contactUserName");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.contactUserName;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.contactUserName = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "contactPhone",
                      initialValue: listVmSub.currentSearch.contactPhone,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_sys_tenant_contact_phone,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "contactPhone");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.contactPhone;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.contactPhone = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "companyName",
                      initialValue: listVmSub.currentSearch.companyName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_sys_tenant_company_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "companyName");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.companyName;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.companyName = value;
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

///租户管理VmSub
class TenantListDataVmSub extends FastBaseListDataPageVmSub<SysTenant> with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysTenant _currentSearch = SysTenant();

  SysTenant get currentSearch => _currentSearch;

  void Function(SysOssVo data)? onSuffixClick;

  TenantListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysTenant>> intensifyEntity = await SysTenantRepository.list(
                loadMoreFormat.offset, loadMoreFormat.size, currentSearch, defCancelToken)
            .asStream()
            .single;
        DataWrapper<PageModel<SysTenant>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerError(e,showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      pushNamed(TenantAddEditPage.routeName, arguments: {ConstantSys.KEY_SYS_TENANT: data})
          .then((result) {
        if (result != null) {
          sendRefreshEvent();
        }
      });
    });
  }

  //重置
  void onResetSearch() {
    _currentSearch = SysTenant();
    formOperate.clearAll();
    notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    sendRefreshEvent();
  }
}
