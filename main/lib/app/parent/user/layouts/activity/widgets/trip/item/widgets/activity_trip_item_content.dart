import 'package:user/library.dart';
import 'package:flutter/material.dart';

class ActivityTripItemContent extends StatelessWidget {
  final TripResponse trip;
  final bool showShared;
  final bool showStatus;

  const ActivityTripItemContent({
    super.key,
    required this.trip,
    required this.showShared,
    required this.showStatus
  });

  @override
  Widget build(BuildContext context) {
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
              if(showShared && trip.shared != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.all(Sizing.space(4)),
                  decoration: BoxDecoration(
                    color: CommonUtility.lightenColor(background(trip.shared!.status), 45),
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

  Color background(String status) {
    switch (status.toLowerCase()) {
      case "waiting":
        return Colors.brown;
      case "active":
        return Colors.pinkAccent;
      default:
        return Colors.black12;
    }
  }

  Color text(String status) {
    switch (status.toLowerCase()) {
      case "waiting":
        return Colors.white;
      case "active":
        return Colors.pink[900] ?? Colors.black12;
      default:
        return Colors.black;
    }
  }
}
