import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ActivityActiveScheduleFilterSheet extends StatelessWidget {
  final ActivityActiveController controller;

  const ActivityActiveScheduleFilterSheet({super.key, required this.controller});

  static void open({required ActivityActiveController controller}) => Navigate.bottomSheet(
    sheet: ActivityActiveScheduleFilterSheet(controller: controller),
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