import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fast/gen/fast_l10n.dart' as fast_l10n;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:boxes_flutter/flutter/slc/adapter/select_box.dart';
import 'package:boxes_flutter/flutter/slc/common/text_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:base/base/ui/app_mvvm.dart';
import 'package:fast/fast/provider/fast_select.dart';
import 'package:fast/fast/utils/widget_utils.dart';
import 'package:fast/fast/vd/page_data_vd.dart';

import 'package:base/base/api/base_dio.dart';
import 'package:base/base/api/result_entity.dart';
import 'package:base/base/ui/utils/fast_dialog_utils.dart';
import 'package:base/gen/base_l10n.dart' as base_l10n;
import 'package:bizapi/system/entity/sys_oss_upload_vo.dart';
import 'package:bizapi/system/entity/sys_oss_vo.dart';
import 'package:bizapi/system/repository/remote/pub_oss_api.dart';
import 'package:bizapi/user/vm/user_share_vm.dart';
import 'package:component/component/attachment/utils/media_type_constant.dart';
import 'package:fast/fast/permission/permission_compat.dart';
import 'package:fast/fast/utils/app_toast.dart';
import 'package:system/gen/sys_l10n.dart';
import 'package:system/system/repository/remote/sys_oss_api.dart';
import 'config/oss_config_list_browser_page.dart';
import 'oss_list_page_vd.dart';

///
/// @author slc
/// Oss列表
class OssListBrowserPage extends AppBaseStatelessWidget<_OssListBrowserVm> {
  static const String routeName = '/system/oss';
  final String title;

  OssListBrowserPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _OssListBrowserVm(),
        builder: (context, child) {
          ThemeData themeData = Theme.of(context);
          registerEvent(context);
          getVm().initVm();
          return PopScope(
              canPop: false,
              onPopInvokedWithResult: (canPop, result) {
                if (canPop) {
                  return;
                }
                if (getVm().listVmSub.selectModelIsRun) {
                  getVm().listVmSub.selectModelIsRun = false;
                  return;
                }
                Navigator.pop(context);
              },
              child: Scaffold(
                  appBar: AppBar(
                      leading:
                          NqSelector<_OssListBrowserVm, bool>(builder: (context, value, child) {
                        return WidgetUtils.getAnimCrossFade(const CloseButton(), const BackButton(),
                            showOne: value);
                      }, selector: (context, vm) {
                        return vm.listVmSub.selectModelIsRun;
                      }),
                      title: Text(title),
                      actions: [
                        NqSelector<_OssListBrowserVm, bool>(builder: (context, value, child) {
                          return AnimatedSize(
                              duration: WidgetUtils.adminDurationNormal,
                              child: Row(
                                children: [
                                  ...() {
                                    List<Widget> actions = [];
                                    if (value) {
                                      actions
                                          .addAll(WidgetUtils.getDeleteFamilyAction(onDelete: () {
                                        getVm().onDelete(confirmHandler: (nameList) {
                                          return FastDialogUtils.showDelConfirmDialog(context,
                                              contentText: TextUtil.format(
                                                  S.current.sys_label_oss_del_prompt,
                                                  [nameList.join(TextUtil.comma)]));
                                        });
                                      }, onSelectAll: () {
                                        getVm().listVmSub.onSelectAll(true);
                                      }, onDeselect: () {
                                        getVm().listVmSub.onSelectAll(false);
                                      }));
                                    } else {
                                      actions.add(Builder(builder: (context) {
                                        return IconButton(
                                          icon: const Icon(Icons.search),
                                          onPressed: () {
                                            WidgetUtils.autoHandlerSearchDrawer(context);
                                          },
                                        );
                                      }));
                                      if (UserShareVm().hasPermiAny(["system:ossConfig:list"])) {
                                        actions.add(PopupMenuButton<String>(itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                                value: OssConfigListBrowserPage.routeName,
                                                child: Text(S.current.sys_label_oss_config_name))
                                          ];
                                        }, onSelected: (value) {
                                          getVm().pushNamed(OssConfigListBrowserPage.routeName);
                                        }));
                                      }
                                    }
                                    return actions;
                                  }.call()
                                ],
                              ));
                        }, selector: (context, vm) {
                          return vm.listVmSub.selectModelIsRun;
                        })
                      ]),
                  endDrawer: OssListPageWidget.getSearchEndDrawer<_OssListBrowserVm>(
                      context, themeData, getVm().listVmSub),
                  floatingActionButton: UserShareVm().widgetWithPermiAny(["system:oss:add"], () {
                    return NqSelector<_OssListBrowserVm, bool>(builder: (context, value, child) {
                      return WidgetUtils.getAnimVisibility(
                          !value,
                          FloatingActionButton(
                              child: Icon(Icons.add),
                              onPressed: () {
                                showSelectFileDialog(context);
                              }));
                    }, selector: (context, vm) {
                      return vm.listVmSub.selectModelIsRun;
                    });
                  }),
                  body: PageDataVd(getVm().listVmSub, getVm(),
                      refreshOnStart: true,
                      child: NqSelector<_OssListBrowserVm, int>(builder: (context, vm, child) {
                        return OssListPageWidget.getDataListWidget(themeData, getVm().listVmSub);
                      }, selector: (context, vm) {
                        return vm.listVmSub.shouldSetState.version;
                      }))));
        });
  }

  void showSelectFileDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        clipBehavior: Clip.hardEdge,
        builder: (context) {
          return Wrap(children: [
            ListTile(
              title: Text(base_l10n.BaseS.current.ab_label_photograph),
              onTap: () {
                Navigator.pop(context);
                getVm().onSelectCamera();
              },
            ),
            ListTile(
              title: Text(base_l10n.BaseS.current.ab_label_photo_album),
              onTap: () {
                Navigator.pop(context);
                getVm().onSelectImg();
              },
            ),
            ListTile(
              title: Text(base_l10n.BaseS.current.ab_label_select_file),
              onTap: () {
                Navigator.pop(context);
                getVm().onSelectFile();
              },
            ),
          ]);
        });
  }
}

