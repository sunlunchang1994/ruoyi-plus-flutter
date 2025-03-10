import 'package:flutter_slc_boxes/flutter/slc/common/text_util.dart';

enum MediaType {
  audio,
  video,
  word,
  excel,
  ppt,
  pdf,
  img,
  hypertext,
  zip,
  apk,
  txt,
  unknown,
}

//
class MediaTypeConstant {
  //audio
  static const String EXTENSION_M3U = "m3u";
  static const String EXTENSION_M4A = "m4a";
  static const String EXTENSION_M4B = "m4b";
  static const String EXTENSION_M4P = "m4p";
  static const String EXTENSION_MP2 = "mp2";
  static const String EXTENSION_MP3 = "mp3";
  static const String EXTENSION_MPGA = "mpga";
  static const String EXTENSION_OGG = "ogg";

  //video
  static const String EXTENSION_ASF = "asf";
  static const String EXTENSION_AVI = "avi";
  static const String EXTENSION_M4U = "m4u";
  static const String EXTENSION_M4V = "m4v";
  static const String EXTENSION_MOV = "mov";
  static const String EXTENSION_MPE = "mpe";
  static const String EXTENSION_MPEG = "mpeg";
  static const String EXTENSION_MPG = "mpg";
  static const String EXTENSION_MPG4 = "mpg4";
  static const String EXTENSION_MP4 = "mp4";

  //office
  static const String EXTENSION_DOC = "doc";
  static const String EXTENSION_DOCX = "docx";
  static const String EXTENSION_XLS = "xls";
  static const String EXTENSION_XLSX = "xlsx";
  static const String EXTENSION_PPT = "ppt";
  static const String EXTENSION_PPTX = "pptx";

  //pdf
  static const String EXTENSION_PDF = "pdf";

  //img
  static const String EXTENSION_BMP = "bmp";
  static const String EXTENSION_GIF = "gif";
  static const String EXTENSION_IMAGE = "image";
  static const String EXTENSION_JPEG = "jpeg";
  static const String EXTENSION_JPG = "jpg";
  static const String EXTENSION_PNG = "png";

  //超文本格式
  static const String EXTENSION_HTM = "htm";
  static const String EXTENSION_HTML = "html";
  static const String EXTENSION_XML = "xml";
  static const String EXTENSION_IML = "iml";

  //压缩包
  static const String EXTENSION_GTAR = "gtar";
  static const String EXTENSION_GZ = "gz";
  static const String EXTENSION_JAR = "jar";
  static const String EXTENSION_ZIP = "zip";
  static const String EXTENSION_Z = "z";

  //apk
  static const String EXTENSION_APK = "apk";

  //txt
  static const String EXTENSION_TXT = "txt";
  static const String EXTENSION_JS = "js";
  static const String EXTENSION_KT = "kt";
  static const String EXTENSION_INI = "ini";
  static const String EXTENSION_BAT = "bat";
  static const String EXTENSION_SH = "sh";
  static const String EXTENSION_KEY = "key";
  static const String EXTENSION_JAVA = "java";
  static const String EXTENSION_SCRIPT = "script";
  static const String EXTENSION_PROPERTIES = "properties";

  static MediaType getMediaType(String? suffixName) {
    if (TextUtil.isEmpty(suffixName)) {
      return MediaType.unknown;
    }
    List<String> suffixPairList = suffixName!.split(".");
    suffixName = suffixPairList.last;
    switch (suffixName) {
      case EXTENSION_M3U:
      case EXTENSION_M4A:
      case EXTENSION_M4B:
      case EXTENSION_M4P:
      case EXTENSION_MP2:
      case EXTENSION_MP3:
      case EXTENSION_MPGA:
      case EXTENSION_OGG:
        return MediaType.audio;
      case EXTENSION_ASF:
      case EXTENSION_AVI:
      case EXTENSION_M4U:
      case EXTENSION_M4V:
      case EXTENSION_MOV:
      case EXTENSION_MPE:
      case EXTENSION_MPEG:
      case EXTENSION_MPG:
      case EXTENSION_MPG4:
      case EXTENSION_MP4:
        return MediaType.video;
      case EXTENSION_DOC:
      case EXTENSION_DOCX:
        return MediaType.word;
      case EXTENSION_XLS:
      case EXTENSION_XLSX:
        return MediaType.excel;
      case EXTENSION_PPT:
      case EXTENSION_PPTX:
        return MediaType.ppt;
      case EXTENSION_PDF:
        return MediaType.pdf;
      case EXTENSION_BMP:
      case EXTENSION_GIF:
      case EXTENSION_IMAGE:
      case EXTENSION_JPEG:
      case EXTENSION_JPG:
      case EXTENSION_PNG:
        return MediaType.img;
      case EXTENSION_HTM:
      case EXTENSION_HTML:
      case EXTENSION_XML:
      case EXTENSION_IML:
        return MediaType.hypertext;
      case EXTENSION_APK:
        return MediaType.apk;
      case EXTENSION_GTAR:
      case EXTENSION_GZ:
      case EXTENSION_JAR:
      case EXTENSION_ZIP:
      case EXTENSION_Z:
        return MediaType.zip;
      case EXTENSION_TXT:
      case EXTENSION_JS:
      case EXTENSION_KT:
      case EXTENSION_INI:
      case EXTENSION_BAT:
      case EXTENSION_SH:
      case EXTENSION_KEY:
      case EXTENSION_JAVA:
      case EXTENSION_SCRIPT:
      case EXTENSION_PROPERTIES:
        return MediaType.txt;
      default:
        return MediaType.unknown;
    }
  }

  static String getIconBySuffixName(String? suffixName) {
    return getIconByMediaType(getMediaType(suffixName));
  }

  static String getIconByMediaType(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.unknown:
        return "assets/images/mp/slc_mp_ic_unknown.png";
      case MediaType.audio:
        return "assets/images/mp/slc_mp_ic_audiotrack.png";
      case MediaType.video:
        return "assets/images/mp/slc_mp_ic_videocam.png";
      case MediaType.word:
        return "assets/images/mp/slc_mp_ic_word.png";
      case MediaType.excel:
        return "assets/images/mp/slc_mp_ic_excel.png";
      case MediaType.ppt:
        return "assets/images/mp/slc_mp_ic_powerpoint.png";
      case MediaType.pdf:
        return "assets/images/mp/slc_mp_ic_pdf.png";
      case MediaType.img:
        return "assets/images/mp/slc_mp_ic_image.png";
      case MediaType.hypertext:
        return "assets/images/mp/slc_mp_ic_html.png";
      case MediaType.zip:
        return "assets/images/mp/slc_mp_ic_cs.png";
      case MediaType.apk:
        return "assets/images/mp/slc_mp_ic_android.png";
      case MediaType.txt:
        return "assets/images/mp/slc_mp_ic_text.png";
    }
  }

  static List<String> getAllowedExtensions() {
    return [
      EXTENSION_JPEG,
      EXTENSION_JPG,
      EXTENSION_PNG,
      EXTENSION_GIF,
      EXTENSION_MP4,
      EXTENSION_DOC,
      EXTENSION_DOCX,
      EXTENSION_XLS,
      EXTENSION_XLSX,
      EXTENSION_PPT,
      EXTENSION_PPTX
    ];
  }
}
