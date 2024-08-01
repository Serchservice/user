import 'package:flutter/material.dart';
import 'package:user/library.dart';

class ScheduleHistoryView extends StatelessWidget {
  final Schedule schedule;
  const ScheduleHistoryView({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: () => ScheduleTimeViewer.open(schedule: schedule),
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
                          color: background(schedule.status),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: SText(
                          text: schedule.status,
                          color: text(schedule.status),
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

  Color background(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return const Color(0xFFD3D3D3); // Light Gray
      case "accepted":
        return const Color(0xFFD4EDDA); // Light Green
      case "declined":
        return const Color(0xFFF8D7DA); // Light Red
      case "closed":
        return const Color(0xFFD1ECF1); // Light Blue
      case "attended":
        return const Color(0xFFFFF3CD); // Light Yellow
      case "cancelled":
        return const Color(0xFFFFE5B4); // Light Orange
      case "unattended":
        return const Color(0xFFE2D4F0); // Light Purple
      default:
        return Colors.white; // Default to white if status is unknown
    }
  }

  Color text(String status) {
    switch (status.toLowerCase()) {
      case "pending":
      case "accepted":
      case "declined":
      case "closed":
      case "attended":
      case "cancelled":
      case "unattended":
        return const Color(0xFF050404); // Black
      default:
        return Colors.black; // Default to black if status is unknown
    }
  }
}
