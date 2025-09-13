import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast/gen/fast_l10n.dart';
import 'package:fast/package_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:boxes_flutter/flutter/slc/common/slc_file_util.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:boxes_flutter/flutter/slc/res/dimens.dart';
import 'package:boxes_flutter/flutter/slc/res/theme_util.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:base/base/api/base_dio.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:bizapi/system/entity/sys_oss_vo.dart';
import 'package:bizapi/system/repository/remote/pub_oss_api.dart';
import 'package:component/component/attachment/repository/local/attachment_config.dart';
import 'package:component/component/attachment/utils/attachment_utils.dart';
import 'package:component/component/attachment/utils/media_type_constant.dart';
import 'package:component/gen/assets.gen.dart' as ComponentGen;
import 'package:component/package_component_info.dart';
import 'package:fast/fast/permission/permission_compat.dart';
import 'package:fast/fast/provider/fast_select.dart';
import 'package:fast/fast/utils/app_toast.dart';
import 'package:fast/fast/vd/request_token_manager.dart';
import 'package:fast/gen/assets.gen.dart' as FastGen;
import 'package:form_extra/form/fast_form_builder_text_field.dart';
import 'package:form_extra/form/form_operate_with_provider.dart';
import 'package:system/gen/sys_l10n.dart';

import 'package:base/base/ui/utils/fast_dialog_utils.dart';
import 'package:bizapi/user/vm/user_share_vm.dart';
import 'package:component/component/attachment/entity/progress.dart';
import 'package:system/res/dimens.dart';
import 'package:system/system/repository/remote/sys_oss_api.dart';

class OssDetailsPage extends AppBaseStatelessWidget<_OssAddEditVm> {
  static const String routeName = '/system/oss/details';

  final SysOssVo sysOssVo;

  OssDetailsPage(this.sysOssVo, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _OssAddEditVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm(sysOssVo);
          return Scaffold(
              appBar: AppBar(
                title: Text(S.current.sys_label_oss_details),
                actions: [
                  if (UserShareVm().hasPermiAny(["system:oss:remove"]))
                    IconButton(
                        onPressed: () {
                          FastDialogUtils.showDelConfirmDialog(context,
                                  contentText: TextUtil.format(
                                      S.current.sys_label_oss_del_prompt, [sysOssVo.originalName]))
                              .then((confirm) {
                            if (confirm == true) {
                              getVm().onDelete();
                            }
                          });
                        },
                        icon: Icon(Icons.delete_forever))
                ],
              ),
              body: KeyboardAvoider(
                  autoScroll: true,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: SlcDimens.appDimens16),
                      child: FormBuilder(
                          key: getVm().formOperate.formKey,
                          child: Column(
                            children: [
                              ThemeUtil.getSizedBox(height: SlcDimens.appDimens8),
                              FormBuilderFieldDecoration<String>(
                                  name: "fileInfo",
                                  initialValue: getVm().sysOssVo.url,
                                  decoration: MyInputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      labelText: S.current.sys_label_oss_view_file,
                                      border: const UnderlineInputBorder()),
                                  builder: (field) {
                                    var decorationState =
                                        field as FormBuilderFieldDecorationState<dynamic, String>;
                                    MediaType mediaType =
                                        MediaTypeConstant.getMediaType(getVm().sysOssVo.fileSuffix);
                                    return InputDecorator(
                                        decoration: decorationState.decoration,
                                        child: Row(children: [
                                          ...() {
                                            List<Widget> items = List.empty(growable: true);
                                            if (mediaType == MediaType.img) {
                                              items.addAll([
                                                ClipRRect(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(SlcDimens.appDimens6)),
                                                    child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        width: SysDimens.sysDetailsOssImgSize,
                                                        height: SysDimens.sysDetailsOssImgSize,
                                                        imageUrl: field.value ?? "",
                                                        placeholder: (context, url) {
                                                          return Image(
                                                              image: FastGen
                                                                  .Assets.fast.images.icLoadingPng
                                                                  .provider(
                                                                      package:
                                                                          FastPkgInfo.packageName),
                                                              width: SysDimens.sysDetailsOssImgSize,
                                                              height:
                                                                  SysDimens.sysDetailsOssImgSize);
                                                        },
                                                        errorWidget: (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return ComponentGen.Assets.images.mp.slcMpIcImage
                                                              .image(
                                                            package: ComponentPkgInfo.packageName,
                                                                  width: SysDimens
                                                                      .sysDetailsOssImgSize,
                                                                  height: SysDimens
                                                                      .sysDetailsOssImgSize);
                                                        })),
                                                Spacer()
                                              ]);
                                            } else {
                                              items.addAll([
                                                Image(
                                                    width: SlcDimens.appDimens36,
                                                    height: SlcDimens.appDimens36,
                                                    color: themeData.colorScheme.onSurfaceVariant,
                                                    image: AssetImage(
                                                        MediaTypeConstant.getIconByMediaType(
                                                            mediaType))),
                                                Expanded(
                                                    child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: SlcDimens.appDimens12),
                                                        child: Text(
                                                            getVm().sysOssVo.originalName ?? "",
                                                            overflow: TextOverflow.ellipsis)))
                                              ]);
                                            }
                                            return items;
                                          }.call(),
                                          SizedBox(
                                            width: 36,
                                            height: 36,
                                            child: Center(
                                                child: NqSelector<_OssAddEditVm, Progress>(
                                                    builder: (context, value, child) {
                                              if (value.status == DownloadStatus.waiting) {
                                                return const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 3,
                                                    ));
                                              } else if (value.status == DownloadStatus.loading) {
                                                return Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child: CircularProgressIndicator(
                                                          value: value.fractionFloat,
                                                          backgroundColor: themeData
                                                              .colorScheme.primaryContainer,
                                                          strokeWidth: 3,
                                                        )),
                                                    Text(value.fraction.toString(),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: themeData.colorScheme.primary))
                                                  ],
                                                );
                                              }
                                              if (value.status == DownloadStatus.finish) {
                                                return IconButton(
                                                    onPressed: () {
                                                      getVm().onOpenFile(value.filePath!);
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.open_in_browser,
                                                    ),
                                                    visualDensity: VisualDensity.compact);
                                              } else {
                                                return IconButton(
                                                    onPressed: () {
                                                      getVm().onDownloadFile();
                                                    },
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.download,
                                                    ),
                                                    visualDensity: VisualDensity.compact);
                                              }
                                            }, selector: (context, vm) {
                                              return vm.downloadProgress;
                                            })),
                                          )
                                        ]));
                                  }),
                              ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                              MyFormBuilderTextField(
                                name: "fileName",
                                initialValue: getVm().sysOssVo.fileName,
                                readOnly: true,
                                maxLines: 5,
                                minLines: 1,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: MyInputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.current.sys_label_oss_file_name,
                                    hintText: FastS.current.app_label_not_completed,
                                    border: const UnderlineInputBorder()),
                              ),
                              ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                              MyFormBuilderTextField(
                                name: "originalName",
                                initialValue: getVm().sysOssVo.originalName,
                                readOnly: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: MyInputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.current.sys_label_oss_original_name,
                                    hintText: FastS.current.app_label_not_completed,
                                    border: const UnderlineInputBorder()),
                              ),
                              ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                              MyFormBuilderTextField(
                                name: "fileSuffix",
                                initialValue: getVm().sysOssVo.fileSuffix,
                                readOnly: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: MyInputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.current.sys_label_oss_file_suffix,
                                    hintText: FastS.current.app_label_not_completed,
                                    border: const UnderlineInputBorder()),
                              ),
                              ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                              MyFormBuilderTextField(
                                name: "createBy",
                                initialValue: getVm().sysOssVo.createByName,
                                readOnly: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: MyInputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.current.sys_label_oss_create_by,
                                    hintText: FastS.current.app_label_not_completed,
                                    border: const UnderlineInputBorder()),
                              ),
                              ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                              MyFormBuilderTextField(
                                name: "service",
                                initialValue: getVm().sysOssVo.service,
                                readOnly: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: MyInputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.current.sys_label_oss_service,
                                    hintText: FastS.current.app_label_not_completed,
                                    border: const UnderlineInputBorder()),
                              ),
                              ThemeUtil.getSizedBox(height: SlcDimens.appDimens16),
                              MyFormBuilderTextField(
                                name: "createTime",
                                initialValue: getVm().sysOssVo.createTime,
                                readOnly: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                decoration: MyInputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    labelText: S.current.sys_label_oss_create_tile,
                                    hintText: FastS.current.app_label_not_completed,
                                    border: const UnderlineInputBorder()),
                              ),
                            ],
                          )))));
        });
  }
}

