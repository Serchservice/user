import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user/library.dart';

class TripHistoryView extends StatelessWidget {
  final TripResponse trip;
  const TripHistoryView({super.key, required this.trip});

  static void open(TripResponse trip) {
    Navigate.toPage(
      widget: TripHistoryView(trip: trip),
      route: "/activity/trip/history?id=${trip.id}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<TripHistoryViewController>(
      init: TripHistoryViewController(trip: trip),
      builder: (controller) {
        TripResponse selected = controller.state.trip.value;

        return MainLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(Sizing.space(12)),
                color: Theme.of(context).appBarTheme.backgroundColor,
                width: MediaQuery.sizeOf(context).width,
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
                            text: "You requested for ${CommonUtility.textWithAorAn(selected.category)}",
                            size: Sizing.font(18),
                            weight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          padding: EdgeInsets.all(Sizing.space(4)),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: CategoryImage(image: selected.image, width: 60, height: 60)
                        ),
                      ],
                    ),
                  ],
                )
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      MapView(origin: controller.state.trip.value.toAddress(), height: 200),
                      const SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(Sizing.space(12)),
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        width: MediaQuery.sizeOf(context).width,
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
                      const SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(Sizing.space(12)),
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SText(
                              text: "Trip Id",
                              size: Sizing.font(12),
                              color: Theme.of(context).primaryColorLight
                            ),
                            SText(
                              text: selected.id.replaceAll("STRIP-", "#").substring(0, 8).toUpperCase(),
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
                          width: MediaQuery.sizeOf(context).width,
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
                          width: MediaQuery.sizeOf(context).width,
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
                          width: MediaQuery.sizeOf(context).width,
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
                          width: MediaQuery.sizeOf(context).width,
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
                          width: MediaQuery.sizeOf(context).width,
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
                              TripProfile(user: selected.provider!, needPhone: false)
                            ]
                          ),
                        )
                      ],
                      if(selected.timelines.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
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
                          width: MediaQuery.sizeOf(context).width,
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
                                TripProfile(user: selected.shared!.profile!, needPhone: false)
                              ],
                              if(!selected.shared!.isOffline && selected.shared!.timelines.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                Divider(color: Theme.of(context).scaffoldBackgroundColor),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
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
      },
    );
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