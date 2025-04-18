import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'image_source_bottom_sheet.dart';

/// Field for picking image(s) from Gallery or Camera.
///
/// Field value is a list of objects.
///
/// the widget can internally handle displaying objects of type [XFile],[Uint8List],[String] (for an image url),[ImageProvider] (for any flutter image), [Widget] (for any widget)
/// and appends [XFile] to the list for picked images.
///
/// if you want to use a different object (e.g. a class from the backend that has imageId and imageUrl)
/// you need to implement [displayCustomType]
class FormBuilderSingleImagePicker extends FormBuilderFieldDecoration<dynamic> {
  /// set to true to insert an [InputDecorator] which displays labels, borders, etc...
  ///
  /// when [maxImages] == 1, it's better to set this to false
  final bool showDecoration;

  /// the width of image previews, also see [previewAutoSizeWidth]
  final double previewWidth;

  /// the height of image previews
  final double previewHeight;

  /// margins between image previews
  final EdgeInsetsGeometry? previewMargin;

  /// May be supplied for a fully custom display of the image preview
  final Widget Function(BuildContext, Widget child)? previewBuilder;

  /// placeholder image displayed when picking a new image
  final ImageProvider placeholderImage;

  /// 错误图片占位符
  final ImageErrorWidgetBuilder? imageErrorBuilder;

  /// Field icon
  final IconData? icon;

  /// Field icon color
  final Color? iconColor;

  /// Field background color
  final Color? backgroundColor;

  /// Optional maximum height of image; see [ImagePicker].
  final double? maxHeight;

  /// Optional maximum width of image; see [ImagePicker].
  final double? maxWidth;

  /// The imageQuality argument modifies the quality of the image, ranging from
  /// 0-100 where 100 is the original/max quality. If imageQuality is null, the
  /// image with the original quality will be returned. See [ImagePicker].
  final int? imageQuality;

  /// Use preferredCameraDevice to specify the camera to use when the source is
  /// `ImageSource.camera`. The preferredCameraDevice is ignored when source is
  /// `ImageSource.gallery`. It is also ignored if the chosen camera is not
  /// supported on the device. Defaults to `CameraDevice.rear`. See [ImagePicker].
  final CameraDevice preferredCameraDevice;

  /// use this to get an image from a custom object to either [Uint8List] or [XFile] or [String] (url) or [ImageProvider]
  ///
  /// ```dart
  /// (obj) => obj is MyApiFileClass ? obj.imageUrl : obj;
  /// ```
  final dynamic Function(dynamic obj)? displayCustomType;

  final void Function(Image)? onImage;

  final Widget Function(BuildContext context, Widget displayImage)? transformImageWidget;

  /// Icon for camera option on bottom sheet
  final Widget cameraIcon;

  /// Icon for gallery option on bottom sheet
  final Widget galleryIcon;

  /// Label for camera option on bottom sheet
  final Widget cameraLabel;

  /// Label for gallery option on bottom sheet
  final Widget galleryLabel;
  final EdgeInsets bottomSheetPadding;
  final bool preventPop;

  /// fit for each image
  final BoxFit fit;

  /// The sources available to pick from.
  /// Either [ImageSourceOption.gallery], [ImageSourceOption.camera] or both.
  final List<ImageSourceOption> availableImageSources;

  ///A callback that returns a  pickup options
  ///ListTile(inside Wrap) by Default
  ///use optionsBuilder to return a widget of your choice
  final ValueChanged<ImageSourceBottomSheet>? onTap;

  /// use this callback if you want custom view for options
  /// call cameraPicker() to picks image from camera
  /// call galleryPicker() to picks image from gallery
  final Widget Function(FutureVoidCallBack cameraPicker, FutureVoidCallBack galleryPicker)?
      optionsBuilder;

  final WidgetBuilder? loadingWidget;

  ///选择图片
  final Future<XFile?> Function(XFile? image)? onImageSelect;

