import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ButtonSelector extends StatelessWidget {
  final String text;
  final int index;
  final ValueChanged<int> onTap;
  final bool selected;
  final EdgeInsetsGeometry? padding;
  final Color? selectedBgColor;
  final Color? unSelectedBgColor;
  final double? borderRadius;
  final FontWeight? weight;
  final double? textSize;

  const ButtonSelector({
    super.key,
    required this.text,
    this.selected = false,
    required this.onTap,
    required this.index,
    this.padding,
    this.selectedBgColor,
    this.unSelectedBgColor,
    this.borderRadius,
    this.weight,
    this.textSize
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(
          vertical: Sizing.space(6),
          horizontal: Sizing.space(12)
        ),
        decoration: BoxDecoration(
          color: selected
            ? selectedBgColor ?? Theme.of(context).primaryColor
            : unSelectedBgColor ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
        ),
        child: SText.center(
          text: text,
          size: textSize ?? Sizing.font(16),
          weight: weight ?? FontWeight.normal,
          color: selected
            ? unSelectedBgColor ?? Theme.of(context).colorScheme.surface
            : selectedBgColor ?? Theme.of(context).primaryColor
        ),
      ),
    );
  }
}