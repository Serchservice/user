import 'package:user/library.dart';
import 'package:flutter/material.dart';

class PreferenceSwitcher extends StatelessWidget {
  final ButtonView view;
  final VoidCallback? onTap;
  final Widget? more;
  final Function(bool value) onChange;
  final bool value;

  const PreferenceSwitcher({
    super.key,
    required this.view,
    required this.onChange,
    required this.value,
    this.onTap,
    this.more
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(Sizing.space(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(view.icon, color: Theme.of(context).primaryColor, size: Sizing.space(24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SText(text: view.header, size: Sizing.font(15), color: Theme.of(context).primaryColor),
                    SText(text: view.body, size: Sizing.font(12), color: Theme.of(context).primaryColorLight),
                    if(more != null) ...[ more! ]
                  ],
                )
              ),
              const SizedBox(width: 30),
              Switcher(onChanged: onChange.call, value: value)
            ],
          ),
        ),
      ),
    );
  }
}