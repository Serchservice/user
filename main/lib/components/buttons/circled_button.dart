import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CircledButton extends StatelessWidget {
  final String title;
  final VoidCallback? onClick;
  final Color? backgroundColor;
  final Color? overlayColor;
  final bool isBig;
  final IconData? icon;
  final String? asset;
  final Color? iconColor;
  final double? size;

  const CircledButton({
    super.key,
    required this.title,
    this.onClick,
    this.backgroundColor,
    this.overlayColor,
    this.isBig = false,
    this.icon,
    this.asset,
    this.iconColor,
    this.size
  }) : assert((icon != null && asset == null) || (icon == null && asset != null));

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClick,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return overlayColor ?? CommonColors.shimmerBase.withValues(alpha: .48);
        }),
        shape: WidgetStateProperty.all(const CircleBorder()),
        padding: WidgetStatePropertyAll(EdgeInsets.all(Sizing.space(10)))
      ),
      tooltip: title,
      icon: _buildIcon(context)
    );
  }

  Widget _buildIcon(BuildContext context) {
    if(icon != null) {
      return Icon(
        icon,
        color: iconColor ?? Theme.of(context).primaryColor,
        size: size ?? Sizing.space(isBig ? 26 : 18)
      );
    } else {
      return Image.asset(
        asset!,
        color: iconColor,
        width: size ?? Sizing.space(18),
        height: size ?? Sizing.space(18)
      );
    }
  }
}
