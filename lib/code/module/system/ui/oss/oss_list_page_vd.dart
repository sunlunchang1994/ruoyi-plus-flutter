import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/page_model.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/screen_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/dimens.dart';
import 'package:flutter_slc_boxes/flutter/slc/res/styles.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/feature/bizapi/system/entity/sys_oss_vo.dart';
import 'package:ruoyi_plus_flutter/code/feature/component/attachment/utils/media_type_constant.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vm_sub.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/request_token_manager.dart';
import 'package:ruoyi_plus_flutter/code/module/system/ui/oss/oss_details_page.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../res/dimens.dart';
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
import '../../config/constant_sys.dart';
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
          return getDataListItem(themeData, listVmSub, index, listItem,
              buildTrailing: buildTrailing);
        },
        separatorBuilder: (context, index) {
          return SlcStyles.tidyUpStyle.getDefDividerByTheme(themeData);
        });
  }

  static Widget getDataListItem(ThemeData themeData, ListenerItemClick<dynamic> listenerItemClick,
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
                    width: AppDimens.sysItemOssImgSize,
                    height: AppDimens.sysItemOssImgSize,
                    imageUrl: listItem.url ?? "",
                    placeholder: (context, url) {
                      return Image.asset("assets/images/slc/ic_loading.png",
                          width: AppDimens.sysItemOssImgSize, height: AppDimens.sysItemOssImgSize);
                    },
                    errorWidget: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Image.asset("assets/images/mp/slc_mp_ic_image.png",
                          width: AppDimens.sysItemOssImgSize, height: AppDimens.sysItemOssImgSize);
                    }));
          } else {
            return Image(
                image: AssetImage(MediaTypeConstant.getIconByMediaType(mediaType)),
                width: AppDimens.sysItemOssImgSize,
                height: AppDimens.sysItemOssImgSize);
          }
        }.call(),
        trailing: buildTrailing?.call(listItem),
        visualDensity: VisualDensity.compact,
        onTap: () {
          listenerItemClick.onItemClick(index, listItem);
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
                          style: SlcStyles.tidyUpStyle.getTitleTextStyle(themeData))),
                  SlcStyles.getSizedBox(height: SlcDimens.appDimens16),
                  MyFormBuilderTextField(
                      name: "fileName",
                      initialValue: listVmSub.currentSearch.fileName,
                      decoration: MyInputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: S.current.sys_label_oss_file_name,
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
                      onChanged: (value) {
                        listVmSub.currentSearch.originalName = value;
                        listVmSub.notifyListeners();
                      },
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
                      onChanged: (value) {
                        listVmSub.currentSearch.fileSuffix = value;
                        listVmSub.notifyListeners();
                      },
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
                      onChanged: (value) {
                        listVmSub.currentSearch.service = value;
                        listVmSub.notifyListeners();
                      },
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
class OssListDataVmSub extends FastBaseListDataPageVmSub<SysOssVo> with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  SysOssVo _currentSysOssSearch = SysOssVo();

  SysOssVo get currentSearch => _currentSysOssSearch;

  void Function(SysOssVo data)? onSuffixClick;

  OssListDataVmSub() {
    //设置刷新方法主体
    setLoadData((loadMoreFormat) async {
      try {
        IntensifyEntity<PageModel<SysOssVo>> intensifyEntity = await SysOssRepository.list(
                loadMoreFormat.getOffset(), loadMoreFormat.getSize(), currentSearch, defCancelToken)
            .asStream()
            .single;
        DataWrapper<PageModel<SysOssVo>> dataWrapper =
            DataTransformUtils.entity2LDWrapper(intensifyEntity);
        return dataWrapper;
      } catch (e) {
        ResultEntity resultEntity = BaseDio.getError(e);
        return DataWrapper.createFailed(code: resultEntity.code, msg: resultEntity.msg);
      }
    });
    //设置点击item事件主体
    setItemClick((index, data) {
      pushNamed(OssDetailsPage.routeName, arguments: {ConstantSys.KEY_SYS_OSS: data});
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
