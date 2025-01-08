import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ActivityScheduleItem extends StatelessWidget {
  final Schedule schedule;
  const ActivityScheduleItem({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: () => ActivityScheduleAction.open(schedule: schedule),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText(
                        text: "Created ${schedule.label} for ${schedule.time}",
                        size: Sizing.font(16),
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Avatar(radius: 12, avatar: schedule.avatar),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SText(
                              text: schedule.name,
                              size: Sizing.font(12),
                              color: Theme.of(context).primaryColor
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.all(Sizing.space(4)),
                        decoration: BoxDecoration(
                          color: schedule.backgroundColor,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: SText(
                          text: schedule.status,
                          color: schedule.textColor,
                          size: Sizing.font(12),
                          weight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                CategoryImage(image: schedule.image)
              ],
            ),
          )
        )
      ),
    );
  }
}
