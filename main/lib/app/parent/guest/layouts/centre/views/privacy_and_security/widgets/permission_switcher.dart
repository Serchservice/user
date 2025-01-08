import 'package:user/library.dart';
import 'package:flutter/material.dart';

class PermissionSwitcher extends StatelessWidget {
  const PermissionSwitcher({
    super.key,
    required this.view,
    required this.value,
  });

  final ButtonView view;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Sizing.space(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            view.icon,
            color: Theme.of(context).primaryColor,
            size: Sizing.space(24)
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SText(
                  text: view.header,
                  size: Sizing.font(15),
                  color: Theme.of(context).primaryColor
                ),
                SText(
                  text: view.body,
                  size: Sizing.font(12),
                  color: Theme.of(context).primaryColorLight
                ),
              ],
            )
          ),
          const SizedBox(width: 30),
          Switcher(onChanged: (value) {}, value: value)
        ],
      ),
    );
  }
}