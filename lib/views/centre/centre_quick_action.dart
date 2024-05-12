import 'package:flutter/material.dart';
import 'package:user/library.dart';

class CentreQuickAction extends StatelessWidget {
  const CentreQuickAction({
    super.key,
    required this.action,
  });

  final ButtonView action;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Material(
        borderRadius: BorderRadius.circular(24),
        color: CommonColors.darkTheme2,
        child: InkWell(
          onTap: () => Navigate.to(action.path),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizing.space(6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  action.icon,
                  size: Sizing.space(35),
                  color: CommonColors.lightTheme,
                ),
                const SizedBox(height: 5),
                SText.center(
                  text: action.header,
                  color: CommonColors.lightTheme,
                  size: Sizing.font(9),
                  weight: FontWeight.bold,
                )
              ],
            ),
          ),
        )
      )
    );
  }
}