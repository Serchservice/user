import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActivityActiveTripViewAction extends StatelessWidget {
  final ActivityActiveTripViewController controller;
  final TimelineResponse timeline;

  const ActivityActiveTripViewAction({super.key, required this.controller, required this.timeline});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      TripResponse trip = controller.state.trip.value;

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
              onClick: () => ActivityTripCancel.open(trip: trip.id, isInvite: false, onSuccess: controller.cancel),
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
              onCompleted: controller.verifyAuth,
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
              onClick: () => controller.verifyAuth(controller.state.authToken.value),
            ),
          ],
        );
      } else if (timeline.isActive) {
        return Column(
          children: [
            const SizedBox(height: 10),
            if (trip.showGrant) ...[
              LoadingButton(
                text: "Grant share access",
                width: MediaQuery.sizeOf(context).width,
                buttonColor: CommonColors.allday,
                padding: EdgeInsets.all(Sizing.space(6)),
                textColor: CommonColors.lightTheme,
                loading: controller.state.isGrantingAccess.value,
                onClick: controller.grantAccess,
              ),
            ],
            if (trip.showGrant && trip.showEnd) ...[
              const SizedBox(height: 20),
            ],
            if (trip.showEnd) ...[
              LoadingButton(
                text: "End trip",
                padding: EdgeInsets.all(Sizing.space(6)),
                width: MediaQuery.sizeOf(context).width,
                buttonColor: CommonColors.error,
                textColor: CommonColors.lightTheme,
                loading: controller.state.isEnding.value,
                onClick: controller.end,
              ),
            ],
          ],
        );
      } else if (timeline.isAccessGranted && trip.showShare) {
        return Column(
          children: [
            const SizedBox(height: 10),
            LoadingButton(
              text: "Revoke share access",
              padding: EdgeInsets.all(Sizing.space(6)),
              buttonColor: CommonColors.error,
              width: MediaQuery.sizeOf(context).width,
              textColor: CommonColors.lightTheme,
              loading: controller.state.isDenyingAccess.value,
              onClick: controller.denyAccess,
            ),
          ],
        );
      }

      return Container();
    });
  }
}
