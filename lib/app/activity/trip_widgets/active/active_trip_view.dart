import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class ActiveTripView extends StatelessWidget {
  final TripResponse trip;
  const ActiveTripView({super.key, required this.trip});

  static void open(TripResponse trip) {
    Navigate.toPage(
      widget: ActiveTripView(trip: trip),
      route: "/activity/trip/active?id=${trip.id}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActiveTripViewController>(
      init: ActiveTripViewController(trip: trip),
      autoRemove: false,
      builder: (controller) {
        return MainLayout(
          floaterPosition: 0,
          floater: _buildFloater(context, controller),
          child: _buildMap(context, controller),
        );
      }
    );
  }

  Widget _buildMap(BuildContext context, ActiveTripViewController controller) {
    return Obx(() {
      TripResponse selected = controller.state.trip.value;
      bool showSharedMap = selected.showShare && controller.state.isSharedOnTheWay.value && selected.shared != null
          && selected.shared!.location.isNotEmpty;
      bool showMap = controller.state.isProviderOnTheWay.value && selected.location.isNotEmpty;

      if(showSharedMap) {
        return MapView(
          isTop: true,
          origin: selected.toAddress(),
          destination: selected.shared!.location.toAddress(),
          height: Get.height,
          subscriptionEndpoint: "/platform/location/${trip.id}/${Database.auth.id}"
        );
      } else if(showMap) {
        return MapView(
          isTop: true,
          origin: selected.toAddress(),
          destination: selected.location.toAddress(),
          height: Get.height,
          subscriptionEndpoint: "/platform/location/${trip.id}/${Database.auth.id}"
        );
      } else {
        return MapView(isTop: true, origin: selected.toAddress(), height: Get.height);
      }
    });
  }

  Widget _buildFloater(BuildContext context, ActiveTripViewController controller) {
    return Obx(() {
      if(controller.state.isMinimized.value) {
        return Animate(child: _buildHeader(context, controller)).slideY(duration: 500.ms);
      } else {
        return Animate(child: _buildBody(context, controller)).slideY(duration: 500.ms, begin: Get.height - 120);
      }
    });
  }

  Widget _buildHeader(BuildContext context, ActiveTripViewController controller) {
    return Container(
      padding: EdgeInsets.all(Sizing.space(12)),
      color: Theme.of(context).appBarTheme.backgroundColor,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const GoBack(size: 30, radius: 10, icon: Icons.arrow_back),
              const Expanded(child: SizedBox(width: 15)),
              Obx(() => LoadingButton(
                text: controller.state.isMinimized.value ? "View details" : "Minimize details",
                buttonColor: Theme.of(context).colorScheme.surface,
                textColor: Theme.of(context).primaryColor,
                textSize: 12,
                borderRadius: 30,
                padding: EdgeInsets.all(Sizing.space(6)),
                onClick: controller.state.isMinimized.toggle,
              ))
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(() => SText(
                  text: "You are on a trip with ${CommonUtility.textWithAorAn(controller.state.trip.value.category)}",
                  size: Sizing.font(18),
                  weight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                )),
              ),
              const SizedBox(width: 20),
              Container(
                padding: EdgeInsets.all(Sizing.space(4)),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Obx(() => CategoryImage(image: controller.state.trip.value.image, width: 60, height: 60))
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget _buildBody(BuildContext context, ActiveTripViewController controller) {
    return Obx(() {
      TripResponse selected = controller.state.trip.value;

      return Container(
        height: Get.height - 120,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, controller),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(Sizing.space(12)),
                      color: Theme.of(context).appBarTheme.backgroundColor,
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
                        color: Theme.of(context).appBarTheme.backgroundColor,
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
                        color: Theme.of(context).appBarTheme.backgroundColor,
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
                        color: Theme.of(context).appBarTheme.backgroundColor,
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
                        color: Theme.of(context).appBarTheme.backgroundColor,
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
                        color: Theme.of(context).appBarTheme.backgroundColor,
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
                        color: Theme.of(context).appBarTheme.backgroundColor,
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
              ),
            ),
          ],
        ),
      );
    });
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

extension on TripResponse {
  Address toAddress() {
    return Address(
      id: id,
      latitude: latitude,
      longitude: longitude,
      place: address,
    );
  }
}

extension on MapViewResponse {
  Address toAddress() {
    return Address(
      id: "",
      latitude: latitude,
      longitude: longitude,
      place: place,
    );
  }
}