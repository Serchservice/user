import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CurvedBottomSheet extends StatelessWidget {
  const CurvedBottomSheet({
    super.key,
    this.backgroundColor,
    required this.child,
    this.padding,
    this.safeArea = false
  });

  final Color? backgroundColor;
  final Widget child;
  final bool safeArea;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: safeArea,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Container(
          color: backgroundColor ?? Theme.of(context).bottomAppBarTheme.color,
          padding: padding ?? EdgeInsets.symmetric(vertical: Sizing.space(15), horizontal: Sizing.space(10)),
          child: child
        )
      ),
    );
  }
}