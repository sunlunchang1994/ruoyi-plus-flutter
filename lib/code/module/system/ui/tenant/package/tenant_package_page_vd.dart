import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_extension.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_oss_vo.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/list_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/system/entity/sys_tenant_package.dart';

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

import '../../../config/constant_sys.dart';
import '../../../repository/remote/sys_tenant_package_api.dart';
import 'tenant_package_add_edit_page.dart';

///@author slc
///租户套餐
class TenantPackagePageWidget {
  ///数据列表控件
  static Widget getDataListWidget(ThemeData themeData, IListDataVmSub listVmSub,
      {Widget? Function(SysTenantPackage currentItem)? buildTrailing}) {
    if (listVmSub.dataList.isEmpty) {
      return const ContentEmptyWrapper();
    }
    return ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        itemCount: listVmSub.dataList.length,
        itemBuilder: (ctx, index) {
          SysTenantPackage listItem = listVmSub.dataList[index];
          return getDataListItem(themeData, listVmSub as ListenerItemSelect, index, listItem,
              buildTrailing: buildTrailing);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(ThemeData themeData, ListenerItemSelect<dynamic> listenerItemSelect,
      int index, SysTenantPackage listItem,
      {Widget? Function(SysTenantPackage currentItem)? buildTrailing}) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.packageName!),
        trailing: WidgetUtils.getAnimCrossFade(
            Checkbox(
              value: listItem.isBoxChecked(),
              onChanged: (value) {
                listItem.boxChecked = value;
                listenerItemSelect.onItemSelect(index, listItem, value);
              },
            ),
            buildTrailing?.call(listItem) ?? ThemeUtil.getBoxStandard(),
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
      BuildContext context, ThemeData themeData, TenantPackageSearchHelper searchHelper,
      {List<Widget>? Function(String? name)? formItemSlot}) {
    return Container(
        color: themeData.colorScheme.surface,
        width: ScreenUtil.getInstance().screenWidthDpr * 0.73,
        padding: EdgeInsets.only(
            top: ScreenUtil.getInstance().statusBarHeightDpr,
            left: SlcDimens.appDimens16,
            right: SlcDimens.appDimens16,
            bottom: SlcDimens.appDimens14),
        child: Selector0<SysTenantPackage>(builder: (context, value, child) {
          return FormBuilder(
              key: searchHelper.formOperate.formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: themeData.appBarTheme.toolbarHeight,
                      child: Text(S.current.sys_label_sys_tenant_package_search,
                          style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData))),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "packageName",
                      initialValue: searchHelper.currentSearch.packageName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_sys_tenant_package_name,
                          hintText: S.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: searchHelper.formOperate,
                                formFieldName: "packageName");
                          }, selector: (context, vm) {
                            return searchHelper.currentSearch.packageName;
                          })),
                      onChanged: (value) {
                        searchHelper.currentSearch.packageName = value;
                        searchHelper.notifyListeners();
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
                                  searchHelper.onResetSearch();
                                },
                                child: Text(S.current.action_reset))),
                        ThemeUtil.getSizedBox(width: SlcDimens.appDimens16),
                        Expanded(
                            child: FilledButton(
                                onPressed: () {
                                  WidgetUtils.autoHandlerSearchDrawer(context);
                                  searchHelper.onSearch();
                                },
                                child: Text(S.current.action_search)))
                      ],
                    );
                  }))
                ],
              ));
        }, selector: (context) {
          return searchHelper.currentSearch;
        }, shouldRebuild: (oldVal, newVal) {
          return false;
        }));
  }
}

///搜索帮助类
class TenantPackageSearchHelper {
  final IListDataVmSub<dynamic> ownerVm;

  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysTenantPackage _currentSearch = SysTenantPackage();

  SysTenantPackage get currentSearch => _currentSearch;

  TenantPackageSearchHelper(this.ownerVm);

  //重置
  void onResetSearch() {
    _currentSearch = SysTenantPackage();
    formOperate.clearAll();
    ownerVm.notifyListeners();
  }

  //搜索
  void onSearch() {
    formOperate.formBuilderState?.save();
    ownerVm.sendRefreshEvent();
  }

  void notifyListeners() {
    ownerVm.notifyListeners();
  }
}

///租户套餐VmSub
class TenantPackageListDataVmSub extends FastBaseListDataPageVmSub<SysTenantPackage>
    with CancelTokenAssist {
  late TenantPackageSearchHelper tenantPackageSearchHelper;

  void Function(SysOssVo data)? onSuffixClick;

  TenantPackageListDataVmSub() {
    tenantPackageSearchHelper = TenantPackageSearchHelper(this);
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysTenantPackage>> intensifyEntity =
            await SysTenantPackageRepository.list(loadMoreFormat.offset, loadMoreFormat.size,
                    tenantPackageSearchHelper.currentSearch, defCancelToken)
                .asStream()
                .single;
        DataWrapper<PageModel<SysTenantPackage>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      pushNamed(TenantPackageAddEditPage.routeName,
          arguments: {ConstantSys.KEY_SYS_TENANT_PACKAGE: data}).then((result) {
        if (result != null) {
          sendRefreshEvent();
        }
      });
    });
  }
}

///租户套餐选择VmSub
class TenantPackageSelectVmSub extends FastBaseListDataVmSub<SysTenantPackage>
    with CancelTokenAssist {
  late TenantPackageSearchHelper tenantPackageSearchHelper;

  void Function(SysOssVo data)? onSuffixClick;

  TenantPackageSelectVmSub() {
    tenantPackageSearchHelper = TenantPackageSearchHelper(this);
    //设置刷新方法主体
    setRefresh(() async {
      try {
        IntensifyEntity<List<SysTenantPackage>> intensifyEntity =
            await SysTenantPackageRepository.selectList(
                    tenantPackageSearchHelper.currentSearch, defCancelToken)
                .asStream()
                .single;
        DataWrapper<List<SysTenantPackage>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      finish(result: data);
    });
  }
}
