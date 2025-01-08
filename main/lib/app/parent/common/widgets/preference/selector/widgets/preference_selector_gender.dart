import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class PreferenceSelectorGender extends StatelessWidget {
  final PreferenceSelectorController controller;

  const PreferenceSelectorGender({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Gender selected = controller.state.gender.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: Gender.values.map((gender) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: PreferenceSelectorItem(
              isSelected: selected == gender,
              onTap: () => controller.updateGender(gender),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SText(
                      text: gender.value,
                      size: Sizing.font(14),
                      weight: selected == gender ? FontWeight.bold : FontWeight.normal,
                      color: Theme.of(context).primaryColorLight
                    ),
                  ),
                  if(selected == gender) ...[
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