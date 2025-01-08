import 'package:user/library.dart';
import 'package:flutter/material.dart';

class AppInformationSheet extends StatelessWidget {
  final List<ButtonView> options;
  final String header;
  final Function(ButtonView) onTap;

  const AppInformationSheet({
    super.key,
    required this.options,
    required this.onTap,
    required this.header
  });

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SText(
              text: header,
              color: Theme.of(context).primaryColor,
              size: Sizing.font(18),
              weight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          ...options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: NavigatorButton(
                header: option.header,
                prefixIcon: option.icon,
                iconColor: Theme.of(context).primaryColor,
                onPressed: () => onTap.call(option)
              ),
            );
          })
        ],
    ));
  }
}