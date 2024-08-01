import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ScheduleRequestedFilterSheet extends StatefulWidget {
  final HomeController controller;
  const ScheduleRequestedFilterSheet({super.key, required this.controller});

  static void open({required HomeController controller}) => Navigate.bottomSheet(
      sheet: ScheduleRequestedFilterSheet(controller: controller),
      isScrollable: true,
      route: "/activity?active=request&current=schedule&option=filter"
  );

  @override
  State<ScheduleRequestedFilterSheet> createState() => _ScheduleRequestedFilterSheetState();
}

class _ScheduleRequestedFilterSheetState extends State<ScheduleRequestedFilterSheet> {
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
            list: widget.controller.activity.commons,
            selectedIndex: widget.controller.state.requestedScheduleCategoryFilter.value,
            onSelect: (view) => widget.controller.activity.filterRequestedSchedulesByCategory(view.index)
          )),
          const SizedBox(height: 30),
        ]
      )
    );
  }
}
