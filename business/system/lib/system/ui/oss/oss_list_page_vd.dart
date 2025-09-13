import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast/gen/fast_l10n.dart';
import 'package:fast/package_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:boxes_flutter/flutter/slc/adapter/page_model.dart';
import 'package:boxes_flutter/flutter/slc/common/screen_util.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_extension.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_util.dart';
import 'package:provider/provider.dart';
import 'package:bizapi/system/entity/sys_oss_vo.dart';
import 'package:component/component/attachment/utils/media_type_constant.dart';
import 'package:component/gen/assets.gen.dart' as ComponentAssets;
import 'package:component/package_component_info.dart';
import 'package:fast/fast/vd/page_data_vm_sub.dart';
import 'package:fast/fast/vd/request_token_manager.dart';
import 'package:fast/gen/assets.gen.dart' as FastAssets;
import 'package:system/gen/sys_l10n.dart';
import 'package:system/res/dimens.dart';
import 'package:system/system/config/constant_sys.dart';
import 'package:system/system/repository/remote/sys_oss_api.dart';
import 'package:system/system/ui/oss/oss_details_page.dart';

import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/repository/remote/data_transform_utils.dart';
import 'package:base/base/vm/global_vm.dart';
import 'package:fast/fast/provider/fast_select.dart';
import 'package:fast/fast/utils/widget_utils.dart';
import 'package:fast/fast/vd/list_data_component.dart';
import 'package:fast/fast/vd/refresh/content_empty.dart';

import 'package:form_extra/form/fast_form_builder_text_field.dart';
import 'package:form_extra/form/form_operate_with_provider.dart';
import 'package:form_extra/form/input_decoration_utils.dart';
import 'package:bizapi/user/vm/user_share_vm.dart';

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
          return getDataListItem(themeData, listVmSub, index, listItem,
              buildTrailing: buildTrailing);
        },
        separatorBuilder: (context, index) {
          return themeData.slcTidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(ThemeData themeData, ListenerItemSelect<dynamic> listenerItemSelect,
      int index, SysOssVo listItem,
      {Widget? Function(SysOssVo currentItem)? buildTrailing}) {
    return ListTile(
        contentPadding: EdgeInsets.only(left: SlcDimens.appDimens16),
        title: Text(listItem.originalName!),
        subtitle: Padding(
            padding: EdgeInsets.only(right: SlcDimens.appDimens16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /*Text(
                listItem.fileName ?? "",
                softWrap: true,
              ),*/
              Text("${listItem.createByName} / ${listItem.service}"),
            ])),
        leading: () {
          MediaType mediaType = MediaTypeConstant.getMediaType(listItem.fileSuffix);
          if (mediaType == MediaType.img) {
            return ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(SlcDimens.appDimens6)),
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: SysDimens.sysItemOssImgSize,
                    height: SysDimens.sysItemOssImgSize,
                    imageUrl: listItem.url ?? "",
                    useOldImageOnUrlChange: true,
                    placeholder: (context, url) {
                      return Image(
                          image: FastAssets.Assets.fast.images.icLoadingPng
                              .provider(package: FastPkgInfo.packageName),
                          width: SysDimens.sysItemOssImgSize,
                          height: SysDimens.sysItemOssImgSize);
                    },
                    errorWidget: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return ComponentAssets.Assets.images.mp.slcMpIcImage.image(
                          package: ComponentPkgInfo.packageName,
                          width: SysDimens.sysItemOssImgSize,
                          height: SysDimens.sysItemOssImgSize);
                    }));
          } else {
            return Image(
                image: AssetImage(MediaTypeConstant.getIconByMediaType(mediaType)),
                width: SysDimens.sysItemOssImgSize,
                height: SysDimens.sysItemOssImgSize);
          }
        }.call(),
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
          UserShareVm().execPermiAny(
              ["system:oss:remove"], () => listenerItemSelect.onItemLongClick(index, listItem));
        });
  }

  ///搜索侧滑栏视图
  static Widget getSearchEndDrawer<A>(
      BuildContext context, ThemeData themeData, OssListDataVmSub listVmSub,
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
                      child: Text(S.current.sys_label_oss_search,
                          style: themeData.slcTidyUpStyle.getTitleTextStyle(themeData))),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "fileName",
                      initialValue: listVmSub.currentSearch.fileName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oss_file_name,
                          hintText: FastS.current.app_label_please_input,
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
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "originalName",
                      initialValue: listVmSub.currentSearch.originalName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oss_original_name,
                          hintText: FastS.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "originalName");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.originalName;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.originalName = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "fileSuffix",
                      initialValue: listVmSub.currentSearch.fileSuffix,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oss_file_suffix,
                          hintText: FastS.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "fileSuffix");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.fileSuffix;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.fileSuffix = value;
                        listVmSub.notifyListeners();
                      },
                      textInputAction: TextInputAction.next),
                  ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "service",
                      initialValue: listVmSub.currentSearch.service,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oss_service,
                          hintText: FastS.current.app_label_please_input,
                          border: const UnderlineInputBorder(),
                          suffixIcon: NqNullSelector<A, String?>(builder: (context, value, child) {
                            return InputDecUtils.autoClearSuffixByInputVal(value,
                                formOperate: listVmSub.formOperate, formFieldName: "service");
                          }, selector: (context, vm) {
                            return listVmSub.currentSearch.service;
                          })),
                      onChanged: (value) {
                        listVmSub.currentSearch.service = value;
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
                                child: Text(FastS.current.action_reset))),
                        ThemeUtil.getSizedBox(width: SlcDimens.appDimens16),
                        Expanded(
                            child: FilledButton(
                                onPressed: () {
                                  WidgetUtils.autoHandlerSearchDrawer(context);
                                  listVmSub.onSearch();
                                },
                                child: Text(FastS.current.action_search)))
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
class OssListDataVmSub extends FastBasePageDataVmSub<SysOssVo> with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysOssVo _currentSysOssSearch = SysOssVo();

  SysOssVo get currentSearch => _currentSysOssSearch;

  void Function(SysOssVo data)? onSuffixClick;

  OssListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysOssVo>> intensifyEntity = await SysOssRepository.list(
                loadMoreFormat.offset, loadMoreFormat.size, currentSearch, defCancelToken)
            .asStream()
            .single;
        DataWrapper<PageModel<SysOssVo>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.handlerErr(e, showToast: false);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      pushNamed(OssDetailsPage.routeName, arguments: {ConstantSys.KEY_SYS_OSS: data})
          .then((result) {
        if (result != null) {
          sendRefreshEvent();
        }
      });
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
