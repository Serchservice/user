import 'package:flutter/material.dart';
import 'package:user/library.dart';

class TripBox extends StatelessWidget {
  final TripResponse trip;
  final VoidCallback? onTap;
  final bool showStatus;
  final bool showShare;
  final bool showTimeline;
  const TripBox({
    super.key,
    required this.trip,
    this.onTap,
    this.showStatus = true,
    this.showShare = false,
    this.showTimeline = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: _buildBody(context),
          )
        )
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if(showTimeline) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMain(context),
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
                    child: TripStep(
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
                    child: TripStep(
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
    } else {
      return _buildMain(context);
    }
  }

  Widget _buildMain(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(Sizing.space(4)),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8)
          ),
          child: CategoryImage(image: trip.image, width: 60, height: 60)
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText(
                text: trip.address,
                size: Sizing.font(14),
                weight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(height: 6),
              SText(
                text: trip.label,
                size: Sizing.font(12),
                color: Theme.of(context).primaryColor
              ),
              const SizedBox(height: 6),
              SText(
                text: trip.mode,
                color: Theme.of(context).primaryColor,
                size: Sizing.font(12),
              ),
              if(showShare && trip.shared != null && trip.shared!.category.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.all(Sizing.space(4)),
                  decoration: BoxDecoration(
                    color: background(trip.shared!.status),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: SText(
                    text: trip.shared!.status,
                    color: text(trip.shared!.status),
                    size: Sizing.font(12),
                    weight: FontWeight.bold
                  )
                ),
              ]
            ],
          ),
        ),
        if(showStatus) ...[
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(Sizing.space(4)),
                decoration: BoxDecoration(
                  color: CommonUtility.lightenColor(TripResponse.background(trip.status), 45),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: SText(
                  text: trip.status,
                  color: TripResponse.text(trip.status),
                  size: Sizing.font(12),
                  weight: FontWeight.bold
                )
              ),
              if(trip.quotations.isNotEmpty) ...[
                const SizedBox(height: 10),
                Badge(
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).scaffoldBackgroundColor,
                  label: Text("${trip.quotations.length}"),
                )
              ]
            ],
          )
        ]
      ],
    );
  }

  static Color background(String status) {
    switch (status.toLowerCase()) {
      case "waiting":
        return Colors.brown; // Light Yellow
      case "active":
        return Colors.pinkAccent;
      default:
        return Colors.black12; // Default to white if status is unknown
    }
  }

  static Color text(String status) {
    switch (status.toLowerCase()) {
      case "waiting":
        return Colors.white; // Light Yellow
      case "active":
        return Colors.pink[900] ?? Colors.black12;
      default:
        return Colors.black; // Default to white if status is unknown
    }
  }
}