import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/object_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ruoyi_plus_flutter/code/base/ui/app_mvvm.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/provider/fast_select.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/utils/widget_utils.dart';
import 'package:ruoyi_plus_flutter/code/lib/fast/vd/page_data_vd.dart';

import '../../../../../generated/l10n.dart';
import '../../../../base/api/base_dio.dart';
import '../../../../base/api/result_entity.dart';
import '../../../../feature/bizapi/system/entity/sys_oss_upload_vo.dart';
import '../../../../feature/bizapi/system/repository/remote/pub_oss_api.dart';
import '../../../../feature/component/attachment/utils/media_type_constant.dart';
import '../../../../lib/fast/permission/permission_compat.dart';
import '../../../../lib/fast/utils/app_toast.dart';
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
          return Scaffold(
              appBar: AppBar(title: Text(title), actions: [
                Builder(builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      WidgetUtils.autoHandlerSearchDrawer(context);
                    },
                  );
                }),
                PopupMenuButton<String>(itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: OssConfigListBrowserPage.routeName,
                        child: Text(S.current.sys_label_oss_config_name))
                  ];
                }, onSelected: (value) {
                  getVm().pushNamed(OssConfigListBrowserPage.routeName);
                })
              ]),
              endDrawer: OssListPageWidget.getSearchEndDrawer<_OssListBrowserVm>(
                  context, themeData, getVm().listVmSub),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    showSelectFileDialog(context);
                  }),
              body: PageDataVd(getVm().listVmSub, getVm(),
                  refreshOnStart: true,
                  child: NqSelector<_OssListBrowserVm, int>(builder: (context, vm, child) {
                    return OssListPageWidget.getDataListWidget(themeData, getVm().listVmSub);
                  }, selector: (context, vm) {
                    return vm.listVmSub.shouldSetState.version;
                  })));
        });
  }

  void showSelectFileDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        clipBehavior: Clip.hardEdge,
        builder: (context) {
          return Wrap(children: [
            ListTile(
              title: Text(S.current.app_label_photograph),
              onTap: () {
                Navigator.pop(context);
                getVm().onSelectCamera();
              },
            ),
            ListTile(
              title: Text(S.current.app_label_photo_album),
              onTap: () {
                Navigator.pop(context);
                getVm().onSelectImg();
              },
            ),
            ListTile(
              title: Text(S.current.app_label_select_file),
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
    if (Platform.isAndroid) {
      final status = await PermissionCompat.requestStorage;
      if (!status.isGranted) {
        AppToastBridge.showToast(msg: S.current.label_permission_file_picker_hint);
        return;
      }
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
    _uploadSelectByPath(pickedFile.path);
  }

  void onSelectFile() async {
    // 请求存储权限
    checkStoragePermission();
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: MediaTypeConstant.getAllowedExtensions());
    if (filePickerResult == null || ObjectUtil.isEmptyList(filePickerResult.paths)) {
      return;
    }
    _uploadSelectByPath(filePickerResult.paths.first!);
  }

  void _uploadSelectByPath(String path) {
    showLoading(text: S.current.label_file_are_uploading);
    PubOssRepository.upload(path).then((IntensifyEntity<SysOssUploadVo> value) {
      dismissLoading();
      listVmSub.sendRefreshEvent();
    }, onError: (e) {
      BaseDio.showToastByError(e,defErrMsg: S.current.label_file_upload_by_file_failed);
      dismissLoading();
    });
  }
}
