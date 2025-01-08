import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class PreferenceSelectorSecurityType extends StatelessWidget {
  final PreferenceSelectorController controller;

  const PreferenceSelectorSecurityType({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      SecurityType selected = controller.state.security.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: SecurityType.values.map((security) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: PreferenceSelectorItem(
              isSelected: selected == security,
              onTap: () => controller.updateSecurityType(security),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SText(
                      text: security.type,
                      size: Sizing.font(14),
                      weight: selected == security ? FontWeight.bold : FontWeight.normal,
                      color: Theme.of(context).primaryColorLight
                    ),
                  ),
                  if(selected == security) ...[
                    const SizedBox(width: 20),
                    Icon(Icons.playlist_add_check_circle_rounded, color: Theme.of(context).primaryColor)
                  ]
                ],
              )
            ),
          );
        }).toList(),
      );
    });
  }
}