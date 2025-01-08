import 'package:user/library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityHistoryTripViewShared extends StatelessWidget {
  final ActivityHistoryTripViewController controller;

  const ActivityHistoryTripViewShared({super.key, required this.controller});

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
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(
                text: 'Shared Trip Information',
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
              if(selected.provider != null) ...[
                Divider(color: Theme.of(context).scaffoldBackgroundColor),
                SText(
                  text: 'Provider Profile',
                  size: Sizing.font(14),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                ),
                const SizedBox(height: 10),
                ActivityTripItemProfile(user: selected.provider!, showCall: false)
              ],
              if(selected.shared!.profile != null) ...[
                Divider(color: Theme.of(context).scaffoldBackgroundColor),
                SText(
                  text: 'Shared Provider Profile',
                  size: Sizing.font(14),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                ),
                const SizedBox(height: 10),
                ActivityTripItemProfile(user: selected.shared!.profile!, showCall: false)
              ],
              if(selected.shared!.timelines.isNotEmpty) ...[
                Divider(color: Theme.of(context).scaffoldBackgroundColor),
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