  FormBuilderSingleImagePicker({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.decoration = const InputDecoration(),
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    this.loadingWidget,
    this.transformImageWidget,
    this.showDecoration = true,
    this.previewBuilder,
    this.fit = BoxFit.cover,
    this.preventPop = false,
    this.displayCustomType,
    this.previewWidth = 96,
    this.previewHeight = 96,
    this.previewMargin,
    required this.placeholderImage,
    this.imageErrorBuilder,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.maxHeight,
    this.maxWidth,
    this.imageQuality,
    this.preferredCameraDevice = CameraDevice.rear,
    this.onImage,
    this.cameraIcon = const Icon(Icons.camera_enhance),
    this.galleryIcon = const Icon(Icons.image),
    this.cameraLabel = const Text('Camera'),
    this.galleryLabel = const Text('Gallery'),
    this.bottomSheetPadding = EdgeInsets.zero,
    this.onTap,
    this.optionsBuilder,
    this.availableImageSources = const [
      ImageSourceOption.camera,
      ImageSourceOption.gallery,
    ],
    this.onImageSelect,
  }) : super(
          builder: (FormFieldState<dynamic> field) {
            final state = field as FormBuilderImagePickerState;
            final value = state.value;

            //图片构建方法
            Widget itemBuilder(BuildContext context, dynamic value) {
              bool checkIfItemIsCustomType(dynamic e) => !(e == null ||
                  e is XFile ||
                  e is String ||
                  e is Uint8List ||
                  e is ImageProvider ||
                  e is Widget);

              final itemCustomType = checkIfItemIsCustomType(value);
              var displayItem = value;
              if (itemCustomType && displayCustomType != null) {
                displayItem = displayCustomType(value);
              }
              //类型没处理
              assert(
                !checkIfItemIsCustomType(displayItem),
                'Display item must be of type [Uint8List], [XFile], [String] (url), [ImageProvider] or [Widget]. '
                'Consider using displayCustomType to handle the type: ${displayItem.runtimeType}',
              );
              final displayWidget = displayItem == null
                  ? Image(
                      image: placeholderImage, width: previewWidth, height: previewHeight, fit: fit)
                  : displayItem is Widget
                      ? displayItem
                      : displayItem is ImageProvider
                          ? Image(
                              image: displayItem,
                              width: previewWidth,
                              height: previewHeight,
                              fit: fit)
                          : displayItem is Uint8List
                              ? Image.memory(displayItem,
                                  width: previewWidth, height: previewWidth, fit: fit)
                              : displayItem is String
                                  ? CachedNetworkImage(
                                      imageUrl: displayItem,
                                      fit: fit,
                                      width: previewWidth,
                                      height: previewHeight,
                                      placeholder: (context, url) => Image(
                                          image: placeholderImage,
                                          width: previewWidth,
                                          height: previewHeight,
                                          fit: fit),
                                      errorWidget: (
                                        BuildContext context,
                                        String url,
                                        Object error,
                                      ) =>
                                          imageErrorBuilder?.call(context, error, null) ??
                                          SizedBox(width: previewWidth, height: previewHeight))
                                    /*FadeInImage(
                                      fit: fit,
                                      width: previewWidth,
                                      height: previewHeight,
                                      placeholder: placeholderImage,
                                      image: NetworkImage(displayItem),
                                      imageErrorBuilder: imageErrorBuilder)*/
                                  : XFileImage(
                                      file: displayItem,
                                      fit: fit,
                                      width: previewWidth,
                                      height: previewHeight,
                                      loadingWidget: loadingWidget,
                                    );
              return Stack(
                key: ObjectKey(value),
                children: <Widget>[
                  transformImageWidget?.call(context, displayWidget) ?? displayWidget,
                ],
              );
            }

            //如果采用预定义预览控件
            if (previewBuilder != null) {
              return Builder(builder: (context) {
                final widget = itemBuilder(context, value);
                return previewBuilder(context, widget);
              });
            }

            final child = GestureDetector(
                onTap: () async {
                  final imageSourceSheet = ImageSourceBottomSheet(
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                    preventPop: preventPop,
                    remainingImages: 1,
                    imageQuality: imageQuality,
                    preferredCameraDevice: preferredCameraDevice,
                    bottomSheetPadding: bottomSheetPadding,
                    cameraIcon: cameraIcon,
                    cameraLabel: cameraLabel,
                    galleryIcon: galleryIcon,
                    galleryLabel: galleryLabel,
                    optionsBuilder: optionsBuilder,
                    availableImageSources: availableImageSources,
                    onImageSelected: (image) {
                      state.focus();
                      //如果有监听则通过监听处理完之后获取结果
                      if (onImageSelect != null) {
                        Navigator.pop(state.context);
                        onImageSelect.call(image.first).then((imageSingle) {
                          if (imageSingle == null) {
                            return;
                          }
                          field.didChange(imageSingle);
                        });
                      } else {
                        field.didChange(image.first);
                        Navigator.pop(state.context);
                      }
                    },
                  );
                  onTap != null
                      ? onTap(imageSourceSheet)
                      : await showModalBottomSheet<void>(
                          context: state.context,
                          builder: (_) {
                            return imageSourceSheet;
                          },
                        );
                },
                child: SizedBox(
                  height: previewHeight,
                  width: previewWidth,
                  child: itemBuilder(state.context, value),
                ));
            return showDecoration
                ? InputDecorator(
                    decoration: state.decoration,
                    child: Padding(padding: const EdgeInsets.only(top: 8, bottom: 2), child: child),
                  )
                : child;
          },
        );

  @override
  FormBuilderImagePickerState createState() => FormBuilderImagePickerState();
}

class FormBuilderImagePickerState
    extends FormBuilderFieldDecorationState<FormBuilderSingleImagePicker, dynamic> {}

class XFileImage extends StatefulWidget {
  const XFileImage({
    super.key,
    required this.file,
    this.fit,
    this.width,
    this.height,
    this.loadingWidget,
  });

  final XFile file;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final WidgetBuilder? loadingWidget;

  @override
  State<XFileImage> createState() => _XFileImageState();
}

class _XFileImageState extends State<XFileImage> {
  final _memoizer = AsyncMemoizer<Uint8List>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _memoizer.runOnce(widget.file.readAsBytes),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return widget.loadingWidget?.call(context) ??
              const Center(child: CircularProgressIndicator());
        }
        return Image.memory(data, width: widget.width, height: widget.height, fit: widget.fit);
      },
    );
  }
}

extension _ListExtension<E> on List<E> {
  Iterable<R> mapIndexed<R>(R Function(int index, E element) convert) sync* {
    for (var index = 0; index < length; index++) {
      yield convert(index, this[index]);
    }
  }
}
