import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

import '../api/result_entity.dart';

class ImageUtils {
  static Future<ResultEntity> saveWidget2Img(GlobalKey globalKey) async {
    if (Platform.isIOS
        ? await Permission.photos.request().isGranted
        : await Permission.storage.request().isGranted) {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? _uInt8List = byteData?.buffer.asUint8List();
      if (_uInt8List != null) {
        final resultDynamic = await ImageGallerySaver.saveImage(_uInt8List);
        Map<String, dynamic> result = json.decode(json.encode(resultDynamic));
        if (result["isSuccess"]) {
          return ResultEntity(code: 0, data: result["filePath"]);
        }
      }
      return ResultEntity(code: -1);
    } else {
      /*PermissionStatus permissionStatus = await Permission.storage.request();
      if (permissionStatus.isGranted) {
        return _savePicByKey(globalKey);
      }*/
      return ResultEntity(code: -1);
    }
  }
}
