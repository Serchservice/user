import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityActiveTripViewContent extends StatelessWidget {
  final ActivityActiveTripViewController controller;

  const ActivityActiveTripViewContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      TripResponse selected = controller.state.trip.value;

      return Container(
        height: Get.height - 120,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActivityActiveTripViewHeader(controller: controller),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      color: Theme.of(context).colorScheme.surface,
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SText(
                            text: selected.label,
                            size: Sizing.font(12),
                            color: Theme.of(context).primaryColorLight
                          ),
                          SText(
                            text: selected.mode,
                            size: Sizing.font(12),
                            color: Theme.of(context).primaryColorLight
                          ),
                        ]
                      ),
                    ),
                    if(selected.amount.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.all(Sizing.space(12)),
                        color: Theme.of(context).colorScheme.surface,
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SText(
                              text: 'Workmanship',
                              size: Sizing.font(14),
                              weight: FontWeight.bold,
                              color: Theme.of(context).primaryColor
                            ),
                            const SizedBox(width: 10),
                            SText(
                              text: selected.amount,
                              size: Sizing.font(14),
                              color: Theme.of(context).primaryColor
                            ),
                          ]
                        ),
                      )
                    ],
                    ActivityActiveTripViewProblem(controller: controller),
                    if(selected.provider != null) ...[
                      Container(
                        padding: EdgeInsets.all(Sizing.space(12)),
                        color: Theme.of(context).colorScheme.surface,
                        width: MediaQuery.sizeOf(context).width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SText(
                              text: 'Provider Profile',
                              size: Sizing.font(14),
                              weight: FontWeight.bold,
                              color: Theme.of(context).primaryColor
                            ),
                            const SizedBox(height: 10),
                            ActivityTripItemProfile(user: selected.provider!)
                          ]
                        ),
                      )
                    ],
                    ActivityActiveTripViewTimeline(controller: controller),
                    ActivityActiveTripViewShared(controller: controller)
                  ],
                )
              ),
            ),
          ],
        ),
      );
    });
  }
}