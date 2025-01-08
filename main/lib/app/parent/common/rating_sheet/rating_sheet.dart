import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class RatingSheet extends StatelessWidget {
  final Function(String, double) onSuccess;
  final TripResponse? trip;
  final ActiveCallResponse? call;

  const RatingSheet({super.key, required this.onSuccess, this.call, this.trip});

  static void open({required Function(String, double) onSuccess, TripResponse? trip, ActiveCallResponse? call}) {
    Navigate.bottomSheet(
      sheet: RatingSheet(onSuccess: onSuccess, trip: trip, call: call),
      route: trip != null ? "/rating/product/trip?id=${trip.id}" : call != null ? "/rating/product/${call.channel}"
        : "/rating/product/app",
      background: Colors.transparent,
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RatingSheetController>(
      init: RatingSheetController(trip: trip, call: call),
      builder: (controller) {
        if(trip == null && call == null) {
          return RatingSheetApp(controller: controller, onSuccess: onSuccess);
        } else if(trip != null) {
          return RatingSheetTrip(controller: controller, trip: trip!, onSuccess: onSuccess);
        } else if(call != null) {
          return _buildCallRating(context, controller);
        } else {
          return Container();
        }
      }
    );
  }

  Widget _buildCallRating(BuildContext context, RatingSheetController controller) {
    return Container();
  }
}