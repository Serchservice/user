import 'package:user/library.dart';
import 'package:flutter/material.dart';

class CentreQuickAction extends StatelessWidget {
  const CentreQuickAction({
    super.key,
    required this.action,
  });

  final ButtonView action;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          onTap: () => Navigate.to(action.path),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizing.space(6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  action.icon,
                  size: Sizing.space(30),
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 5),
                SText.center(
                  text: action.header,
                  color: Theme.of(context).primaryColor,
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