import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slc_boxes/flutter/slc/common/log_util.dart';
import 'package:flutter_slc_boxes/flutter/slc/dialog/dialog_loading_vm.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ruoyi_plus_flutter/code/base/utils/slc_file_utils.dart';

import '../../../../generated/l10n.dart';

class CropImage extends StatefulWidget {
  ///图像路径
  final XFile imagePath;

  const CropImage(this.imagePath, {super.key});

  @override
  State<StatefulWidget> createState() {
    return CropState();
  }
}

class CropState extends State<CropImage> {
  Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    final _controller = CropController();
    widget.imagePath.readAsBytes().then((imageData) {
      if (this.imageData != null) {
        return;
      }
      setState(() {
        this.imageData = imageData;
      });
    });
    return Scaffold(
        appBar: AppBar(
          title: Text(S.current.app_label_image_crop),
          actions: [
            IconButton(
                onPressed: () {
                  LoadingDialog.showLoadingDialog(
                      context, barrierDismissible: false, text: S.current.label_save_ing);
                  _controller.crop();
                },
                icon: const Icon(Icons.save))
          ],
        ),
        body: Center(
            child: imageData == null
                ? const CircularProgressIndicator()
                : Crop(
                image: imageData!,
                controller: _controller,
                aspectRatio: 1.0,
                onCropped: (image) async {
                  Directory applicationCacheDirectory = await getApplicationCacheDirectory();
                  File saveCropPath = File(applicationCacheDirectory.path +
                      SlcFileUtils.getFileNameByTime(prefix: "IMG_", suffix: ".png"));
                  saveCropPath.writeAsBytesSync(image);
                  LogUtil.d(saveCropPath.path, tag: "裁剪文件保存");
                  Navigator.pop(context);
                  Navigator.pop(context,saveCropPath.path);
                  // do something with cropped image data
                })));
  }
}
