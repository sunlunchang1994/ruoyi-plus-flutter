/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/base
  $AssetsImagesBaseGen get base => const $AssetsImagesBaseGen();

  /// File path: assets/images/ic_launcher.png
  AssetGenImage get icLauncher =>
      const AssetGenImage('assets/images/ic_launcher.png');

  /// Directory path: assets/images/mp
  $AssetsImagesMpGen get mp => const $AssetsImagesMpGen();

  /// Directory path: assets/images/user
  $AssetsImagesUserGen get user => const $AssetsImagesUserGen();

  /// List of all assets
  List<AssetGenImage> get values => [icLauncher];
}

class $AssetsImagesBaseGen {
  const $AssetsImagesBaseGen();

  /// File path: assets/images/base/ic_def_user_head.png
  AssetGenImage get icDefUserHead =>
      const AssetGenImage('assets/images/base/ic_def_user_head.png');

  /// List of all assets
  List<AssetGenImage> get values => [icDefUserHead];
}

class $AssetsImagesMpGen {
  const $AssetsImagesMpGen();

  /// File path: assets/images/mp/slc_mp_ic_android.png
  AssetGenImage get slcMpIcAndroid =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_android.png');

  /// File path: assets/images/mp/slc_mp_ic_audiotrack.png
  AssetGenImage get slcMpIcAudiotrack =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_audiotrack.png');

  /// File path: assets/images/mp/slc_mp_ic_cs.png
  AssetGenImage get slcMpIcCs =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_cs.png');

  /// File path: assets/images/mp/slc_mp_ic_excel.png
  AssetGenImage get slcMpIcExcel =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_excel.png');

  /// File path: assets/images/mp/slc_mp_ic_folder.png
  AssetGenImage get slcMpIcFolder =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_folder.png');

  /// File path: assets/images/mp/slc_mp_ic_html.png
  AssetGenImage get slcMpIcHtml =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_html.png');

  /// File path: assets/images/mp/slc_mp_ic_image.png
  AssetGenImage get slcMpIcImage =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_image.png');

  /// File path: assets/images/mp/slc_mp_ic_pdf.png
  AssetGenImage get slcMpIcPdf =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_pdf.png');

  /// File path: assets/images/mp/slc_mp_ic_powerpoint.png
  AssetGenImage get slcMpIcPowerpoint =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_powerpoint.png');

  /// File path: assets/images/mp/slc_mp_ic_text.png
  AssetGenImage get slcMpIcText =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_text.png');

  /// File path: assets/images/mp/slc_mp_ic_unknown.png
  AssetGenImage get slcMpIcUnknown =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_unknown.png');

  /// File path: assets/images/mp/slc_mp_ic_videocam.png
  AssetGenImage get slcMpIcVideocam =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_videocam.png');

  /// File path: assets/images/mp/slc_mp_ic_word.png
  AssetGenImage get slcMpIcWord =>
      const AssetGenImage('assets/images/mp/slc_mp_ic_word.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        slcMpIcAndroid,
        slcMpIcAudiotrack,
        slcMpIcCs,
        slcMpIcExcel,
        slcMpIcFolder,
        slcMpIcHtml,
        slcMpIcImage,
        slcMpIcPdf,
        slcMpIcPowerpoint,
        slcMpIcText,
        slcMpIcUnknown,
        slcMpIcVideocam,
        slcMpIcWord
      ];
}

class $AssetsImagesUserGen {
  const $AssetsImagesUserGen();

  /// File path: assets/images/user/ic_folder.svg
  String get icFolder => 'assets/images/user/ic_folder.svg';

  /// List of all assets
  List<String> get values => [icFolder];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
