import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'indicator_simple.dart';

///
///@author sunlunchang
///默认的底部控件，用在列表的分页加载中
///
class HeaderFooterSimple {
  static MaterialHeader getDefHeader() {
    return const MaterialHeader(infiniteOffset: null);
  }

  static FooterSimple getDefFooter() {
    return const FooterSimple(
        clamping: false,
        mainAxisAlignment: MainAxisAlignment.start,
        triggerWhenReach: true);
  }

  /*static ClassicFooter getDefFooter() {
    return ClassicFooter(
        clamping: false,
        mainAxisAlignment: MainAxisAlignment.start,
        triggerWhenReach: true,
        showMessage: false,
        dragText: S.current.label_refresh_load_complete,
        armedText: S.current.label_refresh_load_complete,
        readyText: S.current.label_refresh_loading,
        processingText: S.current.label_refresh_loading,
        processedText: S.current.label_refresh_loading_succeed,
        noMoreText: S.current.label_refresh_load_end,
        noMoreIcon: SizedBox.fromSize(
          size: const Size(0, 0),
        ),
        failedText: S.current.label_refresh_load_failed);
  }*/
}
