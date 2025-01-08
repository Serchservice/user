import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityActiveTripView extends StatelessWidget {
  final TripResponse trip;
  const ActivityActiveTripView({super.key, required this.trip});

  static void open(TripResponse trip) {
    Navigate.toPage(
      widget: ActivityActiveTripView(trip: trip),
      route: "/activity/active/trip/${trip.id}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivityActiveTripViewController>(
      init: ActivityActiveTripViewController(trip: trip),
      autoRemove: false,
      builder: (controller) {
        return MainLayout(
          floaterPosition: 0,
          floater: _buildFloater(context, controller),
          child: ActivityActiveTripViewMap(trip: controller.state.trip.value),
        );
      }
    );
  }

  Widget _buildFloater(BuildContext context, ActivityActiveTripViewController controller) {
    return Obx(() {
      if(controller.state.isMinimized.value) {
        return ActivityActiveTripViewHeader(controller: controller);
      } else {
        return ActivityActiveTripViewContent(controller: controller);
      }
    });
  }
}