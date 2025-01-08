import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:user/library.dart';

class PreferenceSelectorScheduleTime extends StatelessWidget {
  final PreferenceSelectorController controller;

  const PreferenceSelectorScheduleTime({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ScheduleTime selected = controller.state.schedule.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ScheduleTime.values.map((schedule) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: PreferenceSelectorItem(
              isSelected: selected == schedule,
              onTap: () => controller.updateScheduleTime(schedule),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SText(
                      text: schedule.type,
                      size: Sizing.font(14),
                      weight: selected == schedule ? FontWeight.bold : FontWeight.normal,
                      color: Theme.of(context).primaryColorLight
                    ),
                  ),
                  if(selected == schedule) ...[
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