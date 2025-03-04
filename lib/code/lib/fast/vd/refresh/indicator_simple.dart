import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';

import 'load_more.dart';
import 'load_more_error.dart';
import 'load_more_loading.dart';
import 'load_more_succeed.dart';
import 'no_more.dart';

///
/// @author sunlunchang
/// 分页加载的底部视图根据easy的默认实现进行更改
///
class FooterSimple extends Footer {
  final Key? key;

  /// The location of the widget.
  /// Only supports [MainAxisAlignment.center],
  /// [MainAxisAlignment.start] and [MainAxisAlignment.end].
  final MainAxisAlignment mainAxisAlignment;

  /// Background color.
  /// Ignored if [boxDecoration] is not null.
  final Color? backgroundColor;

  /// Box decoration.
  final BoxDecoration? boxDecoration;

  /// Link [Stack.clipBehavior].
  final Clip clipBehavior;

  const FooterSimple({
    this.key,
    super.triggerOffset = 64,
    super.clamping = false,
    super.position,
    super.processedDuration = Duration.zero,
    super.spring,
    super.readySpringBuilder,
    super.springRebound,
    super.frictionFactor,
    super.safeArea,
    super.infiniteOffset = 64,
    super.hitOver,
    super.infiniteHitOver,
    super.hapticFeedback,
    super.triggerWhenReach,
    super.triggerWhenRelease,
    super.maxOverOffset,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.backgroundColor,
    this.boxDecoration,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return _IndicatorSimple(
      key: key,
      state: state,
      backgroundColor: backgroundColor,
      boxDecoration: boxDecoration,
      mainAxisAlignment: mainAxisAlignment,
      reverse: !state.reverse,
      clipBehavior: clipBehavior,
    );
  }
}

class _IndicatorSimple extends StatefulWidget {
  /// Indicator properties and state.
  final IndicatorState state;

  /// The location of the widget.
  /// Only supports [MainAxisAlignment.center],
  /// [MainAxisAlignment.start] and [MainAxisAlignment.end].
  final MainAxisAlignment mainAxisAlignment;

  /// Background color.
  /// Ignored if [boxDecoration] is not null.
  final Color? backgroundColor;

  /// Box decoration.
  final BoxDecoration? boxDecoration;

  /// True for up and left.
  /// False for down and right.
  final bool reverse;

  /// Link [Stack.clipBehavior].
  final Clip clipBehavior;

  const _IndicatorSimple({
    super.key,
    required this.state,
    required this.mainAxisAlignment,
    this.backgroundColor,
    this.boxDecoration,
    required this.reverse,
    this.clipBehavior = Clip.hardEdge,
  }) : assert(
            mainAxisAlignment == MainAxisAlignment.start ||
                mainAxisAlignment == MainAxisAlignment.center ||
                mainAxisAlignment == MainAxisAlignment.end,
            'Only supports [MainAxisAlignment.center], [MainAxisAlignment.start] and [MainAxisAlignment.end].');

  @override
  State<_IndicatorSimple> createState() => _ClassicIndicatorState();
}

class _ClassicIndicatorState extends State<_IndicatorSimple>
    with TickerProviderStateMixin<_IndicatorSimple> {
  /// Icon [AnimatedSwitcher] switch key.

  MainAxisAlignment get _mainAxisAlignment => widget.mainAxisAlignment;

  Axis get _axis => widget.state.axis;

  double get _offset => widget.state.offset;

  double get _actualTriggerOffset => widget.state.actualTriggerOffset;

  double get _triggerOffset => widget.state.triggerOffset;

  double get _safeOffset => widget.state.safeOffset;

  IndicatorMode get _mode => widget.state.mode;

  IndicatorResult get _result => widget.state.result;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(_IndicatorSimple oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// When the list direction is vertically.
  Widget _buildVerticalWidget() {
    return Stack(
      clipBehavior: widget.clipBehavior,
      children: [
        if (_mainAxisAlignment == MainAxisAlignment.center)
          Positioned(
            left: 0,
            right: 0,
            top: _offset < _actualTriggerOffset
                ? -(_actualTriggerOffset -
                        _offset +
                        (widget.reverse ? _safeOffset : -_safeOffset)) /
                    2
                : (!widget.reverse ? _safeOffset : 0),
            bottom: _offset < _actualTriggerOffset
                ? null
                : (widget.reverse ? _safeOffset : 0),
            height:
                _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
            child: Center(
              child: _buildVerticalBody(),
            ),
          ),
        if (_mainAxisAlignment != MainAxisAlignment.center)
          Positioned(
            left: 0,
            right: 0,
            top: _mainAxisAlignment == MainAxisAlignment.start
                ? (!widget.reverse ? _safeOffset : 0)
                : null,
            bottom: _mainAxisAlignment == MainAxisAlignment.end
                ? (widget.reverse ? _safeOffset : 0)
                : null,
            child: _buildVerticalBody(),
          ),
      ],
    );
  }

  /// The body when the list is vertically direction.
  Widget _buildVerticalBody() {
    Widget child;
    if (_result == IndicatorResult.noMore) {
      child = const NoMoreWidget();
    } else {
      switch (_mode) {
        case IndicatorMode.drag:
          child = const LoadMoreWidget();
        case IndicatorMode.armed:
          child = const LoadMoreWidget();
        case IndicatorMode.ready:
          child = const LoadMoreLoadingWidget();
        case IndicatorMode.processing:
          child = const LoadMoreLoadingWidget();
        case IndicatorMode.processed:
        case IndicatorMode.done:
          if (_result == IndicatorResult.fail) {
            child = const LoadMoreErrorWidget();
          } else {
            child = const LoadMoreSucceedWidget();
          }
        default:
          child = const LoadMoreWidget();
      }
    }
    return Container(
      alignment: Alignment.center,
      height: _triggerOffset,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    double offset = _offset;
    if (widget.state.indicator.infiniteOffset != null &&
        widget.state.indicator.position == IndicatorPosition.locator &&
        (_mode != IndicatorMode.inactive ||
            _result == IndicatorResult.noMore)) {
      offset = _actualTriggerOffset;
    }
    return Container(
      color: widget.boxDecoration == null ? widget.backgroundColor : null,
      decoration: widget.boxDecoration,
      width: _axis == Axis.vertical ? double.infinity : offset,
      height: _axis == Axis.horizontal ? double.infinity : offset,
      child: _buildVerticalWidget(),
    );
  }
}
