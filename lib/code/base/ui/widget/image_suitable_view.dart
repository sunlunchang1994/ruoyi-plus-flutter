import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

///
/// 图片大小自适应
/// @author slc
///
class ImageSuitableView extends StatelessWidget {
  final ImageProvider imageProvider;
  final Widget? placeholder;
  final double? imgWidth;
  final double? imgHeight;

  const ImageSuitableView(
      {Key? key, required this.imageProvider,
      this.placeholder,
      this.imgWidth,
      this.imgHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    ImageStream imageStream = imageProvider.resolve(const ImageConfiguration());
    late ImageStreamListener imageStreamListener;
    imageStreamListener =
        ImageStreamListener((ImageInfo image, bool synchronousCall) {
      completer.complete(image.image);
      imageStream.removeListener(imageStreamListener);
    });
    imageStream.addListener(imageStreamListener);
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder(
          future: completer.future,
          builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
            if (snapshot.hasData) {
              late double width;
              late double height;
              if (imgWidth == null && imgHeight == null) {
                width = snapshot.data!.width.toDouble();
                height = snapshot.data!.height.toDouble();
              } else if (imgWidth != null && imgHeight != null) {
                width = snapshot.data!.width.toDouble();
                height = snapshot.data!.height.toDouble();
              } else if (imgWidth != null) {
                width = (imgWidth == double.infinity
                    ? constraints.biggest.width
                    : imgWidth)!;
                double ratio = width / snapshot.data!.width;
                height = ratio * snapshot.data!.height;
              } else if (imgHeight != null) {
                height = (imgHeight == double.infinity
                    ? constraints.biggest.height
                    : imgHeight)!;
                double ratio = height / snapshot.data!.height;
                width = ratio * snapshot.data!.width;
              }
              return Image(
                  image: imageProvider,
                  width: width,
                  height: height,
                  fit: BoxFit.fill);
            } else {
              return placeholder ?? const SizedBox();
            }
          });
    });
  }
}

/*class ImageSuitableState extends State<ImageSuitableView> {
  @override
  Widget build(BuildContext context) {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    if (widget.imageSuitableType == ImageSuitableType.network) {
      ImageStream imageStream =
          widget.imageProvider.resolve(ImageConfiguration());
      late ImageStreamListener imageStreamListener;
      imageStreamListener =
          ImageStreamListener((ImageInfo image, bool synchronousCall) {
        completer.complete(image.image);
        imageStream.removeListener(imageStreamListener);
      });
    }
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder(
          future: completer.future,
          builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
            if (snapshot.hasData) {
              late double width;
              late double height;
              if (widget.imgWidth == null && widget.imgHeight == null) {
                width = snapshot.data!.width.toDouble();
                height = snapshot.data!.height.toDouble();
              } else if (widget.imgWidth != null && widget.imgHeight != null) {
                width = snapshot.data!.width.toDouble();
                height = snapshot.data!.height.toDouble();
              } else if (widget.imgWidth != null) {
                width = (widget.imgWidth == double.infinity
                    ? constraints.biggest.width
                    : widget.imgWidth)!;
                double ratio = width / snapshot.data!.width;
                height = ratio * snapshot.data!.height;
              } else if (widget.imgHeight != null) {
                height = (widget.imgHeight == double.infinity
                    ? constraints.biggest.height
                    : widget.imgHeight)!;
                double ratio = height / snapshot.data!.height;
                width = ratio * snapshot.data!.width;
              }
              if (widget.imageSuitableType == ImageSuitableType.network) {
                return Image(
                    image: widget.imageProvider, width: width, height: height);
              } else {
                return Image(
                    image: widget.imageProvider, width: width, height: height);
              }
            } else {
              return widget.placeholder ?? SizedBox();
            }
          });
    });
  }
}*/

/*

typedef AsyncImageWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, String url);

typedef AsyncImageFileWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, File file);

typedef AsyncImageMemoryWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, Uint8List bytes);

enum AsperctRaioImageType { NETWORK, FILE, ASSET, MEMORY }

///有宽高的Image
class AsperctRaioImage extends StatelessWidget {
  String url;
  File file;
  Uint8List bytes;
  final ImageProvider provider;
  AsperctRaioImageType type;
  AsyncImageWidgetBuilder<ui.Image> builder;
  AsyncImageFileWidgetBuilder<ui.Image> filebBuilder;
  AsyncImageMemoryWidgetBuilder<ui.Image> memoryBuilder;

  AsperctRaioImage.network(url, {Key? key, required this.builder})
      : provider = NetworkImage(url),
        type = AsperctRaioImageType.NETWORK,
        this.url = url;

  AsperctRaioImage.file(file, {
    Key? key,
    @required this.filebBuilder,
  })
      : provider = FileImage(file),
        type = AsperctRaioImageType.FILE,
        this.file = file;

  AsperctRaioImage.asset(name, {Key? key, required this.builder})
      : provider = AssetImage(name),
        type = AsperctRaioImageType.ASSET,
        this.url = name;

  AsperctRaioImage.memory(bytes, {Key? key, required this.memoryBuilder})
      : provider = MemoryImage(bytes),
        type = AsperctRaioImageType.MEMORY,
        this.bytes = bytes;

  @override
  Widget build(BuildContext context) {
    final ImageConfiguration config = createLocalImageConfiguration(context);
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ImageStream stream = provider.resolve(config);
    ImageStreamListener listener;
    listener = ImageStreamListener(
          (ImageInfo image, bool sync) {
        completer.complete(image.image);
        stream.removeListener(listener);
      },
      onError: (dynamic exception, StackTrace stackTrace) {
        completer.complete();
        stream.removeListener(listener);
        FlutterError.reportError(FlutterErrorDetails(
          context: ErrorDescription('image failed to precache'),
          library: 'image resource service',
          exception: exception,
          stack: stackTrace,
          silent: true,
        ));
      },
    );
    stream.addListener(listener);

    return FutureBuilder(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          if (snapshot.hasData) {
            if (type == AsperctRaioImageType.FILE) {
              return filebBuilder(context, snapshot, file);
            } else if (type == AsperctRaioImageType.MEMORY) {
              return memoryBuilder(context, snapshot, bytes);
            } else {
              return builder(context, snapshot, url);
            }
          } else {
            return Container();
          }
        });
  }
}*/