class _OssListBrowserVm extends AppBaseVm {
  late OssListDataVmSub listVmSub;

  _OssListBrowserVm() {
    listVmSub = OssListDataVmSub();
    listVmSub.enableSelectModel = true;
    listVmSub.onSuffixClick = (itemData) {
      /*pushNamed(NoticeAddEditPage.routeName,
          arguments: {ConstantSys.KEY_SYS_NOTICE: itemData}).then((result) {
        if (result != null) {
          //更新列表
          listVmSub.sendRefreshEvent();
        }
      });*/
    };
  }

  void initVm() {
    registerVmSub(listVmSub);
  }

  ///添加Oss事件
  void onAddItem() {
    /*pushNamed(NoticeAddEditPage.routeName).then((result) {
      if (result != null) {
        listVmSub.sendRefreshEvent();
      }
    });*/
  }

  void onSelectCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 80,
    );
    if (pickedFile == null) {
      return;
    }
    _uploadSelectByPath(pickedFile.path);
  }

  void checkStoragePermission() async {
    // Web 平台不需要权限检查
    if (kIsWeb) {
      return;
    }
    final status = await PermissionCompat.requestStorage;
    if (!status.isGranted) {
      AppToastUtil.showToast(msg: fast_l10n.FastS.current.label_permission_file_picker_hint);
      return;
    }
  }

  void onSelectImg() async {
    // 请求存储权限
    checkStoragePermission();
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
      return;
    }

    // Web 平台和移动平台处理方式不同
    MultipartFile multipartFile;
    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes();
      multipartFile = MultipartFile.fromBytes(
        bytes,
        filename: pickedFile.name,
      );
    } else {
      multipartFile = await MultipartFile.fromFile(
        pickedFile.path,
        filename: pickedFile.name,
      );
    }
    _uploadFile(multipartFile);
  }

  void onSelectFile() async {
    // 请求存储权限
    checkStoragePermission();
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: MediaTypeConstant.getAllowedExtensions());
    if (filePickerResult == null || filePickerResult.files.isEmpty) {
      return;
    }

    final pickedFile = filePickerResult.files.first;
    MultipartFile multipartFile;

    // Web 平台和移动端处理文件的方式不同
    if (kIsWeb) {
      // Web 平台使用 bytes
      if (pickedFile.bytes == null) {
        AppToastUtil.showToast(msg: fast_l10n.FastS.current.label_file_upload_by_file_failed);
        return;
      }
      multipartFile = MultipartFile.fromBytes(
        pickedFile.bytes!,
        filename: pickedFile.name,
      );
    } else {
      // 移动端使用文件路径
      if (filePickerResult.paths.isEmpty || filePickerResult.paths.first == null) {
        return;
      }
      String filePath = filePickerResult.paths.first!;
      multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: pickedFile.name,
      );
    }
    _uploadFile(multipartFile);
  }

  void _uploadSelectByPath(String path) async {
    // 兼容旧代码，将路径转换为 MultipartFile
    final multipartFile = await MultipartFile.fromFile(path);
    _uploadFile(multipartFile);
  }

  void _uploadFile(MultipartFile file) {
    showLoading(text: fast_l10n.FastS.current.label_file_are_uploading);
    PubOssRepository.upload(file).then((IntensifyEntity<SysOssUploadVo> value) {
      dismissLoading();
      listVmSub.sendRefreshEvent();
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: fast_l10n.FastS.current.label_file_upload_by_file_failed,
            onError: (error) {
              dismissLoading();
            }));
  }

  //删除事件
  void onDelete({Future<bool?> Function(List<String>)? confirmHandler, List<BigInt>? idList}) {
    if (idList == null) {
      List<SysOssVo> selectList = SelectUtils.getSelect(listVmSub.dataList) ?? [];
      if (selectList.isEmpty) {
        AppToastUtil.showToast(msg: S.current.sys_label_oss_del_select_empty);
        return;
      }
      List<String> nameList = selectList.map<String>((item) => item.originalName!).toList();
      List<BigInt> idList = selectList.map<BigInt>((item) => item.ossId!).toList();
      confirmHandler?.call(nameList).then((value) {
        if (value == true) {
          onDelete(idList: idList);
        }
      });
      return;
    }

    //删除
    showLoading(text: fast_l10n.FastS.current.label_delete_ing);
    SysOssRepository.delete(listVmSub.defCancelToken, ids: idList).then((value) {
      dismissLoading();
      AppToastUtil.showToast(msg: fast_l10n.FastS.current.label_delete_success);
      listVmSub.sendRefreshEvent();
    },
        onError: BaseDio.errProxyFunc(
            defErrMsg: fast_l10n.FastS.current.label_delete_failed,
            onError: (error) {
              dismissLoading();
            }));
  }
}
