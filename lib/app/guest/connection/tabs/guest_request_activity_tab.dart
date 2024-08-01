import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class GuestRequestActivityTab extends StatelessWidget {
  final GuestHomeController controller;
  const GuestRequestActivityTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.state.isFetchingTripInvites.value) {
        return LoadingShimmer(
          content: ListView.builder(
            itemCount: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: Sizing.space(5)),
                padding: const EdgeInsets.all(12.0),
                height: 70,
                color: CommonColors.shimmerHigh,
              );
            }
          )
        );
      } else if(controller.state.invites.isEmpty) {
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
                text: "No invites",
                color: Theme.of(context).primaryColorDark,
                size: Sizing.font(16)
              ),
            ],
          )
        );
      } else {
        return ListView.builder(
          itemCount: controller.state.invites.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TripResponse trip = controller.state.invites[index];
            return TripBox(trip: trip, onTap: () => GuestRequestedTripView.open(trip));
          },
        );
      }
    });
  }
}