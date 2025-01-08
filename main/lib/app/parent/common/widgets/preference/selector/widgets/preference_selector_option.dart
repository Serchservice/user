import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class PreferenceSelectorOption extends StatelessWidget {
  final PreferenceSelectorController controller;

  const PreferenceSelectorOption({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      PreferenceOption selected = controller.state.preference.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: PreferenceOption.values.map((preference) {
          if(preference == PreferenceOption.none) {
            return Container();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: PreferenceSelectorItem(
              isSelected: selected == preference,
              onTap: () => controller.updatePreference(preference),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SText(
                      text: preference.type,
                      size: Sizing.font(14),
                      weight: selected == preference ? FontWeight.bold : FontWeight.normal,
                      color: Theme.of(context).primaryColorLight
                    ),
                  ),
                  if(selected == preference) ...[
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