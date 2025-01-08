import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityRequestedScheduleFilterSheet extends StatelessWidget {
  final ActivityRequestedController controller;
  const ActivityRequestedScheduleFilterSheet({super.key, required this.controller});

  static void open({required ActivityRequestedController controller}) => Navigate.bottomSheet(
    sheet: ActivityRequestedScheduleFilterSheet(controller: controller),
    isScrollable: true,
    route: controller.filterRoute("schedule")
  );

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(Sizing.space(2)),
              margin: EdgeInsets.all(Sizing.space(6)),
              alignment: Alignment.center,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)
              ),
            ),
          ),
          Center(
            child: SText.center(
              text: "Advanced schedule filter",
              size: Sizing.font(16),
              weight: FontWeight.bold,
              color: Theme.of(context).primaryColor
            ),
          ),
          SText.center(
            text: "Filter by category",
            size: Sizing.font(14),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 10),
          Obx(() => SearchFilter(
            list: ActivityController.data.filterButtons,
            selectedIndex: controller.state.scheduleFilterIndex.value,
            onSelect: (view) => controller.filterSchedules(view.index)
          )),
          const SizedBox(height: 30),
        ]
      )
    );
  }
}
