import 'package:user/library.dart';
import 'package:flutter/material.dart';

class ActivityScheduleGroupItem extends StatelessWidget {
  final ScheduleGroup group;

  const ActivityScheduleGroupItem({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 6),
          child: SText(
            text: group.label,
            size: Sizing.font(11),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColorLight
          ),
        ),
        const Divider(color: CommonColors.darkTheme2),
        ListView.builder(
          itemCount: group.schedules.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ActivityScheduleItem(schedule: group.schedules[index]),
        )
      ],
    );
  }
}