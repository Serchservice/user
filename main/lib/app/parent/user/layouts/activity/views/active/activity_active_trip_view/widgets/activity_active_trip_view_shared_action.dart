import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityActiveTripViewSharedAction extends StatelessWidget {
  final ActivityActiveTripViewController controller;
  final TimelineResponse timeline;

  const ActivityActiveTripViewSharedAction({super.key, required this.controller, required this.timeline});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      TripResponse trip = controller.state.trip.value;
      SharedTripResponse? shared = trip.shared;

      if(shared != null) {
        if (timeline.isRequested && trip.showCancel) {
          return Column(
            children: [
              const SizedBox(height: 10),
              LoadingButton(
                text: "Cancel trip",
                width: MediaQuery.sizeOf(context).width,
                buttonColor: CommonColors.error,
                textColor: CommonColors.lightTheme,
                padding: EdgeInsets.all(Sizing.space(6)),
                onClick: () => ActivityTripCancel.open(
                  trip: trip.id,
                  isInvite: false,
                  isShared: true,
                  onSuccess: controller.cancel
                ),
              ),
            ],
          );
        } else if (timeline.isArrived && trip.showAuth) {
          return Column(
            children: [
              const SizedBox(height: 10),
              OtpField(
                controller: controller.authController,
                focusNode: controller.authFocusNode,
                isBox: false,
                isFilled: true,
                length: 4,
                onCompleted: controller.verifySharedAuth,
                onChanged: (code) => controller.state.authToken.value = code,
              ),
              const SizedBox(height: 10),
              LoadingButton(
                text: "Verify identity",
                width: MediaQuery.sizeOf(context).width,
                buttonColor: CommonColors.darkTheme,
                textColor: CommonColors.lightTheme,
                padding: EdgeInsets.all(Sizing.space(6)),
                loading: controller.state.isVerifying.value,
                onClick: () => controller.verifySharedAuth(controller.state.authToken.value),
              ),
            ],
          );
        }
      }

      return Container();
    });
  }
}
