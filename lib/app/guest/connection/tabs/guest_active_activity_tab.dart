import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestActiveActivityTab extends StatelessWidget {
  final GuestHomeController controller;
  const GuestActiveActivityTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.isFetchingTrips.value) {
        return LoadingShimmer(
          content: ListView.builder(
            itemCount: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.sizeOf(context).width,
                margin: EdgeInsets.only(bottom: Sizing.space(5)),
                padding: const EdgeInsets.all(12.0),
                height: 70,
                color: CommonColors.shimmerHigh,
              );
            }
          )
        );
      } else if(controller.state.actives.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: 0.5,
                child: Icon(
                  Icons.inbox_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 100
                ),
              ),
              const SizedBox(height: 6),
              SText(
                text: "No active trips",
                color: Theme.of(context).primaryColorDark,
                size: Sizing.font(16)
              ),
            ],
          )
        );
      } else {
        return ListView.builder(
          itemCount: controller.state.actives.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TripResponse trip = controller.state.actives[index];

            return TripBox(
              trip: trip,
              onTap: () => GuestActiveTripView.open(trip),
              showShare: true,
              showTimeline: true
            );
          },
        );
      }
    });
  }
}