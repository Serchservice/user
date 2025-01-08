import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityRequestedTripFilterSheet extends StatelessWidget {
  final ActivityRequestedController controller;
  const ActivityRequestedTripFilterSheet({super.key, required this.controller});

  static void open({required ActivityRequestedController controller}) => Navigate.bottomSheet(
    sheet: ActivityRequestedTripFilterSheet(controller: controller),
    isScrollable: true,
    route: controller.filterRoute("trip")
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
              text: "Advanced trip filter",
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
            selectedIndex: controller.state.tripFilterIndex.value,
            onSelect: (view) => controller.filterTrips(view.index)
          )),
          const SizedBox(height: 30),
        ]
      )
    );
  }
}
