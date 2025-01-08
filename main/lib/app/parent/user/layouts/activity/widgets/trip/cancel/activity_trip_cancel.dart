import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityTripCancel extends StatelessWidget {
  final String trip;
  final bool isShared;
  final bool isInvite;
  final Function(List<TripResponse>, bool) onSuccess;

  const ActivityTripCancel({
    super.key,
    required this.trip,
    required this.onSuccess,
    this.isShared = false,
    required this.isInvite
  });

  static void open({
    required String trip,
    required Function(List<TripResponse>, bool) onSuccess,
    bool isShared = false,
    required bool isInvite
  }) {
    String route = "/activity/request/trip/cancel?id=$trip";

    Navigate.bottomSheet(
      sheet: ActivityTripCancel(trip: trip, onSuccess: onSuccess, isShared: isShared, isInvite: isInvite),
      route: Database.isUserActive ? route : "/guest$route",
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      child: GetBuilder<ActivityTripCancelController>(
        init: ActivityTripCancelController(
          trip: trip,
          isShared: isShared,
          onSuccess: onSuccess,
          isInvite: isInvite
        ),
        builder: (controller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(Sizing.space(2)),
                  margin: EdgeInsets.all(Sizing.space(6)),
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(16)
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        SText(
                          text: "Cancel Trip Request",
                          size: Sizing.font(16),
                          weight: FontWeight.bold,
                          color: Theme.of(context).primaryColor
                        ),
                        SText(
                          text: "Help us understand why you want to cancel this trip request",
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColorLight
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Field(
                    padding: const EdgeInsets.all(8),
                    hintText: "Cancellation Reason (Optional)",
                    keyboard: TextInputType.text,
                    controller: controller.textController,
                    isBig: true,
                    needLabel: true,
                    labelColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 50),
                  Obx(() => LoadingButton(
                    text: "Cancel trip",
                    borderRadius: 24,
                    padding: EdgeInsets.all(Sizing.space(12)),
                    textSize: Sizing.font(14),
                    width: MediaQuery.sizeOf(context).width,
                    onClick: controller.cancel,
                    buttonColor: CommonColors.error,
                    textColor: CommonColors.lightTheme,
                    loading: controller.state.isCancelling.value,
                  ))
                ],
              )
            ],
          );
        }
      )
    );
  }
}