import 'package:flutter/material.dart';
import 'package:user/library.dart';

class SBackButton extends StatelessWidget {
  final void Function()? onTap;
  final double? size;
  final Color? color;
  final IconData? icon;
  final double? radius;
  const SBackButton({
    super.key,
    this.onTap,
    this.size,
    this.color,
    this.icon,
    this.radius
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: radius ?? 25,
      iconSize: size ?? Sizing.font(30),
      onPressed: onTap ?? () => Navigate.back(),
      icon: Icon(
        icon ?? Icons.keyboard_arrow_left_rounded,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? Sizing.font(30)
      )
    );
  }
}