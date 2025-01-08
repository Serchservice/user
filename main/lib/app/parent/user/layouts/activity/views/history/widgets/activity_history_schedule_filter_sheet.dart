import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityHistoryScheduleFilterSheet extends StatelessWidget {
  final ActivityHistoryController controller;
  const ActivityHistoryScheduleFilterSheet({super.key, required this.controller});

  static void open({required ActivityHistoryController controller}) => Navigate.bottomSheet(
    sheet: ActivityHistoryScheduleFilterSheet(controller: controller),
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
          const SizedBox(height: 30),
          SText.center(
            text: "Filter by status",
            size: Sizing.font(14),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 10),
          Obx(() => SearchFilter(
            list: controller.scheduleFilterButtons,
            selectedIndex: controller.state.scheduleFilterStatusIndex.value,
            onSelect: (view) => controller.filterScheduleByStatus(view.index)
          )),
          const SizedBox(height: 30),
          SText.center(
            text: "Filter by category",
            size: Sizing.font(14),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 10),
          Obx(() => SearchFilter(
            list: ActivityController.data.filterButtons,
            selectedIndex: controller.state.scheduleFilterCategoryIndex.value,
            onSelect: (view) => controller.filterScheduleByCategory(view.index)
          )),
          const SizedBox(height: 30),
          SText.center(
            text: "Filter by date",
            size: Sizing.font(14),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Obx(() {
                  if(controller.state.scheduleFilterDate.value != DateTime(2009)) {
                    return SText(
                      text: CommonUtility.formatDay(controller.state.scheduleFilterDate.value, showTime: false),
                      size: Sizing.font(14),
                      color: Theme.of(context).primaryColor
                    );
                  } else {
                    return Container();
                  }
                }),
              ),
              const SizedBox(width: 10),
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextActionButton(text: "Pick date", onTap: () => controller.pickDate(isSchedule: true, context: context)),
                  TextActionButton(text: "Clear", onTap: () => controller.clearFilter(true)),
                ],
              )
            ],
          )
        ]
      )
    );
  }
}
