import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityActiveTripViewShared extends StatelessWidget {
  final ActivityActiveTripViewController controller;

  const ActivityActiveTripViewShared({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      TripResponse selected = controller.state.trip.value;

      if(selected.shared != null && selected.shared!.category.isNotEmpty) {
        return Container(
          padding: EdgeInsets.all(Sizing.space(12)),
          color: Theme.of(context).colorScheme.surface,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(
                text: 'Shared Trip Information',
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
              if(selected.provider != null) ...[
                const SizedBox(height: 5),
                Divider(color: Theme.of(context).scaffoldBackgroundColor),
                const SizedBox(height: 5),
                SText(
                  text: 'Provider Profile',
                  size: Sizing.font(14),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                ),
                const SizedBox(height: 10),
                ActivityTripItemProfile(user: selected.provider!)
              ],
              if(selected.shared!.profile != null) ...[
                const SizedBox(height: 5),
                Divider(color: Theme.of(context).scaffoldBackgroundColor),
                const SizedBox(height: 5),
                SText(
                  text: 'Shared Provider Profile',
                  size: Sizing.font(14),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                ),
                const SizedBox(height: 10),
                ActivityTripItemProfile(user: selected.shared!.profile!)
              ],
              if(selected.shared!.timelines.isNotEmpty) ...[
                const SizedBox(height: 5),
                Divider(color: Theme.of(context).scaffoldBackgroundColor),
                const SizedBox(height: 5),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SText(
                        text: 'Shared Trip Timeline',
                        size: Sizing.font(14),
                        weight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: ListView.builder(
                          itemCount: selected.shared!.timelines.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            TimelineResponse timeline = selected.shared!.timelines[index];
                            bool showBottom = index != selected.shared!.timelines.length - 1;

                            return ActivityTripItemStep(
                              header: timeline.header,
                              description: timeline.description,
                              label: timeline.label,
                              isOver: timeline.isOver,
                              showBottom: showBottom,
                              custom: ActivityActiveTripViewSharedAction(controller: controller, timeline: timeline),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
