import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

import '../../../../generated/l10n.dart';

class CropImage extends StatefulWidget {
  ///图像路径
  final XFile imagePath;

  CropImage(this.imagePath, {super.key});

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
        appBar: AppBar(title: Text(S.current.app_label_image_crop)),
        body: Center(
            child: imageData == null
                ? const CircularProgressIndicator()
                : Crop(
                    image: imageData!,
                    controller: _controller,
                    onCropped: (image) {
                      // do something with cropped image data
                    })));
  }
}