class _OssAddEditVm extends AppBaseVm with CancelTokenAssist {
  final FormOperateWithProvider formOperate = FormOperateWithProvider();

  late SysOssVo sysOssVo;

  Progress _downloadProgress = Progress();

  Progress get downloadProgress => _downloadProgress;

  void initVm(SysOssVo sysOssVo) {
    this.sysOssVo = sysOssVo;
  }

  //开始下载文件
  void onDownloadFile() async {
    // 请求存储权限
    if (Platform.isAndroid) {
      final status = await PermissionCompat.requestStorage;
      if (!status.isGranted) {
        AppToastUtil.showToast(msg: S.current.sys_label_permission_file_download_hint);
        return;
      }
    }
    //获取下载路径
    String? fileDir =
        AttachmentConfig().getDownloadPath() ?? await AttachmentUtils.buildSaveFileDir();
    if (fileDir == null) {
      if (Platform.isAndroid || Platform.isIOS) {
        AppToastUtil.showToast(msg: S.current.sys_label_get_file_download_hint);
      }
      return;
    }
    //设置选择存储下载文件的位置
    AttachmentConfig().setDownloadPath(fileDir);
    String filePath =
        "${TextUtil.addSuffixIfNot(fileDir, Platform.pathSeparator)}${sysOssVo.originalName!}";
    //问价存在
    if (SlcFileUtil.isFileExistsFromPath(filePath)) {
      //文件存在直接打开
      this._downloadProgress = Progress(filePath: filePath, status: DownloadStatus.finish);
      notifyListeners();
      onOpenFile(filePath);
      return;
    }

    //开始下载
    PubOssRepository.download(sysOssVo.ossId!.toString(), filePath, defCancelToken,
        onReceiveProgress: (progress) {
      //更新下载进度
      this._downloadProgress = progress;
      notifyListeners();
    }).then((result) {
      //下载完成
      this._downloadProgress = result;
      notifyListeners();
      //提示并打开
      AppToastUtil.showToast(msg: FastS.current.action_download_on_success);
      onOpenFile(result.filePath!);
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: FastS.current.label_file_download_failed, onError: (error) {}));
  }

  void onOpenFile(String filePath) {
    OpenFile.open(filePath);
  }

  //删除字典类型
  void onDelete() {
    showLoading(text: FastS.current.label_delete_ing);
    SysOssRepository.delete(defCancelToken, id: sysOssVo.ossId).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: FastS.current.label_delete_success);
      finish(result: true);
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: FastS.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}
