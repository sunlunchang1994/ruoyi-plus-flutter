import 'package:flutter/material.dart';

///从官方的CheckedPopupMenuItem复制过来的
class SlcCheckedPopupMenuItem<T> extends PopupMenuItem<T> {
  const SlcCheckedPopupMenuItem({
    super.key,
    super.value,
    this.checked = false,
    super.enabled,
    super.padding,
    super.height,
    super.labelTextStyle,
    super.mouseCursor,
    super.child,
    super.onTap,
  });

  final bool checked;

  @override
  Widget? get child => super.child;

  @override
  PopupMenuItemState<T, SlcCheckedPopupMenuItem<T>> createState() =>
      _CheckedPopupMenuItemState<T>();
}

class _CheckedPopupMenuItemState<T>
    extends PopupMenuItemState<T, SlcCheckedPopupMenuItem<T>>
    with SingleTickerProviderStateMixin {
  static const Duration _fadeDuration = Duration(milliseconds: 150);
  late AnimationController _controller;

  Animation<double> get _opacity => _controller.view;

  late bool checkBoxStatus;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _fadeDuration, vsync: this)
      ..value = widget.checked ? 1.0 : 0.0
      ..addListener(() => setState(() {
            /* animation changed */
          }));
    checkBoxStatus = widget.checked;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void handleTap() {
    // This fades the checkmark in or out when tapped.
    if (widget.checked) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    super.handleTap();
  }

  @override
  Widget buildChild() {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final PopupMenuThemeData defaults = theme.useMaterial3
        ? _PopupMenuDefaultsM3(context)
        : _PopupMenuDefaultsM2(context);
    final Set<WidgetState> states = <WidgetState>{
      if (widget.checked) WidgetState.selected,
    };
    final WidgetStateProperty<TextStyle?>? effectiveLabelTextStyle =
        widget.labelTextStyle ??
            popupMenuTheme.labelTextStyle ??
            defaults.labelTextStyle;
      //return IgnorePointer(child:); //TODO 移除了IgnorePointer包裹
      return ListTileTheme.merge(
      contentPadding: EdgeInsets.zero,
      child: ListTile(
        enabled: widget.enabled,
        titleTextStyle: effectiveLabelTextStyle?.resolve(states),
        visualDensity: VisualDensity.compact,
        leading: Checkbox(
            value: checkBoxStatus,
            onChanged: (value) {
              setState(() {
                checkBoxStatus = !checkBoxStatus;
                handleTap();
              });
            },
            visualDensity: VisualDensity.compact),
        title: widget.child,
      ),
    );
  }
}

class _PopupMenuDefaultsM2 extends PopupMenuThemeData {
  _PopupMenuDefaultsM2(this.context) : super(elevation: 8.0);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  TextStyle? get textStyle => _textTheme.titleMedium;

  @override
  EdgeInsets? get menuPadding => const EdgeInsets.symmetric(vertical: 8.0);

  static EdgeInsets menuItemPadding =
      const EdgeInsets.symmetric(horizontal: 16.0);
}

// BEGIN GENERATED TOKEN PROPERTIES - PopupMenu

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

class _PopupMenuDefaultsM3 extends PopupMenuThemeData {
  _PopupMenuDefaultsM3(this.context) : super(elevation: 3.0);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  MaterialStateProperty<TextStyle?>? get labelTextStyle {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      // TODO(quncheng): Update this hard-coded value to use the latest tokens.
      final TextStyle style = _textTheme.labelLarge!;
      if (states.contains(MaterialState.disabled)) {
        return style.apply(color: _colors.onSurface.withOpacity(0.38));
      }
      return style.apply(color: _colors.onSurface);
    });
  }

  @override
  Color? get color => _colors.surfaceContainer;

  @override
  Color? get shadowColor => _colors.shadow;

  @override
  Color? get surfaceTintColor => Colors.transparent;

  @override
  ShapeBorder? get shape => const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)));

  // TODO(bleroux): This is taken from https://m3.material.io/components/menus/specs
  // Update this when the token is available.
  @override
  EdgeInsets? get menuPadding => const EdgeInsets.symmetric(vertical: 8.0);

  // TODO(tahatesser): This is taken from https://m3.material.io/components/menus/specs
  // Update this when the token is available.
  static EdgeInsets menuItemPadding =
      const EdgeInsets.symmetric(horizontal: 12.0);
}
// END GENERATED TOKEN PROPERTIES - PopupMenu
