import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityActiveTripViewTimeline extends StatelessWidget {
  final ActivityActiveTripViewController controller;

  const ActivityActiveTripViewTimeline({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      TripResponse selected = controller.state.trip.value;

      if(selected.timelines.isNotEmpty) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          height: 250,
          padding: EdgeInsets.all(Sizing.space(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(
                text: 'Trip Timeline',
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(height: 6),
              Expanded(
                child: ListView.builder(
                  itemCount: selected.timelines.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    TimelineResponse timeline = selected.timelines[index];
                    bool showBottom = index != selected.timelines.length - 1;

                    return ActivityTripItemStep(
                      header: timeline.header,
                      description: timeline.description,
                      label: timeline.label,
                      isOver: timeline.isOver,
                      showBottom: showBottom,
                      custom: ActivityActiveTripViewAction(controller: controller, timeline: timeline)
                    );
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
