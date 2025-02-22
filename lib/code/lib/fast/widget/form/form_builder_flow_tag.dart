import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Field with chips that acts like a list checkboxes.
class FormBuilderFlowTag<T> extends FormBuilderFieldDecoration<List<T>> {
  final Color? backgroundColor;
  final Color? shadowColor;
  final double? elevation;
  final MaterialTapTargetSize? materialTapTargetSize;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Widget? deleteIcon;
  final Function(T)? onDeleted;
  final FormBuilderChipOption<T> Function(T) builderChipOption;

  // Wrap Settings
  final Axis direction;
  final bool showCheckmark;
  final Clip clipBehavior;
  final Color? checkmarkColor;
  final double runSpacing, spacing;
  final EdgeInsets? labelPadding;
  final EdgeInsets? padding;
  final TextDirection? textDirection;
  final TextStyle? labelStyle;
  final VerticalDirection verticalDirection;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final WrapCrossAlignment crossAxisAlignment;

  final int? maxChips;
  final ShapeBorder avatarBorder;

  /// Creates field with chips that acts like a list checkboxes.
  FormBuilderFlowTag({
    super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled,
    super.focusNode,
    super.onSaved,
    super.validator,
    super.decoration,
    super.key,
    super.initialValue,
    required super.name,
    super.restorationId,
    this.backgroundColor,
    this.shadowColor,
    this.deleteIcon,
    this.onDeleted,
    this.elevation,
    this.materialTapTargetSize,
    this.side,
    this.shape,
    required this.builderChipOption,
    this.direction = Axis.horizontal,
    this.showCheckmark = true,
    this.clipBehavior = Clip.none,
    this.checkmarkColor,
    this.runSpacing = 0.0,
    this.spacing = 0.0,
    this.labelPadding,
    this.padding,
    this.textDirection,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.verticalDirection = VerticalDirection.down,
    this.labelStyle,
    this.maxChips,
    this.avatarBorder = const CircleBorder(),
    super.onChanged,
    super.valueTransformer,
    super.onReset,
  })
      : assert((maxChips == null) || ((initialValue ?? []).length <= maxChips)),
        super(
        builder: (FormFieldState<List<T>?> field) {
          final state = field as _FormBuilderFlowTagState<T>;
          final fieldValueList = field.value ?? [];
          return Builder(builder: (context) {
            if (fieldValueList.isEmpty) {
              return TextField(restorationId: restorationId,
                  decoration: state.decoration,
                  readOnly: true);
            }
            ThemeData themeData = Theme.of(context);
            return InputDecorator(
              decoration: state.decoration,
              child: Wrap(
                direction: direction,
                alignment: alignment,
                crossAxisAlignment: crossAxisAlignment,
                runAlignment: runAlignment,
                runSpacing: runSpacing,
                spacing: spacing,
                textDirection: textDirection,
                verticalDirection: verticalDirection,
                children: fieldValueList.map<Widget>((option) {
                  FormBuilderChipOption<T> chipOption = builderChipOption.call(option);
                  return Chip(
                    label: chipOption.build(context),
                    avatar: chipOption.avatar,
                    deleteIcon: deleteIcon,
                    onDeleted: () => onDeleted?.call(option),
                    backgroundColor: backgroundColor,
                    shadowColor: shadowColor,
                    elevation: elevation,
                    materialTapTargetSize: materialTapTargetSize,
                    padding: padding,
                    side: side,
                    shape: shape,
                    clipBehavior: clipBehavior,
                    labelStyle: labelStyle,
                    labelPadding: labelPadding,
                  );
                }).toList(),
              ),
            );
          });
        },
      );

  @override
  FormBuilderFieldDecorationState<FormBuilderFlowTag<T>, List<T>> createState() =>
      _FormBuilderFlowTagState<T>();
}

class _FormBuilderFlowTagState<T> extends FormBuilderFieldDecorationState<FormBuilderFlowTag<T>, List<T>> {}
