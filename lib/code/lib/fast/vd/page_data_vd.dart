import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'refresh/header_footer_simple.dart';
import 'page_data_vm_sub.dart';
import 'package:flutter_slc_boxes/flutter/slc/adapter/load_more_format.dart';
import 'package:flutter_slc_boxes/flutter/slc/mvvm/base_mvvm.dart';

/// @Author sunlunchang
/// 分页场景下的分页数据视图，基于EasyRefresh进行拓展，用与快速构建分页功能
class PageDataVd extends StatefulWidget {
  final FastBaseListDataPageVmSub vmSub;

  final AbsoluteChangeNotifier changeNotifier;

  final NullableIndexedWidgetBuilder? childItemBuilder;

  final Widget? child;

  final EasyRefreshController? controller;

  final Header? header;

  final Footer? footer;

  final NotRefreshHeader? notRefreshHeader;

  final NotLoadFooter? notLoadFooter;

  final FutureOr Function()? onRefresh;

  final FutureOr Function()? onLoad;

  final SpringDescription? spring;

  final FrictionFactor? frictionFactor;

  final bool? simultaneously;

  final bool? canRefreshAfterNoMore;

  final bool? canLoadAfterNoMore;

  final bool? resetAfterRefresh;

  final bool? refreshOnStart;

  final Header? refreshOnStartHeader;

  final double callRefreshOverOffset;

  final double callLoadOverOffset;

  final StackFit fit;

  final Clip clipBehavior;

  final ERScrollBehaviorBuilder? scrollBehaviorBuilder;

  final ScrollController? scrollController;

  final Axis? triggerAxis;

  const PageDataVd(this.vmSub,
      this.changeNotifier,
      {super.key,
      this.child,
      this.childItemBuilder,
      this.controller,
      this.header,
      this.footer,
      this.onRefresh,
      this.onLoad,
      this.spring,
      this.frictionFactor,
      this.notRefreshHeader,
      this.notLoadFooter,
      this.simultaneously,
      this.canRefreshAfterNoMore,
      this.canLoadAfterNoMore,
      this.resetAfterRefresh,
      this.refreshOnStart,
      this.refreshOnStartHeader,
      this.callRefreshOverOffset = 20,
      this.callLoadOverOffset = 20,
      this.fit = StackFit.loose,
      this.clipBehavior = Clip.hardEdge,
      this.scrollBehaviorBuilder,
      this.scrollController,
      this.triggerAxis})
      :
        assert(callRefreshOverOffset > 0,
            'callRefreshOverOffset must be greater than 0.'),
        assert(callLoadOverOffset > 0,
            'callLoadOverOffset must be greater than 0.');

  @override
  State<StatefulWidget> createState() {
    return PageDataState();
  }
}

class PageDataState extends State<PageDataVd> {
  EasyRefreshController? controllerByState;
  VoidCallback? refreshEventCallback;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      controllerByState = EasyRefreshController(
        controlFinishRefresh: true,
        controlFinishLoad: true,
      );
      refreshEventCallback = () {
        controllerByState!.callRefresh();
      };
      widget.vmSub.refreshEvent.addListener(refreshEventCallback!);
    }
  }

  @override
  void dispose() {
    if (controllerByState == null) {
      controllerByState?.dispose();
      widget.vmSub.refreshEvent.removeListener(refreshEventCallback!);
    }
    super.dispose();
  }

  EasyRefreshController _getErController() {
    if (widget.controller != null) {
      return widget.controller!;
    }
    return controllerByState!;
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        key: widget.key,
        controller: _getErController(),
        header: widget.header ?? HeaderFooterSimple.getDefHeader(),
        footer: widget.footer ?? HeaderFooterSimple.getDefFooter(),
        onRefresh: widget.onRefresh ??
            () async {
              await widget.vmSub.refresh();
              _getErController().finishRefresh();
              _getErController().finishLoad(
                  widget.vmSub.getLoadMoreFormat().refreshStatusOf.value ==
                      LoadMoreStatus.noMore
                      ? IndicatorResult.noMore
                      : IndicatorResult.fail);
              widget.changeNotifier.notifyListeners();
            },
        onLoad: widget.onLoad ??
            () async {
              await widget.vmSub.loadMore();
              _getErController().finishLoad(
                  widget.vmSub.getLoadMoreFormat().refreshStatusOf.value ==
                          LoadMoreStatus.noMore
                      ? IndicatorResult.noMore
                      : IndicatorResult.fail);
              widget.changeNotifier.notifyListeners();
            },
        spring: widget.spring,
        frictionFactor: widget.frictionFactor,
        notRefreshHeader: widget.notRefreshHeader,
        notLoadFooter: widget.notLoadFooter,
        simultaneously: widget.simultaneously ?? false,
        canRefreshAfterNoMore: widget.canRefreshAfterNoMore ?? false,
        canLoadAfterNoMore: widget.canLoadAfterNoMore ?? false,
        resetAfterRefresh: widget.resetAfterRefresh ?? false,
        refreshOnStart: widget.refreshOnStart ?? true,
        refreshOnStartHeader: widget.refreshOnStartHeader,
        callRefreshOverOffset: widget.callRefreshOverOffset,
        callLoadOverOffset: widget.callLoadOverOffset,
        fit: widget.fit,
        clipBehavior: widget.clipBehavior,
        scrollBehaviorBuilder: widget.scrollBehaviorBuilder,
        scrollController: widget.scrollController,
        triggerAxis: widget.triggerAxis,
        child: widget.child);
  }
}
