import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActiveTripView extends StatelessWidget {
  final TripResponse trip;
  const ActiveTripView({super.key, required this.trip});

  static void open(TripResponse trip) {
    Navigate.bottomSheet(
      sheet: ActiveTripView(trip: trip),
      route: "/activity/trip/active?id=${trip.id}",
      isScrollable: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedBottomSheet(
      safeArea: true,
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      child: GetBuilder<ActiveTripViewController>(
        init: ActiveTripViewController(trip: trip),
        builder: (controller) {
          return Obx(() {
            TripResponse selected = controller.state.trip.value;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(Sizing.space(12)),
                    color: Theme.of(context).colorScheme.surface,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const GoBack(size: 30, radius: 10, icon: Icons.arrow_back),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SText(
                                text: "You are on a trip with ${CommonUtility.textWithAorAn(selected.category)}",
                                size: Sizing.font(18),
                                weight: FontWeight.bold,
                                color: Theme.of(context).primaryColor
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              padding: EdgeInsets.all(Sizing.space(4)),
                              decoration: BoxDecoration(
                                color: Theme.of(context).appBarTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: CategoryImage(image: selected.image, width: 60, height: 60)
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(Sizing.space(12)),
                    color: Theme.of(context).colorScheme.surface,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SText(
                          text: selected.label,
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColorLight
                        ),
                        SText(
                          text: selected.mode,
                          size: Sizing.font(12),
                          color: Theme.of(context).primaryColorLight
                        ),
                      ]
                    ),
                  ),
                  if(selected.amount.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      color: Theme.of(context).colorScheme.surface,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SText(
                            text: 'Workmanship',
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                          const SizedBox(width: 10),
                          SText(
                            text: selected.amount,
                            size: Sizing.font(14),
                            color: Theme.of(context).primaryColor
                          ),
                        ]
                      ),
                    )
                  ],
                  if(selected.problem.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      color: Theme.of(context).colorScheme.surface,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SText(
                            text: 'Problem Description',
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                          const SizedBox(height: 10),
                          SText(
                            text: selected.problem,
                            size: Sizing.font(14),
                            color: Theme.of(context).primaryColor
                          ),
                        ]
                      ),
                    )
                  ] else if(selected.audio.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      color: Theme.of(context).colorScheme.surface,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          SText(
                            text: 'Problem Description',
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                          const SizedBox(height: 10),
                          Obx(() => Slider(
                            value: controller.state.currentPosition.value,
                            max: controller.state.totalDuration.value,
                            onChanged: controller.seek,
                            activeColor: Theme.of(context).primaryColorLight,
                            inactiveColor: CommonColors.shimmerBase.withOpacity(.48),
                            thumbColor: Theme.of(context).primaryColor,
                          )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => SText(
                                  text: controller.playingTime(),
                                  color: Theme.of(context).primaryColor
                              )),
                              Obx(() => CircledButton(
                                icon: controller.state.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                title: controller.state.isPlaying.value ? "Pause" : "Play",
                                iconColor: Theme.of(context).primaryColor,
                                onClick: controller.state.isPlaying.value ? controller.pauseAudio : controller.playAudio,
                              )),
                            ],
                          ),
                        ]
                      ),
                    )
                  ] else ...[
                    const SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      color: Theme.of(context).colorScheme.surface,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SText(
                            text: 'Problem Description',
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                          const SizedBox(height: 10),
                          SText(
                            text: "This request was made based on the discussion you had with the provider involved.",
                            size: Sizing.font(14),
                            color: Theme.of(context).primaryColor
                          ),
                        ]
                      ),
                    )
                  ],
                  if(selected.provider != null) ...[
                    const SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      color: Theme.of(context).colorScheme.surface,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SText(
                            text: 'Provider Profile',
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                          const SizedBox(height: 10),
                          TripProfile(user: selected.provider!)
                        ]
                      ),
                    )
                  ],
                  if(selected.timelines.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      padding: EdgeInsets.all(Sizing.space(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SText(
                            text: 'Trip Timeline',
                            size: Sizing.font(14),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: ListView.builder(
                              itemCount: selected.timelines.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                TimelineResponse timeline = selected.timelines[index];
                                bool showBottom = index != selected.timelines.length - 1;

                                return TripStep(
                                  header: timeline.header,
                                  description: timeline.description,
                                  label: timeline.label,
                                  isOver: timeline.isOver,
                                  showBottom: showBottom,
                                  height: _buildHeight(selected, timeline),
                                  custom: _buildChild(context, selected, timeline, controller)
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                  if(selected.shared != null && selected.shared!.category.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      color: Theme.of(context).colorScheme.surface,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SText(
                            text: 'Shared Trip Information',
                            size: Sizing.font(16),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                          if(selected.shared!.profile != null) ...[
                            const SizedBox(height: 5),
                            Divider(color: Theme.of(context).scaffoldBackgroundColor),
                            const SizedBox(height: 5),
                            SText(
                              text: 'Shared Provider Profile',
                              size: Sizing.font(14),
                              weight: FontWeight.bold,
                              color: Theme.of(context).primaryColor
                            ),
                            const SizedBox(height: 10),
                            TripProfile(user: selected.shared!.profile!)
                          ],
                          if(selected.shared!.isOffline && selected.shared!.showAuth) ...[
                            const SizedBox(height: 20),
                            Center(
                              child: OtpField(
                                controller: controller.authController,
                                focusNode: controller.authFocusNode,
                                length: 4,
                                onCompleted: controller.verifySharedAuth,
                                onChanged: (code) => controller.state.authToken.value = code,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Obx(() => LoadingButton(
                                text: "Verify identity",
                                buttonColor: CommonColors.darkTheme,
                                textColor: CommonColors.lightTheme,
                                padding: EdgeInsets.all(Sizing.space(8)),
                                loading: controller.state.isVerifying.value,
                                onClick: () => controller.verifySharedAuth(controller.state.authToken.value),
                              )),
                            ),
                          ] else if(selected.shared!.timelines.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Divider(color: Theme.of(context).scaffoldBackgroundColor),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
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

                                        return TripStep(
                                          header: timeline.header,
                                          description: timeline.description,
                                          label: timeline.label,
                                          isOver: timeline.isOver,
                                          showBottom: showBottom,
                                          height: _buildSharedHeight(selected.shared!, timeline),
                                          custom: _buildSharedChild(context, selected.shared!, selected.id, timeline, controller)
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
                    ),
                  ]
                ],
              )
            );
          });
        },
      )
    );
  }

  double? _buildHeight(TripResponse trip, TimelineResponse timeline) {
    if (timeline.isOver && timeline.isRequested && trip.showCancel) {
      return 80;
    } else if (timeline.isOver && timeline.isArrived && trip.showAuth) {
      return 120;
    } else if (timeline.isOver && timeline.isActive) {
      if (trip.showGrant && trip.showEnd) {
        return 150;
      } else if(trip.showEnd) {
        return 100;
      }
    } else if (timeline.isAccessGranted && trip.showShare) {
      return 100;
    } else if (timeline.isOver && (timeline.isAccessDenied || timeline.isAccessGranted) && trip.showGrant) {
      return 80;
    }
    return null;
  }

  Widget? _buildChild(BuildContext context, TripResponse trip, TimelineResponse timeline, ActiveTripViewController controller) {
    if (timeline.isRequested && trip.showCancel) {
      return Column(
        children: [
          const SizedBox(height: 10),
          LoadingButton(
            text: "Cancel trip",
            width: MediaQuery.of(context).size.width,
            buttonColor: CommonColors.error,
            textColor: CommonColors.lightTheme,
            padding: EdgeInsets.all(Sizing.space(6)),
            onClick: () => CancelTripSheet.open(
              trip: trip.id,
              isInvite: false,
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
            onCompleted: controller.verifyAuth,
            onChanged: (code) => controller.state.authToken.value = code,
          ),
          const SizedBox(height: 10),
          Obx(() => LoadingButton(
            text: "Verify identity",
            width: MediaQuery.of(context).size.width,
            buttonColor: CommonColors.darkTheme,
            textColor: CommonColors.lightTheme,
            padding: EdgeInsets.all(Sizing.space(6)),
            loading: controller.state.isVerifying.value,
            onClick: () => controller.verifyAuth(controller.state.authToken.value),
          )),
        ],
      );
    } else if (timeline.isActive) {
      return Column(
        children: [
          const SizedBox(height: 10),
          if (trip.showGrant) ...[
            Obx(() => LoadingButton(
              text: "Grant share access",
              width: MediaQuery.of(context).size.width,
              buttonColor: CommonColors.allday,
              padding: EdgeInsets.all(Sizing.space(6)),
              textColor: CommonColors.lightTheme,
              loading: controller.state.isGrantingAccess.value,
              onClick: controller.grantAccess,
            )),
          ],
          if (trip.showGrant && trip.showEnd) ...[
            const SizedBox(height: 20),
          ],
          if (trip.showEnd) ...[
            Obx(() => LoadingButton(
              text: "End trip",
              padding: EdgeInsets.all(Sizing.space(6)),
              width: MediaQuery.of(context).size.width,
              buttonColor: CommonColors.error,
              textColor: CommonColors.lightTheme,
              loading: controller.state.isEnding.value,
              onClick: controller.end,
            )),
          ],
        ],
      );
    } else if (timeline.isAccessGranted && trip.showShare) {
      return Column(
        children: [
          const SizedBox(height: 10),
          Obx(() => LoadingButton(
            text: "Revoke share access",
            padding: EdgeInsets.all(Sizing.space(6)),
            buttonColor: CommonColors.error,
            width: MediaQuery.of(context).size.width,
            textColor: CommonColors.lightTheme,
            loading: controller.state.isDenyingAccess.value,
            onClick: controller.denyAccess,
          )),
        ],
      );
    }
    return null;
  }

  double? _buildSharedHeight(SharedTripResponse trip, TimelineResponse timeline) {
    if (timeline.isOver && timeline.isRequested && trip.showCancel) {
      return 80;
    } else if (timeline.isOver && timeline.isArrived && trip.showAuth) {
      return 120;
    }
    return null;
  }

  Widget? _buildSharedChild(
    BuildContext context,
    SharedTripResponse trip,
    String tripId,
    TimelineResponse timeline,
    ActiveTripViewController controller
  ) {
    if (timeline.isRequested && trip.showCancel) {
      return Column(
        children: [
          const SizedBox(height: 10),
          LoadingButton(
            text: "Cancel trip",
            width: MediaQuery.of(context).size.width,
            buttonColor: CommonColors.error,
            textColor: CommonColors.lightTheme,
            padding: EdgeInsets.all(Sizing.space(6)),
            onClick: () => CancelTripSheet.open(
              trip: tripId,
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
          Obx(() => LoadingButton(
            text: "Verify identity",
            width: MediaQuery.of(context).size.width,
            buttonColor: CommonColors.darkTheme,
            textColor: CommonColors.lightTheme,
            padding: EdgeInsets.all(Sizing.space(6)),
            loading: controller.state.isVerifying.value,
            onClick: () => controller.verifySharedAuth(controller.state.authToken.value),
          )),
        ],
      );
    }
    return null;
  }
}