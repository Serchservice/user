import 'package:user/library.dart';
import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  final Widget? icon;
  final String? tip;
  final VoidCallback onPressed;

  const InfoButton({super.key, required this.onPressed, this.icon, this.tip});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return Colors.transparent;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return CommonColors.shimmerBase.withValues(alpha: .48);
        }),
        shape: WidgetStateProperty.all(const CircleBorder()),
      ),
      tooltip: tip ?? "Learn more",
      icon: icon ?? Icon(
        Icons.info_outline_rounded,
        color: Theme.of(context).primaryColor,
        size: Sizing.space(22)
      )
    );
  }
}