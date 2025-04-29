import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

/// 滑动控制器包装类
class ScrollControllerWrap {
  //滑动控制器
  late ScrollController _scrollController;

  get scrollController => _scrollController;

  //用户是否手动滚动
  bool _autoScrollBottom = true;

  bool get autoScrollBottom => _autoScrollBottom;

  ScrollControllerWrap() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollListener);
  }

  //滑动监听
  void _onScrollListener() {
    // 检测用户是否手动滚动（与自动滚动区分）
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse ||
        _scrollController.position.userScrollDirection == ScrollDirection.forward) {
      _autoScrollBottom = false;
    }
    // 检查是否滚动到底部
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _autoScrollBottom = true;
    }
  }

  //滚动到底部
  void scroll2Bottom() {
    if (!_autoScrollBottom) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 50),
        curve: Curves.easeOut,
      );
    });
  }
}
