import 'package:user/library.dart';
import 'package:flutter/material.dart';

class ActivityTripItemContentWithTimeline extends StatelessWidget {
  final TripResponse trip;
  final bool showShared;
  final bool showStatus;

  const ActivityTripItemContentWithTimeline({
    super.key,
    required this.trip,
    required this.showShared,
    required this.showStatus
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ActivityTripItemContent(trip: trip, showShared: showShared, showStatus: showStatus),
        const SizedBox(height: 15),
        if(trip.timelines.isNotEmpty) ...[
          SText(
            text: "Trip Timeline",
            size: Sizing.font(14),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: trip.timelines.map((timeline) {
              bool showSpacer = trip.timelines[trip.timelines.length - 1] != timeline;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: showSpacer ? 8.0 : 0),
                  child: ActivityTripItemStep(
                    header: timeline.header,
                    description: timeline.description,
                    label: timeline.label,
                    isOver: timeline.isOver,
                    isVertical: false,
                  ),
                )
              );
            }).toList(),
          )
        ],
        if(trip.shared != null && !trip.shared!.isOffline && trip.shared!.timelines.isNotEmpty) ...[
          const SizedBox(height: 6),
          SText(
            text: "Shared Trip Timeline",
            size: Sizing.font(14),
            weight: FontWeight.bold,
            color: Theme.of(context).primaryColor
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: trip.shared!.timelines.map((timeline) {
              bool showSpacer = trip.shared!.timelines[trip.shared!.timelines.length - 1] != timeline;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: showSpacer ? 8.0 : 0),
                  child: ActivityTripItemStep(
                    header: timeline.header,
                    description: timeline.description,
                    label: timeline.label,
                    isOver: timeline.isOver,
                    isVertical: false,
                  ),
                )
              );
            }).toList(),
          )
        ]
      ],
    );
  }
}
