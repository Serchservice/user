import 'package:user/library.dart';
import 'package:flutter/material.dart';

class TextActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;

  const TextActionButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return Database.preference.isLightTheme ? CommonColors.lightTheme : CommonColors.darkTheme;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return Database.preference.isLightTheme ? CommonColors.hinted : CommonColors.shimmerBase.withValues(alpha: .48);
        }),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
          vertical: Sizing.space(4),
          horizontal: Sizing.space(6)
        ))
      ),
      child: SText(
        text: text,
        size: Sizing.font(11),
        color: Database.preference.isLightTheme ? CommonColors.darkTheme : CommonColors.lightTheme,
      )
    );
  }
}